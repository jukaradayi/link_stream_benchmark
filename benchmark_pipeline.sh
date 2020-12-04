#!/bin/bash
#
# complete pipeline
set -e
export LC_ALL=C

# prepare data
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

## DIRECTORIES
# get current script path - works with bash
CUR_DIR=$( cd $( dirname ${BASH_SOURCE[0]} ) >/dev/null 2>&1 && pwd )
GENBIP=$CUR_DIR/utils/genbip/genbip
TAXI_PREPROC=$CUR_DIR/utils/nyc_taxi_stream/nyc_taxi_stream
UTILS=$CUR_DIR/utils
TMP=$(mktemp -d -t benchmark-XXXXXXXXXX)
echo $TMP

# cleanup on exit
function cleanup {
    rm -rf $TMP
}

#trap cleanup EXIT

## Parameters : parse yaml for inputs
source benchmark.conf

# Pre process Data 
# TODO mawi taxi etc..
#### MAWI
#if [ $real_data_mawi_params_only_reciproc_links ]; then
#    ./reciprocity_check.sh
## from Mawi_10-5/cmdes
#prepare_data.sh mawi 10 230g 24 > mawi_prepare.out 2> mawi_prepare.err &

### TAXI 
echo "building taxi stream"
python3 $TAXI_PREPROC/build_stream.py --input_file=$taxi_dataDir/nyc_taxi_data.csv --output_file=$TMP/taxi_stream.txt --n=$taxi_gridHeight --simplify 
gzip $TMP/taxi_stream.txt

# prepare data - from Taxi_1000000/cmdes
echo "preparing taxi data"
prepare_data $TMP/taxi_stream.txt $taxi_grain 30g 2 
echo "prepared"
gzip $TMP/taxi_stream.txt.ts
gzip $TMP/taxi_stream.txt.weight

#0.5 30g 10 > out 2> err &

##### PERU
## from Peru/cmdes
#../prepare_data.sh peru 1 80g 20 > out 2> err &
#
#### BITCOIN
## from Bitcoin/cmdes
#../prepare_data.sh bitcoin_full 1 200g 24 >out 2> err &

# generate time series and graph 
#prepare_data

# from time serie and graph, generate link stream using genbip
#python genbip
python $GENBIP/cli.py  --top $TMP/taxi_stream.txt.weight.gz --bot $TMP/taxi_stream.txt.ts.gz --gen havelhakimi --out $TMP/taxi_bip


