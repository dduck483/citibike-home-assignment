WITH trip_weather AS (
    SELECT  
        t.bikeid,
        date_trunc('day',t.starttime) AS starttime,
        date_trunc('day',t.stoptime) AS stoptime,
        EXTRACT(EPOCH FROM (stoptime - starttime)) / 60 AS duration,
        t.usertype,
        w.temp_max,
        w.temp_min,
        w.precip_mm,
        w.season
    FROM 
        trip_data AS t
        LEFT JOIN weather_data_2014 AS w ON date_trunc('day', t.starttime) = w.date
)

SELECT
    tw.bikeid,
    tw.starttime,
    tw.usertype,
    CASE
        WHEN tw.season <> 'Winter' THEN
            CASE
                WHEN tw.usertype = 'Subscriber'  THEN 15 * tw.duration * 1.2 
                WHEN tw.usertype = 'Customer'  THEN 20 * tw.duration * 1.2
            END 
        ELSE
            CASE
                WHEN tw.usertype = 'Subscriber'  THEN 15 * tw.duration 
                WHEN tw.usertype = 'Customer'  THEN 20 * tw.duration
            END
    END AS premium_usd
FROM trip_weather AS tw;