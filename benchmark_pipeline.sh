#!/bin/bash
#
# complete pipeline

# parse input yaml
# https://stackoverflow.com/questions/5014632/how-can-i-parse-a-yaml-file-from-a-linux-shell-script
# TODO FIND ANOTHER PARSER -- TOO SPECIFIC...
#function parse_yaml {
#   local prefix=$2
#   local s='[[:space:]]*' w='[a-zA-Z0-9_]*' fs=$(echo @|tr @ '\034')
#   sed -ne "s|^\($s\):|\1|" \
#        -e "s|^\($s\)\($w\)$s:$s[\"']\(.*\)[\"']$s\$|\1$fs\2$fs\3|p" \
#        -e "s|^\($s\)\($w\)$s:$s\(.*\)$s\$|\1$fs\2$fs\3|p"  $1 |
#   awk -F$fs '{
#      indent = length($1)/4;
#      vname[indent] = $2;
#      for (i in vname) {if (i > indent) {delete vname[i]}}
#      if (length($3) > 0) {
#         vn=""; for (i=0; i<indent; i++) {vn=(vn)(vname[i])("_")}
#         printf("%s%s%s=\"%s\"\n", "'$prefix'",vn, $2, $3);
#      }
#   }'
#}

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

trap cleanup EXIT

## Parameters : parse yaml for inputs
#parse_yaml ./benchmark.yaml
#eval $(parse_yaml ./benchmark.yaml)
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
echo $data_taxi_gridHeight
python3 $TAXI_PREPROC/build_stream.py --input_file=$taxi_dataDir/nyc_taxi_data.csv --output_file=$TMP/taxi_stream.txt --n=$taxi_gridHeight | exit 1
# prepare data - from Taxi_1000000/cmdes
echo "preparing taxi data"
$UTILS/prepare_data.sh $TMP/taxi_stream.txt $data_taxi_grain 30g 2 > $TMP/out
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



