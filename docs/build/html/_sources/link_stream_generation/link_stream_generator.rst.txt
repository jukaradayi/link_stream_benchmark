.. _link_stream_generator:

Link Stream Generator
=====================

* We use genbip to generate the link stream. 
  The inputs are the weighted edges, and the timeserie.
  Generating link-stream using these weighted edges and this timeserie is equivalent to 
  generating a bipartite graph considering the list of edges as "top" nodes, their weights as
  the "top" degree sequence, and considering the list of timestamps as "bottom" nodes, and
  the values of the timeserie at these timestamps as the "bottom" degree sequence.

* The generator uses a modified Havel-Hakimi model to generate a bipartite graphs
  given two degree sequences. Then, we proceed by doing a "sufficient" (usually 10 to 100 times 
  the number of edges) number of edge swap to ensure that the sample we get is uniformly picked.

* When generating the stream, we generate: 
  
  - the "normal" stream by using the "normal" graph and "normal" timeserie

  - the "anomaly" part of the stream, composed of three types of anomalies :
    - the "graph anomaly" by using a "graph anomaly" and the "normal" timeserie
    - the "time serie anomaly" by using the "normal" graph and a "timeserie anomaly"
    - the "stream anomaly" by using a "timeserie anomaly" and a "graph anomaly". 

