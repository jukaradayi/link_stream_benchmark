.. _timeserie_dataModel:

Timeserie Data Model
====================

This process generates a timeserie with an anomaly by using a measured timeserie as input.

Pipeline
--------

- Take a timeserie :math:`a` measured on a dataset, defined on a set of timestamps :math:`T`, and the number of interactions of the anomal :math:`C_{an}`.

- Sort the timeserie :math:`a` in increasing order

- select the :math:`N_{an}` last (highest) values to host anomaly. The set of timestamps for these values is noted :math:`T_{an}`

- While the sum :math:`\sum_{t \in T_{an}} a_{an}(t) < C_{an}`, do:

    - Pick a random index :math:`t_i \in T_{an}`

    - increment the anomaly timeserie at this index :math:`a_{an}(t_i) += 1`


- Define 'normality' timeserie as :math:`a_{norm}(t) = a(t) - a_{an}(t) for t \in T`

- Generate normal timeserie and anomaly timeserie by "shuffling"*
  :math:`a_{norm}` and :math:`a_{an}`, i.e. define two bijective mappings :math:`T\rightarrow T` (where :math:`T` is the set of timestamps of the timeseries) :math:`map1` and :math:`map2`, such that 
  :math:`a'_{norm}(t) = a_{norm}(map1(t))` and :math:`a'_{an}(t) = a_{an}(map2(t))`
  TODO : map2 is more constrained than simply this

