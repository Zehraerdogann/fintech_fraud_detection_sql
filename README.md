[README_updated.md](https://github.com/user-attachments/files/24029356/README_updated.md)
# Fintech Fraud Detection – SQL Case Study
A KPI-focused SQL project designed to detect suspicious financial activity using window functions, statistical rules, and anomaly-detection logic.

## 1. Key Fraud KPIs
| KPI | Description | Why It Matters |
| --- | ----------- | -------------- |
| Velocity Fraud Rate | Very fast repeated transactions | Indicates bots or rapid unauthorized use |
| Location Mismatch Frequency | Sudden impossible travel | Strong sign of Account Takeover (ATO) |
| High-Amount Outlier Rate | Transactions above statistical threshold | Detects stolen card usage |
| Avg User Spend | Baseline spending pattern per user | Used for outlier detection |
| Time-To-Detect Fraud (TTD) | Time until fraud becomes visible | Lower TTD reduces total loss |

## 2. Project Structure
```
fintech_fraud_detection/
├── 01_schema_and_sample_data.sql
├── 02_velocity_fraud.sql
├── 03_insert_velocity_alerts.sql
├── 04_location_fraud.sql
├── 05_insert_location_alerts.sql
├── 06_high_amount_fraud.sql
├── 07_insert_high_amount_alerts.sql
└── README.md
```

## 3. Database Tables
- users
- cards
- merchants
- transactions
- device_info
- fraud_alerts

## 4. Fraud Rules & SQL Logic

### 4.1 Velocity Fraud
```sql
SELECT *
FROM fraud_alerts
WHERE alert_type = 'velocity_fraud';
```

### 4.2 Location Change Fraud
Detects suspicious geo-change events.

### 4.3 High-Amount Outlier Fraud
```sql
amount > avg_amount + 3 * stddev_amount
```

## 5. Business Recommendations

### 1. Real-Time Velocity Blocking  
Implement automated controls that flag accounts performing multiple high-speed transactions.  
- Enforce step-up verification (SMS, biometric check).  
- Temporarily freeze transactions until user confirmation.  
- Reduce average fraud loss by catching bots early.  

### 2. Geo-Verification & Location Risk Scoring  
When a transaction originates from an unusual or high-risk country:  
- Introduce mandatory secondary authentication.  
- Compare device fingerprint with previous sessions.  
- Use a geolocation risk model that assigns scores based on past fraud data.  

### 3. Dynamic, User-Level Spending Limits  
Replace static transaction limits with statistically generated thresholds:  
- Normal spending = mean ± standard deviation.  
- High-risk transactions require confirmation or delay.  
- Reduces false positives while protecting high-value customers.  

### 4. Device-Risk Scoring Integration  
Each device should have its own risk profile:  
- New, unrecognized devices trigger alerts.  
- Jailbroken/rooted devices receive higher risk scores.  
- Combine device metadata with transaction velocity for better accuracy.  

### 5. Fraud Alert Prioritization Framework  
Not all alerts have equal risk. Build a ranking system:  
- **High Priority:** Impossible travel + high amount + new device.  
- **Medium Priority:** Velocity anomalies with consistent device usage.  
- **Low Priority:** Minor deviations from typical patterns.  

### 6. Behavioral Profiling & Long-Term Monitoring  
Monitor long-term user behavior to detect subtle fraud changes:  
- Spending pattern deviation.  
- Merchant-type anomalies.  
- Time-of-day transaction shifts.  

### 7. Automated Analyst Dashboard  
Develop a real-time dashboard showing:  
- Top KPIs (velocity rate, high-amount rate, ATO risk).  
- Daily fraud trends.  
- High-risk user segments.  
This supports rapid investigation and reduces manual workload.

## 6. Why This Project Matters
Demonstrates SQL expertise, fraud pattern understanding, KPI-driven analysis, and business-thinking.
A strong portfolio piece for fintech, fraud analytics, and risk intelligence roles.

## 7. Contact
Open to comments, improvements, and collaboration.
