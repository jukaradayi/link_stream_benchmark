.. _random_graph_generation:

Random Graph and Timeserie Generation
=====================================

* There are two pipelines to generate random graphs and random timeseries implemented. 

* TODO TROUVER NOM POUR DIFFERENCIER REAL DATA ET RANDOM COMPLET

* The first one takes input from real data (weights and node degree sequence),
  and generates an uniformly randomly picked graph with anomalies that keeps
  the weights and node degree sequence from the input.
  To generate a timeserie from real data (set of timestamps and values at these timestamps),
  we "shuffle" the values of the timeserie.

* The second pipeline generates graphs with anomaly from scratch, using 
  Erdos-Renyi models for the 'normal graph' and the 'anomalies'. To generate the
  timeserie we generate a white noise.

.. toctree::
   :maxdepth: 2
   :caption: Contents:

   graph_normalityAndAnomalies
   graph_dataModel
   graph_randomModel
   timeserie_normalityAndAnomalies
   timeserie_dataModel
   timeserie_randomModel
