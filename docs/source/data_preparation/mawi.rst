.. _MAWI:

Mawi
====

* The `MAWI dataset <http://MAWI.wide.ad.jp/MAWI/>`_ is made of 24 hours long
  IP traffic traces.

* For the purpose of the benchmark, we used the daylong trace from `04/09/2019 <http://mawi.wide.ad.jp/mawi/ditl/ditl2019-G/>`_. A `download script <https://github.com/jukaradayi/link_stream_benchmark/blob/master/preparator/mawi_stream/download.sh>`_ is available in the benchmark repository to download daylong traces from 05/09/2018, 04/09/2019 or 04/08/2020(incomplete day), but other daylong traces can be used with the following preparation.

* Only the UDP and TCP transfer are kept, and the transfers are considered
  undirected. 

Plots
-----

.. figure:: ../_static/mawi_stream.txt.degree.png
   :scale: 50 %
   :align: left

   The degree distribution of the MAWI dataset

.. figure:: ../_static/mawi_stream.txt.weight.png
   :scale: 50 %
   :align: right

   The weight distribution of the MAWI dataset

.. figure:: ../_static/mawi_stream.txt.ts.png
   :scale: 50 %
   :align: center

   The timeserie of the MAWI dataset


Data preparation
----------------

* The `pcap` input data is read using `tcpdump` to extract TCP and UDP packet transfers.
  From the input data, only the timestamps t, the source IP ip_s and the destination IP ip_d are kept, which we will note (t, ip_s, ip_d).

* The command line used to extract the trafic is:

.. code-block:: bash

   tcpdump -ttnnq ip and \( udp or tcp \) -r - 
   
* The output can then be piped to get the specific format. In particular we use the following to keep only the timestamp and IP addresses:

.. code-block:: bash
  
   cut -d" " -f 1,3,5 

* Also the following awk command removes the ports used for the data transfer:

.. code-block:: bash 

   awk '{split($2, src, "."); split($3, dst, "."); print $1" "src[1]"."src[2]"."src[3]"."src[4]" "dst[1]"."dst[2]"."dst[3]"."dst[4]}'

Reciprocity Check
-----------------

.. note::
   In the output format, we consider the links undirected. However, for
   the purpose of the Reciprocity Check, the direction is important.
   In this paragraph, (t0, ip1, ip2) means that the source of the packet was
   ip1 and the destination ip2.

* A packet (t0, ip_s, ip_d) is kept if and only if a recriproc packet
  (t1, ip_d, ip_s) where `|t1 - t0| < 1s`.

* This choice was made to remove transfer where one IP address spams a span of
  IP addresses

* The data is put in the following format:

.. code-block:: bash

   t0, ip1, ip2, dir
  
* where `t0` is the timestamp, `ip1` and `ip2` are the source and destination ips, with `ip1 < ip2` (using numerical order sequentially on each section of the ip, e.g. `1.10.10.10 < 10.1.1.1`), and `dir` is a flag to indicated the direction, i.e. `dir = 0` if `ip1` is the source and `dir = 1` if ip2 is the source.

* Once the data is sorted, we run the following with awk:

.. code-block:: awk
    
    # INIT
    BEGIN{
        window = 1.0 # window of 1 second
    }
    {
    if (NR == 1) # on first line 
        {
         # Store timestamps and ips
         first_t=$1; 
         prev_src=$2; 
         prev_dst=$3;
         flag_up=0; # enable if packet was seen in $2 -> $3 direction
         flag_down=0 # enable if packet was seen in $3 -> $2 direction
        };

    # if line still has same source and destination and timestamp
    # isn't further then 1.0s than stored line, store line in 
    # current_window
    if ($2==prev_src && $3 == prev_dst && $1 - first_t <= window)
        {
         current_window[window_index++]=$1" "$2" "$3;
         if ($4 == 0) flag_up = 1;
         if ($4 == 1) flag_down =1;
        } 
    # When entering a new "block" of source-destination, or timestamps
    # if further than 1.0 second,
    # if flag_up and flag_down are enabled, write entire block and reset
    # the current_window
    else 
        {
         if (flag_up == 1 && flag_down == 1) 
            {
             for (iii in current_window)
                {
                 print current_window[iii];
                 delete current_window[iii]
                }
            }
         else 
            {
             for (iii in current_window)
                {
                 delete current_window[iii]
                }
            }
        prev_src = $2;
        prev_dst = $3;
        first_t = $1;
        flag_up = 0;
        flag_down = 0;
        window_index = 0
        current_window[window_index++]=$1" "$2" "$3;
        if ($4 == 0) flag_up = 1;
        if ($4 == 1) flag_down =1;
        }
    }
    # write last stored block if needed at the end
    END{
        if (flag_up == 1 && flag_down == 1) 
        {
         for (iii in current_window)
            {
             print current_window[iii]
            }
        }
    }

