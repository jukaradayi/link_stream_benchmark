#!/bin/bash
#
# complete pipeline

# prepare environment
set -e
export LC_ALL=C

# load functions
source ./functions.sh

# define directories
## get current script path - works with bash
CUR_DIR=$( cd $( dirname ${BASH_SOURCE[0]} ) >/dev/null 2>&1 && pwd )
GENBIP=$CUR_DIR/utils/genbip/genbip
TAXI_PREPROC=$CUR_DIR/utils/nyc_taxi_stream/nyc_taxi_stream
MAWI_PREPROC=$CUR_DIR/utils/mawi_stream
MODEL_GEN=$CUR_DIR/utils/model_generation
UTILS=$CUR_DIR/utils
TMP=$(mktemp -d -t benchmark-XXXXXXXXXX) # temp directory to store partial files
echo $TMP

# cleanup function to call when exiting the main script
function cleanup {
    rm -rf $TMP
}

#trap cleanup EXIT

# Parameters 
source benchmark.conf

# Pre process Data 
## MAWI
if [ "$mawi_process" = true ]; then
    mkdir $TMP/mawi
    bash $MAWI_PREPROC/build_stream.sh $mawi_data_dir/201306021400.dump $TMP $mawi_check_reciprocity $mawi_keep_ports
    gzip $TMP/mawi_stream.txt
   
    prepare_data $TMP/mawi_stream.txt $mawi_grain 30G 2 # > mawi_prepare.out 2> mawi_prepare.err &
    gzip $TMP/mawi_stream.txt.weight
    gzip $TMP/mawi_stream.txt.ts
fi

## TAXI 
if [ "$taxi_process" = true ]; then
    mkdir $TMP/taxi
    echo "building taxi stream"
    python3 $TAXI_PREPROC/build_stream.py --input_file=$taxi_dataDir/nyc_taxi_data.csv --output_file=$TMP/taxi_stream.txt --n=$taxi_gridHeight --simplify 
    gzip $TMP/taxi_stream.txt
    
    echo "preparing taxi data"
    prepare_data $TMP/taxi_stream.txt $taxi_grain 30g 2 
    echo "prepared"
    gzip $TMP/taxi_stream.txt.ts
    gzip $TMP/taxi_stream.txt.weight
fi

## PERU
if [ "$peru_process" = true ]; then
    mkdir $TMP/peru

    prepare_data $peru_dataDir/peru $peru_grain 80g 20 > out 2> err &
fi

## BITCOIN
if [ "$bitcoin_process" = true ]; then
    mkdir $TMP/bitcoin

    prepare_data $bitcoin_dataDir/bitcoin_full $peru_grain 200g 24 >out 2> err &
fi

# Run Models
if [ "$model_process" = true ]; then
    mkdir $TMP/models
    python $MODEL_GEN/generate.py -y $MODEL_GEN/modelGeneration.yaml -o $TMP
    gzip $TMP/model.ts
    gzip $TMP/model.weight
fi

# from time serie and graph, generate link stream using genbip
#python $GENBIP/cli.py  --top $TMP/taxi_stream.txt.weight.gz --bot $TMP/taxi_stream.txt.ts.gz --gen havelhakimi --out $TMP/taxi_bip
python $GENBIP/cli.py  --top $TMP/mawi_stream.txt.weight.gz --bot $TMP/mawi_stream.txt.ts.gz --gen havelhakimi --out $TMP/mawi_bip

python $GENBIP/cli.py  --top $TMP/model.weight.gz --bot $TMP/model.ts.gz --gen havelhakimi --out $TMP/model_bip

