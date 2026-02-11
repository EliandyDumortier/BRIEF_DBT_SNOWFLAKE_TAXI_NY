-- Create FILE FORMAT for parquet
USE WAREHOUSE NYC_TAXI_WH;
USE DATABASE NYC_TAXI_DB;
USE SCHEMA RAW;
CREATE OR REPLACE FILE FORMAT parquet_format
TYPE = PARQUET;

-- Create INTERNAL STAGE
CREATE OR REPLACE STAGE raw_internal_stage;

-- (Optional) LIST stage content for validation
SHOW STAGES;
LIST @RAW_INTERNAL_STAGE;
/*REMOVE @raw_internal_stage;*/ -- Uncomment to remove stage IF NEEDED

-- CREATE TABLE using INFER_SCHEMA
CREATE OR REPLACE TABLE RAW.yellow_taxi_trips
USING TEMPLATE (
    SELECT ARRAY_AGG(OBJECT_CONSTRUCT(*))
    FROM TABLE(
        INFER_SCHEMA(
            LOCATION => '@raw_internal_stage/yellow_tripdata_2024-01.parquet',
            FILE_FORMAT => 'parquet_format'
        )
    )
);

-- COPY INTO with MATCH_BY_COLUMN_NAME
COPY INTO RAW.yellow_taxi_trips
FROM @raw_internal_stage
FILE_FORMAT = (FORMAT_NAME = parquet_format)
MATCH_BY_COLUMN_NAME = CASE_INSENSITIVE
PATTERN = '.*yellow_tripdata_2024.*.parquet';

