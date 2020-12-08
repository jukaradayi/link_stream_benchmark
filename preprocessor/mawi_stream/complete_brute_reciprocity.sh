#!/bin/bash
#

tuv_in=$1
tuv_out=$2
#preprocess and pipe awk reciprocity check
zcat $tuv_in | awk '{if ($3 < $2) {print $1" "$3" "$2} else {print $0}}' $mawi_input | sort -k2,3 -t " " -k1,1n | awk -f brute.awk > $tuv_out 
