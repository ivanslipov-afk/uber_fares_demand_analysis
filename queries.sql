-- ============================================================
-- UBER FARES SQL ANALYSIS — PostgreSQL / pgAdmin version
-- Dataset: Uber Fares Dataset (Kaggle, author: yasserh)
-- Table name used below: uber_fares
-- Columns expected: key, fare_amount, pickup_datetime,
--   pickup_longitude, pickup_latitude,
--   dropoff_longitude, dropoff_latitude, passenger_count
-- ============================================================


-- 0. CREATE TABLE
-- Run this first in pgAdmin's Query Tool, then use the Import/Export
-- feature (right-click the table -> Import/Export Data) to load the CSV.
CREATE TABLE uber_fares (
    key                 TEXT,
    fare_amount         NUMERIC,
    pickup_datetime     TIMESTAMP,
    pickup_longitude    DOUBLE PRECISION,
    pickup_latitude     DOUBLE PRECISION,
    dropoff_longitude   DOUBLE PRECISION,
    dropoff_latitude    DOUBLE PRECISION,
    passenger_count     INTEGER
);


-- 1. QUICK SANITY CHECK
-- How many rides are in the dataset, and what's the average fare?
SELECT
    COUNT(*)                    AS total_rides,
    ROUND(AVG(fare_amount), 2)  AS avg_fare,
    MIN(fare_amount)            AS min_fare,
    MAX(fare_amount)            AS max_fare
FROM uber_fares;


-- 2. DATA QUALITY CHECK — look for bad values
-- Negative or zero fares are almost certainly data errors or cancelled rides.
-- This is the kind of check you'd do in a real investigation before trusting the numbers.
SELECT
    COUNT(*) AS suspicious_rows
FROM uber_fares
WHERE fare_amount <= 0
   OR passenger_count = 0
   OR passenger_count > 6;


-- 3. AVERAGE FARE BY PASSENGER COUNT
-- Does riding with more people cost more per ride?
SELECT
    passenger_count,
    COUNT(*)                    AS num_rides,
    ROUND(AVG(fare_amount), 2)  AS avg_fare
FROM uber_fares
WHERE passenger_count BETWEEN 1 AND 6
GROUP BY passenger_count
ORDER BY passenger_count;


-- 4. RIDES BY HOUR OF DAY — find peak hours
-- EXTRACT(HOUR FROM ...) is the PostgreSQL way to pull the hour out of a timestamp.
SELECT
    EXTRACT(HOUR FROM pickup_datetime)::INT AS hour_of_day,
    COUNT(*)                                AS num_rides,
    ROUND(AVG(fare_amount), 2)              AS avg_fare
FROM uber_fares
GROUP BY hour_of_day
ORDER BY num_rides DESC;


-- 5. RIDES BY DAY OF WEEK
-- EXTRACT(DOW FROM ...) returns 0 = Sunday ... 6 = Saturday, same as SQLite's %w.
SELECT
    CASE EXTRACT(DOW FROM pickup_datetime)::INT
        WHEN 0 THEN 'Sunday'
        WHEN 1 THEN 'Monday'
        WHEN 2 THEN 'Tuesday'
        WHEN 3 THEN 'Wednesday'
        WHEN 4 THEN 'Thursday'
        WHEN 5 THEN 'Friday'
        WHEN 6 THEN 'Saturday'
    END AS day_of_week,
    COUNT(*)                    AS num_rides,
    ROUND(AVG(fare_amount), 2)  AS avg_fare
FROM uber_fares
GROUP BY day_of_week
ORDER BY num_rides DESC;


-- 6. MONTHLY TREND — is average fare rising or falling over time?
-- Uses a CTE (Common Table Expression) to keep the logic readable.
WITH monthly AS (
    SELECT
        TO_CHAR(pickup_datetime, 'YYYY-MM') AS ride_month,
        fare_amount
    FROM uber_fares
    WHERE fare_amount > 0
)
SELECT
    ride_month,
    COUNT(*)                    AS num_rides,
    ROUND(AVG(fare_amount), 2)  AS avg_fare
FROM monthly
GROUP BY ride_month
ORDER BY ride_month;


-- 7. WINDOW FUNCTION — rank hours of the day by ride volume
-- Demonstrates the use of a window function to rank hours by ride volume.
SELECT
    hour_of_day,
    num_rides,
    RANK() OVER (ORDER BY num_rides DESC) AS volume_rank
FROM (
    SELECT
        EXTRACT(HOUR FROM pickup_datetime)::INT AS hour_of_day,
        COUNT(*)                                AS num_rides
    FROM uber_fares
    GROUP BY hour_of_day
) hourly_counts
ORDER BY volume_rank;


-- 8. RUNNING TOTAL OF RIDES OVER TIME (window function, cumulative)
-- Calculates the cumulative number of rides over time.
WITH daily AS (
    SELECT
        pickup_datetime::DATE AS ride_date,
        COUNT(*)              AS num_rides
    FROM uber_fares
    GROUP BY ride_date
)
SELECT
    ride_date,
    num_rides,
    SUM(num_rides) OVER (ORDER BY ride_date) AS running_total_rides
FROM daily
ORDER BY ride_date;



