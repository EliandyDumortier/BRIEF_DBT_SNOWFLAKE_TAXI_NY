{{ config(materialized='table') }}

with trips as (

    select * from {{ ref('stg_trips') }}

)

select

    vendor_id,
    passenger_count,
    trip_distance,
    rate_code_id,
    pu_location_id,
    do_location_id,
    payment_type,
    fare_amount,
    extra,
    mta_tax,
    tip_amount,
    tolls_amount,
    total_amount,

    pickup_ts,
    dropoff_ts,

    -- Derived metric (basic enrichment only)
    datediff(minute, pickup_ts, dropoff_ts) as trip_duration_minutes,

    -- Date breakdown (for analytics)
    date(pickup_ts)  as trip_date,
    year(pickup_ts)  as trip_year,
    month(pickup_ts) as trip_month,
    day(pickup_ts)   as trip_day,
    hour(pickup_ts)  as trip_hour

from trips
