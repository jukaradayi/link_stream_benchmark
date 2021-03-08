.. _taxi:

Taxi
====

* The dataset consists of `165,114,362 trip records` over the year 2014. A record includes various fields capturing trip characteristics such as pick-up and drop-off GPS locations and dates, trip durations and distances, fares, payment methods, or driver-reported passenger counts. 
  

Data Preparation
----------------

* For our purpose, we only retain, for each trip, the pick-up and drop-off locations as well as starting and ending timestamps. In order to parse this list of records into a proper stream, we use a grid to map each location into a grid identifier (i.e. the coordinates of the grid's rectangle containing the location point). In this way, we can parse each trip into a `(t_0,t_1,u,v)` quadruplet where `u` (resp. `v`) is the grid identifier of the trip's pick-up (resp. drop-off) location. In other words, the nodes of the resulting stream are locations (expressed in grid coordinates) and links represent taxi trips between the endpoint's locations. 

* This approach has the advantage of enabling us to decide how many nodes are involved in the stream by tunning the grid's resolution. Note however that because we do not consider self-links (i.e. links starting and ending within the same grid's cell), the number of links in the stream depends on the grid's resolutions. For example, after parsing the dataset with a :math: `1000 \times 1000` grid, we obtain a stream of `10^6` nodes and `153,271,442` trips. The code to download and parse the data into a proper stream of trips is available on `GitHub <https://github.com/NicolasGensollen/nyc_taxi_stream>`_.

* In practice, after defining the grid `nyc` and reading the csv using pandas, we use the following:

.. code-block:: python

    # Both the pickup location and the dropoff location have to be within the limits
    if ((nyc.is_inside(row["pickup_longitude"],row["pickup_latitude"])) and
        (nyc.is_inside(row["dropoff_longitude"],row["dropoff_latitude"]))):
    
        # Cast times to Unix timestamps
        t0 = to_datetime(row["pickup_datetime"]).timestamp()
        t1 = to_datetime(row["dropoff_datetime"]).timestamp()
        thalf = (t0+t1)/2
    
        if t0 < t1 and t1 - t0 >= 60 * 2:
            if tminus <= t0 <= tplus and tminus <= t1 <= tplus:
    
                # Get the bounding boxes in the grid
                ux,uy = nyc.get_box_idx2(row["pickup_longitude"], row["pickup_latitude"])
                vx,vy = nyc.get_box_idx2(row["dropoff_longitude"], row["dropoff_latitude"])
                # We don't want self-links, so we only keep trips going from one bbox to another
                if (ux,uy) != (vx,vy):
    
                    # Build the interaction as a string
                    if simplify:
                        interaction=f"{thalf} <{ux}-{uy}> <{vx}-{vy}>\n"
                    else:
                        interaction=f"{t0} {t1} <{ux}-{uy}> <{vx}-{vy}>\n"
                    taxi_stream.append(interaction)
    
                    # Empty the buffer every 10**6 interactions...
                    if len(taxi_stream) == 10**6:
                        with open(output_file, "a") as fp:
                            for interaction in taxi_stream:
                                fp.write(interaction)
                        taxi_stream = []
