-- ============================================================
-- UBER FARES — DEMAND & FARE ANALYSIS
-- PostgreSQL / pgAdmin
-- ============================================================


-- 0. CREATE TABLE
-- Creates the table used to store the Uber Fares dataset.

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


-- ============================================================
-- 1. DATA QUALITY CHECK
-- ============================================================
-- Check the dataset for potentially invalid fare amounts
-- and passenger counts.

SELECT
    COUNT(*) AS total_rows,

    COUNT(*) FILTER (
        WHERE fare_amount <= 0
    ) AS invalid_fares,

    COUNT(*) FILTER (
        WHERE passenger_count = 0
           OR passenger_count > 6
    ) AS invalid_passengers,

    COUNT(*) FILTER (
        WHERE fare_amount <= 0
           OR passenger_count = 0
           OR passenger_count > 6
    ) AS suspicious_rows,

    ROUND(
        100.0 * COUNT(*) FILTER (
            WHERE fare_amount <= 0
               OR passenger_count = 0
               OR passenger_count > 6
        ) / COUNT(*),
        2
    ) AS suspicious_pct

FROM uber_fares;


-- ============================================================
-- 2. DEMAND AND FARE BY HOUR
-- ============================================================
-- Examine how ride volume and average fare change
-- throughout the day.

SELECT
    EXTRACT(HOUR FROM pickup_datetime)::INT AS hour_of_day,
    COUNT(*) AS num_rides,
    ROUND(AVG(fare_amount), 2) AS avg_fare
FROM uber_fares
WHERE fare_amount > 0
  AND passenger_count BETWEEN 1 AND 6
GROUP BY hour_of_day
ORDER BY hour_of_day;


-- ============================================================
-- 3. PEAK VS. OFF-PEAK
-- ============================================================
-- Compare ride volume and average fare during peak-demand
-- hours (18:00–22:00) with all other hours.

SELECT
    CASE
        WHEN EXTRACT(HOUR FROM pickup_datetime)::INT BETWEEN 18 AND 22
            THEN 'Peak'
        ELSE 'Off-peak'
    END AS demand_period,

    COUNT(*) AS num_rides,
    ROUND(AVG(fare_amount), 2) AS avg_fare

FROM uber_fares

WHERE fare_amount > 0
  AND passenger_count BETWEEN 1 AND 6

GROUP BY demand_period
ORDER BY num_rides DESC;


-- ============================================================
-- 4. PEAK VS. OFF-PEAK BY DAY
-- ============================================================
-- Check whether the relationship between demand period
-- and average fare is consistent across the week.

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

    COUNT(*) AS total_rides,

    COUNT(*) FILTER (
        WHERE EXTRACT(HOUR FROM pickup_datetime)::INT BETWEEN 18 AND 22
    ) AS peak_rides,

    ROUND(
        AVG(fare_amount) FILTER (
            WHERE EXTRACT(HOUR FROM pickup_datetime)::INT BETWEEN 18 AND 22
        ),
        2
    ) AS peak_avg_fare,

    ROUND(
        AVG(fare_amount) FILTER (
            WHERE EXTRACT(HOUR FROM pickup_datetime)::INT NOT BETWEEN 18 AND 22
        ),
        2
    ) AS offpeak_avg_fare

FROM uber_fares

WHERE fare_amount > 0
  AND passenger_count BETWEEN 1 AND 6

GROUP BY EXTRACT(DOW FROM pickup_datetime)::INT

ORDER BY EXTRACT(DOW FROM pickup_datetime)::INT;


-- ============================================================
-- 5. PEAK HOURS BY DAY
-- ============================================================
-- Examine ride volume and average fare for each hour
-- during the peak-demand period.

SELECT
    EXTRACT(DOW FROM pickup_datetime)::INT AS day_num,
    EXTRACT(HOUR FROM pickup_datetime)::INT AS hour_of_day,
    COUNT(*) AS num_rides,
    ROUND(AVG(fare_amount), 2) AS avg_fare

FROM uber_fares

WHERE fare_amount > 0
  AND passenger_count BETWEEN 1 AND 6
  AND EXTRACT(HOUR FROM pickup_datetime)::INT BETWEEN 18 AND 22

GROUP BY day_num, hour_of_day

ORDER BY day_num, hour_of_day;


