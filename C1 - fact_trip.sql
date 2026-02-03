DROP TABLE IF EXISTS fact_trip;

CREATE TABLE fact_trip AS
SELECT
    t.bikeid,
    t.starttime,
    t.stoptime,
    t."start station id",
    t."end station id",
    EXTRACT(EPOCH FROM (stoptime - starttime)) / 60 AS duration,
    CASE
        WHEN t.usertype = 'Subscriber'  THEN 15 * (EXTRACT(EPOCH FROM (stoptime - starttime)) / 60) 
        WHEN t.usertype = 'Customer'  THEN 20 * (EXTRACT(EPOCH FROM (stoptime - starttime)) / 60)
    END AS trip_fare,
    CASE WHEN w.precip_mm > 0 THEN 1 ELSE 0 END AS is_rainy
FROM 
    trip_data AS t
    LEFT JOIN weather_data_2014 w ON date_trunc('day', t.starttime) = date_trunc('day', w.date);