.. _grap_dataModel:

Data Model
==========

* One pipeline used to generate graph uses weights sequences and degree sequences
  measured from real-life datasets (presented in the benchmark/datasets section).
  We assume that anomalies are present in those datasets we use.

Generation
----------

* We generate the graphs using a Havel Hakimi to fit the degree sequence, 
  then perform random edge swaps to ensure that graph is uniformly randomly picked.

* The steps are:

    - Read the input parameters for the models

    - Read the degree sequence :math:`S_d` and weight sequence :math:`S_w`

    - Generate the anomaly :math:`G_an` using an Erdos Renyi model with the input parameters
     
    - Place anomaly on normal graph: Initialize the list `selected_nodes`, then for each node :math:`n_an` in :math:`G_an`:
    
        - uniformly pick in :math:`S_d` a node :math:`n_norm` whose degree :math:`d_norm` is equal or higher than the degree :math:`d_an` of :math:`n_an`

        - if :math:`n_norm` is not in `selected_nodes`, add it to the list, else, empty `selected_nodes` and start loop from scratch

        - substract `d_an` from `d_norm`

    - We then note :math:`S'_d` the updated degree sequence, that will now be the degree sequence of the "normal" graph.

    - Generate the graph :math:`G_norm`:

        - First generate a graph using a Havel-Hakimi model to fit the degree sequence :math:`S'_d`

        - Then perform :math:`10 \times N_edges` random edge swaps (where :math:`N_edges` is the number of edges of the graph) to ensure that the
          graph is randomly uniformly picked

    - Generate :math:`G` as the union of :math:`G_n` and :math:`G_an`

    - If :math:`G` is a simple graph, then return :math:`G`, else:

        - For each multiple edge :math:`e_1` in :math:`G`, do:

            - Choose between graphs :math:`G_an` and :math:`G_norm` with a probability :math:`0.5`

            - In chosen graph, pick an edge :math:`e_2` uniformly at random

            - Check that :math:`e_2` satisfies the following conditions:

                - :math:`e_1 \neq e_2`

                - swapping :math:`e_1` and :math:`e_2` reduces the number of multiple edges by at least one

            - If so, perform edge swap, else go to the beginning of the process for :math:`e_1` again.

    - return :math:`G`
