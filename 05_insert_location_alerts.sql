-- Insert suspicious location-change transactions into fraud_alerts

WITH txn_with_previous AS (
    SELECT 
        t.*,
        LAG(latitude) OVER (PARTITION BY user_id ORDER BY transaction_date) AS prev_lat,
        LAG(longitude) OVER (PARTITION BY user_id ORDER BY transaction_date) AS prev_long,
        LAG(transaction_date) OVER (PARTITION BY user_id ORDER BY transaction_date) AS prev_txn_time
    FROM transactions t
),

geo_calculation AS (
    SELECT 
        *,
        SQRT(POWER(latitude - prev_lat, 2) + POWER(longitude - prev_long, 2)) AS geo_distance,
        EXTRACT(EPOCH FROM (transaction_date - prev_txn_time)) / 60 AS minutes_diff
    FROM txn_with_previous
),

flagged AS ( 
	SELECT 
		transaction_id,
		geo_distance,
		minutes_diff,
		CASE 
			WHEN geo_distance > 5 AND minutes_diff <=60 THEN 'LOCATION RISK'
			ELSE NULL
		END AS location_flag
	FROM geo_calculation
)

INSERT INTO fraud_alerts (transaction_id, alert_type, alert_score )
SELECT 
	transaction_id,
	'location_fraud',  --type od fraud 
	80                 --Risk score
FROM flagged
WHERE location_flag IS NOT NULL;

SELECT * FROM fraud_alerts;

