.. _pipeline:

Pipeline
========

* Given a Link Stream :math:`S=(T,V,E)`, we define the induced weighted graph :math:`G` of a link stream as :math:`G(S) = ({v, T_v \neq \emptyset} = (\cup_{t in T}V_t, \cup_{t\in T} E_t)`, 
  which nodes are the nodes present in :math:`S`, and which edges are all the edges that occur in :math:`S`, and their weights are the number of occurences in :math:`S`. 
  We also define the induced timeserie :math:`a` as :math:`a(t) = |{v \in V_t}|`, with :math:`V_t` the set of edges at time :math:`t`.

* A link stream can then be seen as a bipartite graph where the top nodes are the edges of the induced weighted graph, the degree of the nodes are the weight of the edges, and the bottom nodes are the timestamps of the induced timeserie, their degree are the values of the timeserie.

* Given all this, the generic pipeline used for all generated datasets provided in the benchmark is the following:

  - Get the weighted edges of the induced graph and the induced timeserie

  - Generate the "normal" link stream by generating the bipartite graph using the weighted edges and the timeserie
  
  - Generate the "anomaly" link stream by generating the bipartite graph using the "anomaly" weighted edges and the "anomaly" timeserie"
