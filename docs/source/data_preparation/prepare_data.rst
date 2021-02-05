.. _prepare_data:

Prepare Data
============

* When the dataset-specific processing are done, the last
  step of the data prepration is to extract the weighted
  graph and the timeserie are obtained.

Weighted Graph
--------------

* The weighted graph `G` is extracted by "getting rid" of the time
  to keep only the structure of the data. We define `V` the set of
  all vertices in the data. Each interaction
  `(t,u,v)` then gives an edge `(u,v)` in the graph `G`, and the 
  weight :math:`w_{u,v}` is the number of occurences with different
  timestamps of interaction between `(u,v)`

* In practice, we extract it by piping the following commands in bash:

.. code-block:: bash

   mawk '{print $2","$3;}'  # remove the timestamp

   sort                     # sort the data

   uniq -c                  # count the number of occurence of each (u,v)

   mawk '{print $2,$1;}'    # format the output of uniq

Timeserie
---------

* The timeserie `a` is extracted by "getting rid" of the structure,
  to keep only the number of interactions at each time.
  We define `T` the set of all timestamps in the data, then for each
  :math:`t \in T, a(t) = \sum_{ \forall u,v \in V \times V} \mathbf{1}_{t}(u,v)`
  where :math:`\mathbf{1}_{t}(u,v)` is `1` if the edge `(u,v)` occurs at time `t`, :math:`0` otherwise.

* In practice, we pipe the wollowing commands in bash:

.. code-block:: bash

   cut -d" " -f1         # only keep timestamp

   uniq -c               # count occurences of each 
                         # timestamps, i.e. number of
                         # interaction ocurring at this timestamp

   mawk '{print $2,$1;}' # format mawk output

.. note::
   The timeserie :math:`a` is represented on a set of timestamps :math:`T` that does not
   necessarily have a constant time step, and is never :math:`0`. To get the
   timeserie with a constant time step, we can construct a set :math:`T'`
   with a constant timestamp, with :math:`T \subset T'` and :math:`a(t)=0 \forall t \in T'\backslash T`


