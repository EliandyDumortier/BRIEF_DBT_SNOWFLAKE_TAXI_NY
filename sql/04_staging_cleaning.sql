-- =====================================================
-- STAGING LAYER
-- Purpose: Clean and normalize RAW taxi data
-- =====================================================

CREATE OR REPLACE TABLE STAGING.clean_trips AS
SELECT

    -- ===============================
    -- Column renaming (no quotes needed after this)
    -- ===============================

    "VendorID"              AS VENDOR_ID,
    "passenger_count"       AS PASSENGER_COUNT,
    "trip_distance"         AS TRIP_DISTANCE,
    "RatecodeID"            AS RATE_CODE_ID,
    "PULocationID"          AS PU_LOCATION_ID,
    "DOLocationID"          AS DO_LOCATION_ID,
    "payment_type"          AS PAYMENT_TYPE,
    "fare_amount"           AS FARE_AMOUNT,
    "extra"                 AS EXTRA,
    "mta_tax"               AS MTA_TAX,
    "tip_amount"            AS TIP_AMOUNT,
    "tolls_amount"          AS TOLLS_AMOUNT,
    "total_amount"          AS TOTAL_AMOUNT,

    -- ===============================
    -- Datetime conversion
    -- RAW timestamps are in epoch microseconds
    -- Convert to proper TIMESTAMP
    -- ===============================

    TO_TIMESTAMP_NTZ("tpep_pickup_datetime" / 1000000)  AS PICKUP_TS,
    TO_TIMESTAMP_NTZ("tpep_dropoff_datetime" / 1000000) AS DROPOFF_TS

FROM RAW.yellow_taxi_trips

-- ===============================
-- Basic data quality filtering
-- ===============================

WHERE "fare_amount" >= 0
  AND "trip_distance" > 0
  AND "trip_distance" <= 100
  AND "tpep_dropoff_datetime" > "tpep_pickup_datetime";
