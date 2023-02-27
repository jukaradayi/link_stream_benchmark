.. _usage:

Usage
===== 

- This page describes how to use each block of the benchmark.

Preparator
----------

- The preparator is used to get some specific datasets and put them in the following format (t are the timestamps, u and v are the nodes. u and v share the same set of node ids): 

  | t0 u0 v0
  | t1 u1 v1
  | t2 u2 v2
  | ...

- Two datasets included in the benchmark require specific preparator

  * nyc_taxi : in preparator/nyc_taxi_stream/nyc_taxi_stream you can find the python package used to prepare the dataset. The raw dataset needs to be processed to adapt it to the benchmarks convention. 
    The nyc_taxi dataset contains taxi trip with their start timestamp, their ending timestamp, and the coordinates of the start and dropoff. This preparator takes the **middle** of the start and ending **timestamp**, and **discretizes** the coordinates using a **grid**.

    * First download the dataset: 

        * wget https://s3-us-west-2.amazonaws.com/nyctlc/nyc_taxi_data.csv.gz

        * gunzip nyc_taxi_data.csv.gz

    * The raw data can then be processed (the chosen value for the grid size is 3000 for the benchmark):
      
        * python3 build_stream.py --input_file="../Data/nyc_taxi_data.csv" --output_file="./taxi_stream.txt" --n=3000

  * MAWI : The MAWI data consists of several 15 minutes snapshots. The preparator is in preparator/mawi_stream:

    * Download the dataset (two dates, 2018 and 2019, have day long captures, 2020 contains only 8 hours): bash download.sh 2018 

    * The raw data contains a lot of information we don't want. Also, we only keep a link from node *u* to node *v* if a response from *v* to *u* is detected in less than 1 second (done by reciprocity.awk. You can also choose to keep the port information or not (two nodes with same IP but different port can be considered as same node or different nodes)

    * To process the data (arguments are : build_stream.sh <input_folder> <output_folder> <check_reciprocity> <keep_ports> <max memory to use for sort> <number of CPU to use for sort>), use for example: 

        * bash build_stream.sh <PCAP_FOLDER> <OUTPUT_FOLDER> true false 20G 4


Processor
---------

- Given a link stream in the format described in the previous section, the Processor extracts the weight distribution of the aggregated graph, and the time series distribution. The processor can also generate random graph and timeseries, and their distributions.

- The output of processor are (given a dataset called "dataset"): 

    - dataset.clean.gz : a "cleaned" version of the link stream, in which self loops are removed, duplicate (t,u,v) are removed, outputs are sorted, timestamps are rounded using the "grain" parameter. 
    - dataset.deg.gz  : the degrees of each node of the dataset (degree of the node in the aggregated graph)
    - dataset.degree.d.gz : the degree distribution of the graph
    - dataset.ts.gz : the aggregated timeserie
    - dataset.ts.d.gz : the distribution of the aggregated timeserie
    - dataset.weight.gz : the aggregated weighted graph
    - dataset.weight.d.gz : the weight distribution of the graph.

- To generate a link-stream (see next section), the *dataset.weight.gz* and *dataset.ts.gz* files will be used. Those file are in the following format:

  * **dataset.weight.gz** (*edge* are the edges of the graph, and *w* are the weights):

     | edge0 w0
     | edge1 w1
     | edge2 w2
     | ...

  * **dataset.ts.gz** (*t* are the timestamps and *v* are the values):

     | t0 v0
     | t1 v1
     | t2 v2
     | ...

* To extract the aggregate graph and timeserie from a link stream (in the format defined in previous section), use **processor/prepare_data.sh**:

  * bash processor/prepare_data.sh <PATH_TO_LINKSTREAM> <GRAIN> <MEMORY> <NCPU>

* To generate a random graph and a random timeserie, use the package **processor/GTgen**. See GTgen doc for more (found in GTgen/doc/build/html) details. For basic usage, modify a yaml file in processor/GTgen/example, entering your own parameters, and generate using:

  * python GTgen/generate.py -y <PATH_TO_YAML> -o <OUTPUT_FOLDER>

Link Stream Generator
---------------------

- Finally, to generate a link-stream using the **dataset.weight.gz** and **dataset.ts.gz** files, use the package **link-stream-generator/genbip**. See genbip doc (found in genbip/doc/build/html) for more details.

- To generate a random link-stream using genbip, the parameters are :

  * python genbip/launch.py <PATH_TO_WEIGHT> <PATH_TO_TS> <MODEL> --swaps <NSWAP> -tan <PATH_TO_ANOMALY_WEIGHT> -ban <PATH_TO_ANOMALY_TS>

- Where *<MODEL>* should be chosen in *configuration, pruned, whole, asap, corrected, havelhakimi* (check genbip doc for more info on each model), *<NSWAP>* gives the number of swap required after graph generation (swap are needed only when the chosen model is *havelhakimi*). *-tan* and *-ban* require path to the "anomaly" weighted graph and "anomaly" time serie, in the same format as the "normal" graph weight *dataset.weight.gz* and normal timeserie *dataset.ts.gz*.

.. note::
    The genbip generator generates a bipartite graph given two degree sequences. Generating a randomly uniformly pick bipartite graph where the "top" degree sequence is the list of the edges of the graph, and their weight,
    and the "bot" degree sequence is the list of timestamps and the values of the timeserie at each point, is equivalent to generating a uniformly randomly picked link-stream with said graph and 
    timeserie.
    Note that the notions of "top" and bottom are symmetric, and the graph can be given as top or bottom without any change, BUT, if the graph is given as top (resp. bottom), then the anomaly graph 
    should be given as top using *-tan* as well (resp. bottom using *-ban*).
    
    



