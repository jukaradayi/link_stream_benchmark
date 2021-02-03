#!/usr/bin/bash
#
# Quick script to download Mawi daylong dataset for specific year.
# Three datasets are available, 2018, 2019 and 2020 (this one is only an
# 8 hour long trace)

# check arguments
if [ "$#" -lt 1 ]; then
    echo "Usage is"
    echo "bash download.sh $year"
    echo "where year is"
    echo "   2018"
    echo "   2019"
    echo "   2020"
    exit 0
fi

# check year
year=$1
case $year in 
   2018|2019|2020)   
           echo "downloading Mawi Daylong trace for $year"
           ;;
   *)
           echo "Invalid year, exiting" 
           exit 1
           ;;
esac

# download webpage to get timestamps to download
wget -a wget_log_mawi.log http://mawi.wide.ad.jp/mawi/ditl/ditl${year}-G/ | exit 1
cat index.html | grep href | cut -d '=' -f 2 | cut -d '.' -f 1 > mawi_time_idx.txt

# remove timestamps file and index.html on exit
trap 'rm mawi_time_idx.txt; rm index.html' EXIT

# download each 15 minutes pcap file
while IFS= read -r line; do 
    year=${line:0:4}
    wget --spider -a wget_log_mawi.log http://mawi.nezu.wide.ad.jp/mawi/ditl/ditl${year}-G/${line}.pcap.gz
 done < mawi_time_idx.txt
