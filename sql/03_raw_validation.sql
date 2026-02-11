
-- Total rows
SELECT COUNT(*) AS total_rows
FROM RAW.yellow_taxi_trips;

-- Date range
SELECT 
    MIN("tpep_pickup_datetime") AS min_pickup,
    MAX("tpep_pickup_datetime") AS max_pickup
FROM RAW.yellow_taxi_trips;

-- Negative fares
SELECT COUNT(*) AS negative_fares
FROM RAW.yellow_taxi_trips
WHERE "fare_amount" < 0;

-- Zero distance
SELECT COUNT(*) AS zero_distance
FROM RAW.yellow_taxi_trips
WHERE "trip_distance" = 0;

