-- Insert high-amount outlier transactions into fraud_alerts table

WITH stats AS (
    -- Calculate each user's average transaction amount and standard deviation
    SELECT 
        user_id,
        AVG(amount) OVER (PARTITION BY user_id) AS avg_amount,
        STDDEV(amount) OVER (PARTITION BY user_id) AS std_amount,
        transaction_id,
        amount,
        transaction_date
    FROM transactions
),

flagged AS (
    -- Identify unusually high transactions (outliers)
    SELECT
        transaction_id,
        amount,
        avg_amount,
        std_amount,
        CASE
            WHEN std_amount IS NOT NULL
             AND amount > avg_amount + (3 * std_amount)
            THEN 'HIGH_AMOUNT_RISK'
            ELSE NULL
        END AS amount_flag
    FROM stats
)

-- Insert flagged high-risk transactions into fraud_alerts
INSERT INTO fraud_alerts (transaction_id, alert_type, alert_score)
SELECT
    transaction_id,
    'high_amount_fraud',
    90   -- High risk score
FROM flagged
WHERE amount_flag IS NOT NULL;
