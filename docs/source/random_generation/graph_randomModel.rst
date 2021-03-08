.. _graph_randomModel:

Random Model
============

* The other implemented pipeline used to generate random graphs with anomalies only
  requires a number of node and number of egdes as input. The generated weighted
  graphs are created using Erdos Renyi models, with anomalies generated with
  Erdos Renyi.

Generation
-----------

* The process is as follows:

  - Read input parameters: 

  - Generate independently the normal graph :math:`G_norm` and the anomaly graph :math:`G_an` with Erdos-Renyi models with the specified parameters, and set all weights to :math:`1`

  - For each node :math:`n_an` of :math:`G_an`, uniformly pick in :math:`G_norm` a node :math:`n_norm` that has not already been selected

  - Generate graph :math:`G` as the union of :math:`G_an` and :math:`G_norm`; if an edge of :math:`G_an` is already in :math:`G_norm`, merge them and increase the weight by :math:`1`

  - Randomly pick edges in :math:`G` and increase their weight by :math:`1` until the total sum of the weights specified as input is reached.

..  
    - N_nodes = the number of nodes of the generated graph

..
    - N_nodes_graphAnomaly = the number of nodes of the graph anomaly G_gan

..
    - N_nodes_streamAnomaly = the number of nodes of the stream anomaly G_san (TODO: nécessaire de séparer graph/stream anomaly ?)

..
    - N_edges_normality = the number of edges of the normality graph G_norm

..
    - N_edges_graphAnomaly = number edges G_gan

..
    - N_edges streamAnomaly = number edges G_san

