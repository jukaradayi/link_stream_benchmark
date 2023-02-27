.. _link_stream_generation:

Link Stream Generation
======================


* To generate a link-stream, the genbip package is used. See *genbip/doc/build* for its documentation.
  By considering the weighted edges as the top nodes and the timeseries values as the bottom nodes
  we generate a bipartite graph.

* Given a weighted graph :math:`G` and a timeserie :math:`a`, we can now generate a link stream.
  Genbip takes the output of GTgen as input.

.. toctree::
   :maxdepth: 2
   :caption: Contents:

   link_stream_generator
   link_stream_anomalies
