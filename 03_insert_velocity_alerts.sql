--Insert suspicious velocity transactions into fraud_alerts table

WITH txn_with_lag AS (
	SELECT 
		t.*,
		lag(transaction_date) OVER ( 
			PARTITION BY user_id
			ORDER BY transaction_date
		) AS previous_txn_time
	FROM transactions t 
),

time_diffs AS ( 
	SELECT 
		*,
		EXTRACT (EPOCH FROM(transaction_date-previous_txn_time)) / 60 AS minutes_diff
	FROM txn_with_lag
),

flagged AS ( 
	SELECT 
		transaction_id,
		CASE 
			WHEN minutes_diff IS NOT NULL AND minutes_diff <= 5
				THEN 'VELOCITY_RISK'
			ELSE NULL 
		END AS velocity_flag
	FROM time_diffs
)

INSERT INTO fraud_alerts (transaction_id,alert_type,alert_score)
SELECT 
	transaction_id,
	'velocity_fraud',
	70
FROM flagged
WHERE velocity_flag IS NOT NULL ;


SELECT * FROM fraud_alerts;

