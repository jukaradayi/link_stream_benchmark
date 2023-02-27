.. _grap_dataModel:

Graph Data Model
================

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

    - Generate the anomaly :math:`G_{an}` using an Erdos Renyi model with the input parameters
     
    - Place anomaly on normal graph: Initialize the list `selected\_nodes`, then for each node :math:`n_{an}` in :math:`G_{an}`:
    
        - step 1: uniformly pick in :math:`S_d` a node :math:`n_{norm}` with degree :math:`d_{norm} \geq d_{an}`, where :math:`d_{an}` is the degree of :math:`n_{an}`

        - step 2: if :math:`n_{norm}` is not in `selected\_nodes`, add it to the list, else, empty `selected\_nodes` and start over at step 1.

        - step 3 : get the degree of the normal graph :math:`d_{norm} = d_{norm} - d_{an}`.

    - We then note :math:`S'_d` the updated degree sequence, that will now be the degree sequence of the "normal" graph.

    - Generate the graph :math:`G_{norm}`:

        - First generate a graph using a Havel-Hakimi model to fit the degree sequence :math:`S'_d`

        - Then perform :math:`10 \times N_{edges}` random edge swaps (where :math:`N_{edges}` is the number of edges of the graph) to ensure that the
          graph is randomly uniformly picked

    - Generate :math:`G` as the union of :math:`G_n` and :math:`G_{an}`

    - If :math:`G` is a simple graph, then return :math:`G`, else:

        - For each multiple edge :math:`e_1` in :math:`G`, do:

            - Choose between graphs :math:`G_{an}` and :math:`G_{norm}` with a probability :math:`0.5`

            - In chosen graph, pick an edge :math:`e_2` uniformly at random

            - Check that :math:`e_2` satisfies the following conditions:

                - :math:`e_1 \neq e_2`

                - swapping :math:`e_1` and :math:`e_2` reduces the number of multiple edges by at least one

            - If so, perform edge swap, else go to the beginning of the process for :math:`e_1` again.

    - return :math:`G`

Weights
-------

When :math:`G` is generated, assign weights to the nodes by shuffling the weight sequence :math:`S_w`, 
then taking the first :math:`N_an` values for :math:`G_{an}` edges, and the rest of the values for :math:`G_{norm}` edges weights.
