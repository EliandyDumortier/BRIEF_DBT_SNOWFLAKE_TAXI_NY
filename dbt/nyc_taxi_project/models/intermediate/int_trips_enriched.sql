with trips as (

    select *
    from {{ ref('stg_trips') }}

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

    -- Business logic lives here
    datediff(minute, pickup_ts, dropoff_ts) as trip_duration_minutes,

    case
        when trip_distance > 0
        then fare_amount / trip_distance
        else null
    end as fare_per_km

from trips
