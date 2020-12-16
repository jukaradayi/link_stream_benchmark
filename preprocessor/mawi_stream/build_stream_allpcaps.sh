#!/bin/bash
#
# Prepare (t,u,v) from mawi pcap file.
# If keep_ports set to true, keep the ports used for packet transfer in source and
# destination ips
# If check_reciprocity set to true, keep a packet for ip1 -> ip2
# if a packet for ip2 -> ip1 is found in time window (1s)

# parameters
pcap_dir=$1
out_folder=$2
check_reciprocity=$3
keep_ports=$4
memory=$5
cpu=$6

# get current directory
CUR_DIR=$( cd $( dirname ${BASH_SOURCE[0]} ) >/dev/null 2>&1 && pwd )

# create array of all pcaps with glob
# and track number of lines of pcaps
all_pcaps=($pcap_dir/*pcap.gz)

# echo some conf info in log
echo "[$(date)] MAWI: keep ports set to $keep_ports"
echo "[$(date)] MAWI: checking for reciprocity: $check_reciprocity"
echo "[$(date)] MAWI: reading pcap files and extracting udp and tcp transfers"
for ((index=0; index < ${#all_pcaps[@]}; index++)); do

    # get current pcap path and its basename
    pcap=${all_pcaps[index]}
    base_pcap=$(basename $pcap .gz)

    if [ "$check_reciprocity" = true ]; then
        output_file=$out_folder/${base_pcap}.txt.gz
    else
        output_file=$out_folder/mawi_stream.txt.gz
    fi

    echo "[$(date)] MAWI: reading $base_pcap" 
    if [ "$keep_ports" = true ]; then
        unpigz -c $pcap | tcpdump -ttnnq ip and \( udp or tcp \) -r - | tr ":" " " | cut -d" " -f 1,3,5 | gzip -c >> $output_file
        # $out_folder/${base_pcap}.txt.gz # > $out_folder/mawi_stream.txt #| gzip -c > ~/out.gz
    else
        # remove ports...
        unpigz -c $pcap | tcpdump -ttnnq ip and \( udp or tcp \) -r -  | tr ":" " " | cut -d" " -f 1,3,5 | awk '{split($2, src, "."); split($3, dst, "."); print $1" "src[1]"."src[2]"."src[3]"."src[4]" "dst[1]"."dst[2]"."dst[3]"."dst[4]}' | gzip -c >> $output_file
        # $out_folder/${base_pcap}.txt.gz  #> $out_folder/mawi_stream.txt
    fi
done

echo "[$(date)] MAWI: keeping only reciproc packet transfer..."
if [ "$check_reciprocity" = true ]; then
    for ((index=0; index < ${#all_pcaps[@]}; index++)); do
        cur_pcap=${all_pcaps[index]}
        cur_base_pcap=$(basename $cur_pcap .gz)
        next_pcap=${all_pcaps[index+1]} 
        next_base_pcap=$(basename $next_pcap .gz)

        echo "[$date)] MAWI: reciprocity check for $cur_pcap" # TODO add verbose option
        # append beginning of next pcap to avoid drop of packets $ TODO find suitable N
        # this will add duplicate lines between files but prepare data removes them :)
        if [ -f "$out_folder/${next_base_pcap}.txt.gz" ]; then
            ## TODO Fix by doing awk -t time=$time '{if ($1 < time+1) {print $0} else {exit 0}}'
            zcat $out_folder/${next_base_pcap}.txt.gz | head -79700 | gzip -c >> $out_folder/${cur_base_pcap}.txt.gz
        fi
    
        # pipe output of sort to awk to avoid writing to disk...
        mv $out_folder/${cur_base_pcap}.txt.gz $out_folder/${cur_base_pcap}_tmp.txt.gz
        ## TODO : merge into 1 big file or keep as separated files ?
        unpigz -c $out_folder/${cur_base_pcap}_tmp.txt.gz | awk '{if ($3 < $2) {print $1" "$3" "$2" "1} else {print $0" "0}}' | sort -k2,3 -t " " -k1,1n -S$memory --parallel=$cpu -T/home/jkaradayi| awk -f $CUR_DIR/brute.awk | gzip -c >> $out_folder/mawi_stream.txt.gz
        rm $out_folder/${cur_base_pcap}_tmp.txt.gz  # TODO juste pour comparer avec / sans reciprocité
    done
fi

