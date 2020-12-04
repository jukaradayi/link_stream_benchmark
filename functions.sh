#!/bin/bash
#
# Define useful functions 
# TODO DOCUMENT MORE


# common function used to generate the timeseries and weight
# distributions from (t,u,v) streams
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

