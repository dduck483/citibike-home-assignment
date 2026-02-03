DROP TABLE IF EXISTS aggregated_exposure_daily;

CREATE TABLE aggregated_exposure_daily AS
SELECT
     P.starttime
    ,P.bikeid
    ,CASE
        WHEN P.precip_mm > 0 THEN
            CASE
                WHEN P.usertype = 'Subscriber'  THEN 15 * P.duration * 1.2
                WHEN P.usertype = 'Customer'  THEN 20 * P.duration * 1.2
            END
        WHEN P.precip_mm < 0 THEN
            CASE
                WHEN P.usertype = 'Subscriber'  THEN 15 * P.duration
                WHEN P.usertype = 'Customer'  THEN 20 * P.duration
            END
    END AS trip_fare
    ,SUM(CASE WHEN P.precip_mm > 0 THEN 1 ELSE 0 END) AS rainy_trip_count
    ,SUM(CASE WHEN P.precip_mm < 0 THEN 1 ELSE 0 END) AS non_rainy_trip_count
FROM

(
    SELECT
         date_trunc('day', t.starttime) AS starttime
        ,date_trunc('day', t.stoptime) AS stoptime
        ,EXTRACT(EPOCH FROM (stoptime - starttime)) / 60 AS duration
        ,t.bikeid
        ,t.usertype
        ,w.precip_mm
    FROM 
        trip_data AS t
        LEFT JOIN weather_data_2014 AS w ON date_trunc('day', t.starttime) = date_trunc('day', w.date)
) AS P
GROUP BY 
    P.starttime
    ,P.bikeid
    ,P.usertype
    ,P.duration
    ,P.precip_mm;