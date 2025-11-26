Fintech Fraud Detection – SQL Project

This project focuses on identifying suspicious financial transactions using SQL.
It simulates a simple fraud-detection model similar to what payment platforms use to catch unusual behavior.

The project includes a small database with users, cards, merchants, and transaction history.
On top of this data, I applied several fraud-detection rules using SQL window functions, statistical calculations, and geo-based checks.

The goal of the project is to show how SQL can be used to detect risky transactions without any machine-learning model—just data logic and analytical techniques.

1. Dataset & Structure

The database contains the following tables:

users – basic user info

cards – cards linked to each user

merchants – merchant/location info

transactions – all payment activity (main table)

device_info – device data (not heavily used in this version)

fraud_alerts – table where detected alerts are stored

Each script is stored in a separate file and can be run independently.

2. Fraud Rules Implemented

The project currently includes three core fraud rules, which are also very common in real payment systems.

1) Velocity Fraud

Checks whether a user makes more than one transaction within a very short time window (e.g., 5 minutes).
This helps catch bots or card numbers being used repeatedly by fraudsters.

Techniques used:
LAG(), time differences, window functions.

Script: 02_velocity_fraud.sql
Insert rule: 03_insert_velocity_alerts.sql

2) Location Change Fraud

Detects “impossible travel” situations.
If a user suddenly makes a transaction from a location that is too far from their previous one (and the time gap is too short), it is flagged as suspicious.

Example:
A user pays in Istanbul and then a few minutes later a transaction appears in New York.

Techniques used:
LAG(), simple geo-distance calculation, time comparison.

Script: 04_location_fraud.sql
Insert rule: 05_insert_location_alerts.sql

3) High-Amount Outlier Fraud

Looks for transactions that are unusually high compared to a user's normal spending pattern.
Outliers are measured using average amount and standard deviation.

Example:
A user who usually spends around 50 suddenly makes a 4000 payment.

Techniques used:
AVG(), STDDEV(), window functions, outlier rule.

Script: 06_high_amount_fraud.sql
Insert rule: 07_insert_high_amount_alerts.sql

3. Files in This Project
01_schema_and_sample_data.sql
02_velocity_fraud.sql
03_insert_velocity_alerts.sql
04_location_fraud.sql
05_insert_location_alerts.sql
06_high_amount_fraud.sql
07_insert_high_amount_alerts.sql
README.md

4. How to Use the Project

Run 01_schema_and_sample_data.sql to create the schema and load the example data.

Run each analysis script (02, 04, 06) to view the suspicious transactions.

Run the insert scripts (03, 05, 07) to write detected frauds into the fraud_alerts table.

Query the results:

SELECT * FROM fraud_alerts ORDER BY created_at DESC;

5. Notes

This project is for learning and demonstration purposes.

The fraud rules are simplified but follow real-life patterns used in fintech.

More rules (merchant anomalies, device mismatch, etc.) can be added later if needed.

6. Contact

If you have feedback or ideas to extend the project, feel free to reach out.
This project will probably grow over time as I continue learning advanced SQL and data analysis.