--: Step 1 - Calculate each user's average transaction amount and standard deviation


WITH stats AS (
    SELECT 
        user_id,
        AVG(amount) OVER (PARTITION BY user_id) AS avg_amount,
        STDDEV(amount) OVER (PARTITION BY user_id) AS std_amount,
        transaction_id,
        amount,
        transaction_date
    FROM transactions
),

-- Step 2 - Identify amounts that are unusually high (outliers)

flagged AS (
    SELECT
        *,
        CASE
            WHEN std_amount IS NOT NULL 
             AND amount > avg_amount + (3 * std_amount)
            THEN 'HIGH_AMOUNT_RISK'
            ELSE 'OK'
        END AS amount_flag
    FROM stats
)

-- Step 3 - Show flagged high-risk transactions

SELECT
    user_id,
    transaction_id,
    amount,
    avg_amount,
    std_amount,
    transaction_date,
    amount_flag
FROM flagged
ORDER BY user_id, transaction_date;
