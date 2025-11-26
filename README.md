# Fintech Fraud Detection – SQL Project

This project explores how SQL can be used to detect suspicious financial transactions.  
It includes several fraud-detection rules frequently used in payment systems and shows how analytic techniques such as window functions and statistical calculations can reveal unusual behavior.

The project uses a small, simulated dataset containing users, cards, merchants, and transaction history.

---

## 📌 1. Project Structure

| File | Description |
|------|-------------|
| `01_schema_and_sample_data.sql` | Creates database tables + inserts sample data |
| `02_velocity_fraud.sql` | Detects transactions done too close in time |
| `03_insert_velocity_alerts.sql` | Saves velocity fraud alerts |
| `04_location_fraud.sql` | Detects impossible travel / suspicious geo-change |
| `05_insert_location_alerts.sql` | Saves location fraud alerts |
| `06_high_amount_fraud.sql` | Detects unusually high transaction amounts |
| `07_insert_high_amount_alerts.sql` | Saves high-amount fraud alerts |
| `README.md` | Project documentation |

---

## 📌 2. Database Tables

The project uses the following tables:

- **users** – user information  
- **cards** – card details linked to users  
- **merchants** – merchant and category info  
- **transactions** – all payment activity  
- **device_info** – device and login details  
- **fraud_alerts** – stores detected fraud cases  

---

## 📌 3. Implemented Fraud Rules

### 🔹 3.1 Velocity Fraud  
Detects users who make multiple transactions within a very short time window (e.g., 5 minutes).

Key techniques:  
- `LAG()`  
- Time difference calculation  
- Window functions  

**Example output:**
```sql
SELECT * FROM fraud_alerts WHERE alert_type = 'velocity_fraud';

🔹 3.2 Location Change Fraud

Identifies “impossible travel” scenarios:
e.g., Istanbul → New York in 10 minutes.

Techniques:

LAG() for previous location

Simple geo-distance formula

Time difference comparison

🔹 3.3 High Amount Outlier Fraud

Finds transactions that do not match the user’s normal spending pattern.

Outlier rule used:

amount > avg_amount + 3 * stddev_amount


Key techniques:

AVG()

STDDEV()

Window functions

📌 4. How to Run the Project

Run the schema + data script:

01_schema_and_sample_data.sql


Run each analysis script to view suspicious activity:

02_velocity_fraud.sql
04_location_fraud.sql
06_high_amount_fraud.sql


Insert fraud cases into fraud_alerts:

03_insert_velocity_alerts.sql
05_insert_location_alerts.sql
07_insert_high_amount_alerts.sql


View all fraud alerts:

SELECT * FROM fraud_alerts ORDER BY created_at DESC;

```
📌 5. Notes

This project is created for learning and demonstration purposes.

The dataset is fictional but represents realistic fraud patterns used in fintech systems.

Additional fraud rules (merchant anomaly, device mismatch, spending pattern changes, etc.) can be added in the future if needed.

📌 6. Contact

I’m open to feedback, ideas and suggestions.
This project will continue to grow as I keep improving my SQL and data analytics skills.

