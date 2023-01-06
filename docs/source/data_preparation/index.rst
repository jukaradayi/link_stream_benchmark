.. _data_preparation:

Data Preparation
================

* Included in the benchmark are dataset preparators for four datasets.

.. note::
   In all the following, we define the link-stream as a list of 
   "interactions". The link-streams are stored as a text file
   where each line contains space-separated values:
      
      t u v
 
   where t is the timestamp of the interaction, as an integer, and u
   and v are the vertices of the interaction.
   The streams are undirected, and for commodity we write it with `u < v`.
   For simplicity, we will also refer to this format as the "(t,u,v)" format,
   and depending on context (when there is no ambiguity), we will use
   (t,u,v) to talk about a specific interaction.
   Please look at `this paper <http://www.complexnetworks.fr/wp-content/uploads/2017/11/1710.040731.pdf>`_ for a more thorough definition of link-streams.


* The following Table summarize the main properties of each dataset (TODO:fix version of datasets,
  probably taxi_3000, mawi_1_day_0.001 

    =========== ======= ============== ======= ============    
    dataset     grain   n_interactions n_nodes n_timestamps
    =========== ======= ============== ======= ============
    taxi_3000   0.5     153336646      1211783 40329057
    mawi_1_day  0.001   836538338      440856  84344397
    peru        1       40509547       1423185 21698175 
    bitcoin     ?       ?              ?       ?
    =========== ======= ============== ======= ============

.. note::
       
   TODO : Several parameters were tested, e.g. size of the grid for taxi (taxi_1000 = grid of 1000 x 1000),
   size of grain for mawi (example of 2hour trace and 1 day trace)
   
   =========== ======= ============== ======= ============    
   dataset     grain   n_interactions n_nodes n_timestamps
   =========== ======= ============== ======= ============
   taxi_1000   0.5     153269248      320413  40322380
   taxi_3000   0.5     153336646      1211783 40329057
   taxi_10000  0.5     153373962      5369545 40332841
   mawi_2hours 10      1753926        111913  721
   mawi_2hours 0.001   123644024      111913  7194492
   mawi_2hours 0.00001 500913815      111913  359923483
   mawi_1_day  0.001   836538338      440856  84344397
   mawi_1_day  0.0001  1724898806     440856  688192511
   peru        1       40509547       1423185 21698175 
   =========== ======= ============== ======= ============


* This sections describes each dataset and how to put it in 
  (t,u,v) format when necessary. The last subsection then 
  explains how the weighted graph and timeserie are obtained
  from the stream.


.. toctree::
   :maxdepth: 2
   :caption: Contents:

   stream_format
   mawi
   taxi
   bitcoin
   peru
   prepare_data
