#!/bin/bash
#
# Benchmark data preparation pipeline.
# Read configuration file in conf/ and prepare the dataset
# for use in the benchmark. 
# Available preparators in preprocessor:
#  - mawi
#  - nyc_taxi_stream
# Can be used with other stream in 
#       t u v
# format.
# In processor you can also find GTgen, that generates
# randomly picked graphs and timeseries according to parameters
# TODO : séparer raw datasets & data-generated models

# prepare environment
## exit when command fails
set -e
# keep track of the last executed command
trap 'echo "[$(date)]"; last_command=$current_command; current_command=$BASH_COMMAND' DEBUG
# echo an error message before exiting
trap 'echo "[$(date)]"; echo "\"${last_command}\" command filed with exit code $?."' EXIT

# set language to C
export LC_ALL=C

# load data preparation functions
source ./processor/utils.sh

# Load configuration file, default to benchmark.conf
if [ "$#" -lt 1 ]; then
    CONF=conf/benchmark.conf
else
    CONF=$1
fi

# set directories
## get current script path - works with bash
CUR_DIR=$( cd $( dirname ${BASH_SOURCE[0]} ) >/dev/null 2>&1 && pwd )
GENBIP=$CUR_DIR/postprocessor/genbip/genbip
TAXI_PREPROC=$CUR_DIR/preprocessor/nyc_taxi_stream/nyc_taxi_stream
MAWI_PREPROC=$CUR_DIR/preprocessor/mawi_stream
MODEL_GEN=$CUR_DIR/processor/GTgen
TMP=$(mktemp -d -p /home/jkaradayi/temp -t benchmark-XXXXXXXXXX) # temp directory to store partial files
cp $CONF $TMP # copy conf file in temporary folder 
echo "Working in temporary folder $TMP"



# Parameters 
#source benchmark.conf
source $CONF
if [[ ! -d $output ]]; then
    echo "Setting up $output"
    mkdir $output
fi

# cleanup function to call when exiting the main script
function cleanup {
    echo "Removing temporary folder $TMP"
    rm -rf $TMP
}

if [ "$keep_temp" = false ]; then
    trap cleanup EXIT
fi


# setup log - use tmp folder name as log name (unique ...)
log=$output/$(basename $TMP).log
touch $log
echo "log file store in $log"
## From now on, standard and error output is redirected to log 
exec 1>$log 2>&1

#cp benchmark.conf $output
#cp $CONF $output

# Pre process Data 
## MAWI
if [ "$mawi_process" = true ]; then
    echo "[$(date)] building mawi stream"
    mkdir $TMP/mawi
    bash $MAWI_PREPROC/build_stream_allpcaps.sh $mawi_data_dir $TMP/mawi $mawi_check_reciprocity $mawi_keep_ports $memory $cpu 
    #gzip $TMP/mawi/mawi_stream.txt
    #exit
   
    prepare_data $TMP/mawi/mawi_stream.txt $mawi_grain $memory $cpu # 30G 2 # > mawi_prepare.out 2> mawi_prepare.err &
    #gzip $TMP/mawi/mawi_stream.txt.weight
    #gzip $TMP/mawi/mawi_stream.txt.ts
    #exit
fi

## TAXI 
if [ "$taxi_process" = true ]; then
    mkdir $TMP/taxi
    echo "[$(date)] building taxi stream"
    python3 $TAXI_PREPROC/build_stream.py --input_file=$taxi_data_dir --output_file=$TMP/taxi/taxi_stream.txt --n=$taxi_gridHeight --simplify 
    gzip $TMP/taxi/taxi_stream.txt
    
    echo "[$(date)] preparing taxi data"
    prepare_data $TMP/taxi/taxi_stream.txt $taxi_grain $memory $cpu # 30g 2 
    #gzip $TMP/taxi/taxi_stream.txt.ts
    #gzip $TMP/taxi/taxi_stream.txt.weight
fi

## PERU
if [ "$peru_process" = true ]; then
    mkdir $TMP/peru
    echo "[$(date)] preparing peru data" 
    prepare_data $peru_data_dir/peru $peru_grain $memory $cpu #> out# 2>err &
    #80g 20 > out 2> err &
fi

## BITCOIN
if [ "$bitcoin_process" = true ]; then
    mkdir $TMP/bitcoin
    echo "[$(date)] preparing bitcoin data" 
    prepare_data $bitcoin_data_dir/bitcoin_full $bitcoin_grain $memory $cpu #> out 2>err &
    #200g 24 >out 2> err &
fi

## GENERIC TUV
if [ "$tuv_process" = true ]; then
    mkdir $TMP/tuv
    echo "[$(date)] preparing custom (t,u,v) stream" 
    prepare_data $bitcoin_data_dir/bitcoin_full $peru_grain $memory $cpu #> out 2>err &
    #200g 24 >out 2> err &
fi
   

## Run Models
if [ "$model_process" = true ]; then
    mkdir $TMP/models
    echo "[$(date)] generating randomly picked graphs and timeserie" 
    python $MODEL_GEN/generate.py -y $MODEL_GEN/modelGeneration.yaml -o $TMP/models
    gzip $TMP/models/model.ts
    gzip $TMP/models/model.weight
fi

# from time serie and graph, generate link stream using genbip
#python $GENBIP/cli.py  --top $TMP/taxi/taxi_stream.txt.weight.gz --bot $TMP/taxi/taxi_stream.txt.ts.gz --gen havelhakimi --out $TMP/taxi_bip
#python $GENBIP/cli.py  --top $TMP/mawi_stream.txt.weight.gz --bot $TMP/mawi_stream.txt.ts.gz --gen havelhakimi --out $output/mawi.bip
#python $GENBIP/cli.py  --top $TMP/models/model.weight.gz --bot $TMP/models/model.ts.gz --gen havelhakimi --out $output/model.bip

