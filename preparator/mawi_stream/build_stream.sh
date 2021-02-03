#!/bin/bash
#
# Authors: Matthieu Latapy, Julien Karadayi (julien.karadayi@gmail.com)
# 
# Get mawi data in pcap format, extract stream in (t,u,v) format
# with only udp and tcp exchanges, where t is the time in seconds,
# u and v are the source and destination (undirected) ips (with or
# without port, depending on $keep_ports).

# parameters
pcap=$1
out_folder=$2
check_reciprocity=$3
keep_ports=$4
CUR_DIR=$( cd $( dirname ${BASH_SOURCE[0]} ) >/dev/null 2>&1 && pwd )
echo $pcap

if [ "$keep_ports" = true ]; then
    unpigz -c $pcap | tcpdump -ttnnq ip and \( udp or tcp \) -r - | tr ":" " " | cut -d" " -f 1,3,5 | gzip -c > $out_folder/mawi_stream.txt.gz # > $out_folder/mawi_stream.txt #| gzip -c > ~/out.gz
else
    tcpdump -ttnnq ip and \( udp or tcp \) -r $pcap  | tr ":" " " | cut -d" " -f 1,3,5 | awk '{split($2, src, "."); split($3, dst, "."); print $1" "src[1]"."src[2]"."src[3]"."src[4]" "dst[1]"."dst[2]"."dst[3]"."dst[4]}' | gzip -c > $out_folder/mawi_stream.txt.gz  #> $out_folder/mawi_stream.txt
fi


if [ "$check_reciprocity" = true ]; then
    mv $out_folder/mawi_stream.txt.gz $out_folder/mawi_stream_tmp.txt.gz
    unpigz -c $out_folder/mawi_stream_tmp.txt.gz | awk '{if ($3 < $2) {print $1" "$3" "$2" "1} else {print $0" "0}}' | sort -k2,3 -t " " -k1,1n | awk -f $CUR_DIR/brute.awk | gzip -c > $out_folder/mawi_stream.txt.gz
    #rm $out_folder/mawi_stream_tmp.txt # TODO juste pour comparer avec / sans reciprocité
fi
