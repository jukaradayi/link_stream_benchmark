.. _link_stream_generation:

Link Stream Generation
======================

* Given a weighted graph :math:`G` and a timeserie :math:`a`, we can now generate a link stream.

* To generate a link-stream, the `genbip <https://www.complexnetworks.fr/genbip_doc/>`_ package is used.
  By considering the weighted edges as the top nodes and the timeseries values as the bottome nodes
  we generate a bipartite graph.

* For "Randomized Datasets" and "Random Datasets", the previous steps generated "normal" and "anomaly" graphs and
  timeseries, which will be used in this step to create de link-stream anomaly.

.. toctree::
   :maxdepth: 2
   :caption: Contents:

   link_stream_generator
   link_stream_anomalies
