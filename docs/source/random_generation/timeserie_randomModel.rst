.. _timeserie_randomModel:

Random Model Generation
=======================

* Take as input the number of interactions required :math:`C`, which will be the goal sum of the timeserie. Generate a timeserie as sum of white noises defined on different subsets of timestamps. 


White Noise Generation
----------------------

* To generate the timeserie, we use a white noise generator.
  This generator work by generating each value independently, only constrained by the sum of the timeserie. It works as follow: 

    - initialize the white noise with a value of one on the set of timestamps :math:`T`: :math:`\forall t \in T a(t) = 1`

    - while the sum of the serie :math:`C_s = \sum_{t \in T} a_{wn}(t) < C`:
     - Pick a random index :math:`t_i \in T`
     
     - Increment the serie at this index :math:`a_{wn}(t_i) += 1` 

Pipeline
--------

* Generate normal timeserie :math:`a_n` as white noise on set of timestamps T

* Generate anomaly timeserie :math:`a_{an}` as white noise on set of timestamps :math:`T_{an} \subset T` , and :math:`0` on :math:`T \\ T_{an}`

* Generated timeserie as :math:`a_n + a_{an}`
