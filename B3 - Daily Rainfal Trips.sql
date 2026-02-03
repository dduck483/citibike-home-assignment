SELECT  
    t.bikeid,
    date_trunc('day',t.starttime) AS starttime,
    date_trunc('day',t.stoptime) AS stoptime,
    t.usertype,
    w.precip_mm
FROM 
    trip_data AS t
    LEFT JOIN weather_data_2014 AS w ON date_trunc('day', t.starttime) = w.date
WHERE
    w.precip_mm > 0;