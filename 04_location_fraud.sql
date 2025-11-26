-- Step 1 - Use LAG to get a user's previous transaction location
WITH txn_with_previous AS (
    SELECT 
        t.*,
        LAG(latitude)  OVER (PARTITION BY user_id ORDER BY transaction_date) AS prev_lat,
        LAG(longitude) OVER (PARTITION BY user_id ORDER BY transaction_date) AS prev_long,
        LAG(transaction_date) OVER (PARTITION BY user_id ORDER BY transaction_date) AS prev_txn_time
    FROM transactions t
),

-- Step 2 - Calculate distance between two transaction locations
geo_calculation AS (
    SELECT 
        *,
        SQRT(POWER(latitude - prev_lat, 2) + POWER(longitude - prev_long, 2)) AS geo_distance,
        EXTRACT(EPOCH FROM (transaction_date - prev_txn_time)) / 60 AS minutes_diff
    FROM txn_with_previous
)

-- Step 3 - Flag impossible travel (far distance + short time)
SELECT 
    user_id,
    transaction_id,
    amount,
    transaction_date,
    geo_distance,
    minutes_diff,
    CASE 
        WHEN geo_distance > 5 AND minutes_diff <= 60 THEN 'LOCATION_RISK'
        ELSE 'OK'
    END AS location_flag
FROM geo_calculation
ORDER BY user_id, transaction_date;

	