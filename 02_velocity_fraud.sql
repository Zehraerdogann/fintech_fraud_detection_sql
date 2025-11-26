-- Step 1 - Use LAG() to get each user's previous transaction timestamp

WITH txn_with_lag AS (
	SELECT 
		t.*,
		lag(transaction_date) OVER (      --Compare transactions for the same user
			PARTITION BY user_id          --Order user's transactions by time 
			ORDER BY transaction_date     --The timestamp of the previous transaction
		) AS previous_txn_time
	FROM transactions t 
		
),

--Step 2 - Calculate the time difference (in minutes) between current and previous transaction

time_diffs AS ( 
	SELECT 
		*,
		EXTRACT (EPOCH FROM (transaction_date-previous_txn_time))/ 60 AS minutes_diff
		--EXTRACT(EPOCH) returns seconds, dividing by 60 gives minutes
	FROM txn_with_lag
)

--Step 3 - Mark transactions as 'VELOCITY_RISK' if they occur within 5 minutes of the previous one

SELECT
	user_id,
	card_id,
	transaction_id,
	amount,
	transaction_date,
	minutes_diff,
	CASE 
		WHEN minutes_diff IS NOT NULL AND minutes_diff <=5
		THEN 'VELOCITY_RISK'    
		ELSE 'OK'
	END AS velocity_flag
FROM time_diffs
ORDER BY user_id,transaction_date
	