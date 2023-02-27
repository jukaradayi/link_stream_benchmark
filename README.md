BENCHMARK PIPELINE
==================

Documentation
-------------

A documentation can be found in **docs/build/html/index.html**. Additionnal documentation for the package used can be found in the packages root/docs.

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



