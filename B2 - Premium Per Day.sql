WITH trip_weather AS (
    SELECT  
        t.bikeid,
        date_trunc('day',t.starttime) AS starttime,
        date_trunc('day',t.stoptime) AS stoptime,
        EXTRACT(EPOCH FROM (stoptime - starttime)) / 60 AS duration,
        t.usertype,
        w.temp_max,
        w.temp_min,
        w.precip_mm
    FROM 
        trip_data AS t
        LEFT JOIN weather_data_2014 AS w ON date_trunc('day', t.starttime) = w.date
)

-- non rainy day fair
SELECT
    tw.bikeid,
    tw.starttime, 
    tw.duration,
    tw.usertype,
    CASE
        WHEN tw.usertype = 'Subscriber'  THEN 15 * tw.duration 
        WHEN tw.usertype = 'Customer'  THEN 20 * tw.duration
    END AS trip_fare 
FROM
    trip_weather tw
WHERE
    tw.precip_mm < 0
UNION
-- on fair calc rainy days only
SELECT
    tw.bikeid,
    tw.starttime,
    tw.duration,
    tw.usertype,
    CASE
        WHEN tw.usertype = 'Subscriber'  THEN 15 * tw.duration * 1.2 
        WHEN tw.usertype = 'Customer'  THEN 20 * tw.duration * 1.2
    END AS trip_fare 
FROM
    trip_weather tw
WHERE
    tw.precip_mm > 0;