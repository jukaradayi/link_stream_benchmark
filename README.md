BENCHMARK PIPELINE
==================

WIP 
## TODO : 
    - Test pipeline on complete taxi (for time) - already tested complete pipeline on subpart of taxi w/grid 5
    - test pipeline on mawi
    - implement configuration check for model generation & pipeline
    - order as package
    - documentation (w/ sphinx ?)
    - Regarding models (random):
        - currently no anomaly
        - timeserie from real data=Done
        - graph weight from real data: WIP (should test)

This repository contains scripts to generate the benchmark dataset (#TODO give a better name to the "benchmark dataset" ?)


Pipeline
--------

The pipeline can be configured using the `benchmark.conf` file. The configuration will be pasted
in the output folder (for reproducibility).
You can then call
```
bash benchmar_pipeline.sh
```
In `benchmark.conf`, you can define which dataset you want to process, and the parameters needed for each dataset.

The tools needed to preprocess each dataset should be set in utils (#TODO define as submodules ??)


Mawi
------

In `utils/mawi_stream`, find the tcpdump command to read the pcap initial files, and an awk script that can be used to only consider
edges when the exchange was reciproc


Taxi
------

in `utils/taxi_stream`, find a python package to process the raw taxi data


Model
-------

in `utils/model_generation`, find a python package to generate graph and timeseries from different models, defined by the modelGeneration.yaml file.


