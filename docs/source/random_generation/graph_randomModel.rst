.. _graph_randomModel:

Graph Random Model
==================

* The other implemented pipeline used to generate random graphs with anomalies only
  requires a number of node and number of egdes as input. The generated weighted
  graphs are created using Erdos Renyi models, with anomalies generated with
  Erdos Renyi.

Generation
-----------

* The process is as follows:

  - Read input parameters: 

  - Generate independently the normal graph :math:`G_{norm}` and the anomaly graph :math:`G_{an}` with Erdos-Renyi models with the specified parameters, and set all weights to :math:`1`

  - For each node :math:`n_{an}` of :math:`G_{an}`, uniformly pick in :math:`G_{norm}` a node :math:`n_{norm}` that has not already been selected

  - Generate graph :math:`G` as the union of :math:`G_{an}` and :math:`G_{norm}`; if an edge of :math:`G_{an}` is already in :math:`G_{norm}`, merge them and increase the weight by :math:`1`

  - Randomly pick edges in :math:`G` and increase their weight by :math:`1` until the total sum of the weights specified as input is reached.

..  
    - N_nodes = the number of nodes of the generated graph

..
    - N_nodes_graphAnomaly = the number of nodes of the graph anomaly G_gan

..
    - N_nodes_streamAnomaly = the number of nodes of the stream anomaly G_san (TODO: nécessaire de séparer graph/stream anomaly ?)

..
    - N_edges_{norm}ality = the number of edges of the normality graph G_{norm}

..
    - N_edges_graphAnomaly = number edges G_gan

..
    - N_edges streamAnomaly = number edges G_san

