.. _graph_normalityAndAnomalies:

Normality And Anomalies
=======================

* For the purpose of the generation, we define the normal graph
  noted G_n, a graph-anomaly graph noted G_gan, and a 
  stream-anomaly graph noted G_san.

Normal graph
------------

* The 'normal' graph is defined as a weighted graph that has consistent
  properties (TODO: is it true ? even w/ real degree seq ? which properties ?) all across. In practice, it is an uniformly randomly picked
  graph in the space defined by the input (Weight sequence + 
  degree sequence for 'randomly-real' graphs, or number of nodes and 
  number of edges for 'randomly-random' graphs) TODO NOM REAL ET RANDOM COMPLET

Anomalies
---------

* An anomaly is defined as a sub-graph in the 'normal graph' that has 
  properties (such as its density) that are overall *very different* than 
  the rest of the graph.

* TODO ajouter plot avec graph d'une couleur , anomalie d'une autre
