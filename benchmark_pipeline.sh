#!/bin/bash
#
# complete pipeline

# prepare environment
set -e
export LC_ALL=C

# function definition ## TODO use temp dir and fix output names 
function cleanup {
    rm -rf $TMP
}

function prepare_data {
basename=$1
grain=$2
memory=$3
cpu=$4

echo "remove loops etc."
# take a raw dataset in "t u v" format; remove loops and multiple links *considered undirected*; round timestamps to an int, according to given "$grain", and start it at 0; sort according to time
unpigz -c $basename.gz | awk '{if ($2!=$3) print $0;}' | awk '{if ("$2"<"$3") print $0; else print $1,$3,$2;}' | awk -v g=$grain '{print int($1/g),$2,$3;}' | sort -k1,1n -k2 -u -T. -S$memory --parallel=$cpu | awk '{if (NR==1) first=$1; print $1-first,$2,$3;}' | pigz -c > "$basename".clean.gz
echo "done."

echo "compute time series."
# compute the time series; assumes input is time-ordered
unpigz -c $basename.clean.gz | cut -d" " -f1 | uniq -c | mawk '{print $2,$1;}' > $basename.ts
echo "done."
 
echo "compute graph weights."
# compute the graph weight function, and make each link a unique identifier composed of the two node identifiers u and v separated by a coma: u,v
# assumes node identifiers contain no comma
unpigz -c $basename.clean.gz | mawk '{print $2","$3;}' | sort -T. -S$memory --parallel=$cpu | uniq -c | mawk '{print $2,$1;}' > $basename.weight
echo "done."


echo "compute distributions."
# compute time series and weight distributions
for ext in "ts" "weight"
    do
        cat $basename.$ext | cut -d" " -f2 | sort -T. -S$memory --parallel=$cpu -n | uniq -c | mawk '{print $2,$1;}' > $basename.$ext.d
    done
echo "done."
}

# define directories
## get current script path - works with bash
CUR_DIR=$( cd $( dirname ${BASH_SOURCE[0]} ) >/dev/null 2>&1 && pwd )
GENBIP=$CUR_DIR/utils/genbip/genbip
TAXI_PREPROC=$CUR_DIR/utils/nyc_taxi_stream/nyc_taxi_stream
MAWI_PREPROC=$CUR_DIR/utils/mawi_stream
UTILS=$CUR_DIR/utils
TMP=$(mktemp -d -t benchmark-XXXXXXXXXX)
echo $TMP

# cleanup on exit
#trap cleanup EXIT

# Parameters 
source benchmark.conf

# Pre process Data 
## MAWI
if [ "$mawi_process" = true ]; then
    mkdir $TMP/mawi
    bash $MAWI_PREPROC/build_stream.sh $mawi_dataDir/*pcap $TMP $mawi_check_reciprocity $mawi_keep_ports
    
    prepare_data $TMP/mawi_stream.txt $mawi_grain 230g 24 # > mawi_prepare.out 2> mawi_prepare.err &
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
if [ "$bitcoin_process" = true]; then
    mkdir $TMP/bitcoin

    prepare_data $bitcoin_dataDir/bitcoin_full $peru_grain 200g 24 >out 2> err &
fi

# Run Models
if [ "$model_process" = true]; then
    mkdir $TMP/models

    $UTILS/model_generation
fi

# from time serie and graph, generate link stream using genbip
python $GENBIP/cli.py  --top $TMP/taxi_stream.txt.weight.gz --bot $TMP/taxi_stream.txt.ts.gz --gen havelhakimi --out $TMP/taxi_bip


