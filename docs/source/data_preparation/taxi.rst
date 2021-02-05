.. _taxi:

Taxi
====

* The `taxi dataset <https://s3-us-west-2.amazonaws.com/nyctlc/nyc_taxi_data.csv.gz>`_ is a list of all (?) taxi trip in new york, over the course of one day.


Data Preparation
----------------

* To put the data in `(t,u,v)` format, with non-trivial graph, i.e. each nodes u, and v are involved in several edges, we place a grid on New York, and map each GPS point to the center of the square it is involved in.
