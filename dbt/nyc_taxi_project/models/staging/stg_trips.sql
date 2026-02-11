with source as (

    select * from {{ source('raw', 'yellow_taxi_trips') }}

)

select

    "VendorID"              as vendor_id,
    "passenger_count"       as passenger_count,
    "trip_distance"         as trip_distance,
    "RatecodeID"            as rate_code_id,
    "PULocationID"          as pu_location_id,
    "DOLocationID"          as do_location_id,
    "payment_type"          as payment_type,
    "fare_amount"           as fare_amount,
    "extra"                 as extra,
    "mta_tax"               as mta_tax,
    "tip_amount"            as tip_amount,
    "tolls_amount"          as tolls_amount,
    "total_amount"          as total_amount,

    to_timestamp_ntz("tpep_pickup_datetime" / 1000000)  as pickup_ts,
    to_timestamp_ntz("tpep_dropoff_datetime" / 1000000) as dropoff_ts

from source

where "fare_amount" >= 0
  and "trip_distance" > 0
  and "trip_distance" <= 100
  and "tpep_dropoff_datetime" > "tpep_pickup_datetime"
