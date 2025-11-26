CREATE TABLE users (
    user_id SERIAL PRIMARY KEY,
    full_name VARCHAR(150),
    email VARCHAR(200) UNIQUE,
    country VARCHAR(50),
    signup_date DATE
);
CREATE TABLE cards (
    card_id SERIAL PRIMARY KEY,
    user_id INT REFERENCES users(user_id),
    card_number VARCHAR(20) NOT NULL,
    card_type VARCHAR(20),      -- Visa, Mastercard, Amex vb.
    issuer_bank VARCHAR(100),   -- Ziraat, Garanti vb.
    created_at TIMESTAMP DEFAULT NOW()
);
CREATE TABLE merchants (
    merchant_id SERIAL PRIMARY KEY,
    merchant_name VARCHAR(150) NOT NULL,
    merchant_category VARCHAR(100),   -- Market, Online Store, Coffee Shop vb.
    country VARCHAR(50),
    city VARCHAR(100)
);
CREATE TABLE transactions (
    transaction_id SERIAL PRIMARY KEY,
    user_id INT REFERENCES users(user_id),
    card_id INT REFERENCES cards(card_id),
    merchant_id INT REFERENCES merchants(merchant_id),
    
    amount NUMERIC(10,2) NOT NULL,       -- 99,999,999.99
    transaction_date TIMESTAMP NOT NULL,
    status VARCHAR(20) DEFAULT 'SUCCESS', -- SUCCESS / FAILED / DECLINED

    latitude NUMERIC(10,6),   -- işlem lokasyonu
    longitude NUMERIC(10,6)
);
CREATE TABLE device_info (
    device_id SERIAL PRIMARY KEY,
    user_id INT REFERENCES users(user_id),
    device_type VARCHAR(50),       -- mobile, web, tablet
    operating_system VARCHAR(50),  -- iOS, Android, Windows
    app_version VARCHAR(20),
    last_login TIMESTAMP
);
CREATE TABLE fraud_alerts (
    alert_id SERIAL PRIMARY KEY,
    transaction_id INT REFERENCES transactions(transaction_id),
    alert_type VARCHAR(100),      -- "suspicious_location", "high_amount", "velocity" vb.
    alert_score INT,              -- 1–100 arası risk puanı
    created_at TIMESTAMP DEFAULT NOW()
);
INSERT INTO users (full_name, email, country, signup_date)
VALUES
('Zehra Erdoğan', 'zehra@example.com', 'Turkey', '2024-01-10'),
('Mustafa Temurhan', 'mustafa@example.com', 'Turkey', '2024-02-01'),
('Anna Smith', 'anna@example.com', 'USA', '2024-03-12'),
('John Walker', 'johnw@example.com', 'UK', '2024-04-05'),
('Maria Lopez', 'maria@example.com', 'Spain', '2024-01-25'),
('Ahmed Hassan', 'ahmed@example.com', 'UAE', '2024-03-28'),
('Kaito Tanaka', 'kaito@example.com', 'Japan', '2024-04-02');

SELECT * FROM users;

INSERT INTO cards (user_id, card_number, card_type, issuer_bank)
VALUES
(1, '**** **** **** 1234', 'Visa', 'Ziraat Bank'),
(1, '**** **** **** 5678', 'Mastercard', 'Garanti Bank'),
(2, '**** **** **** 8765', 'Visa', 'İş Bank'),
(3, '**** **** **** 4444', 'Mastercard', 'Bank of America'),
(4, '**** **** **** 2222', 'Visa', 'HSBC'),
(5, '**** **** **** 9999', 'Visa', 'BBVA'),
(6, '**** **** **** 3333', 'Mastercard', 'Emirates NBD');

INSERT INTO merchants (merchant_name, merchant_category, country, city)
VALUES
('TrendyMart', 'E-commerce', 'Turkey', 'Istanbul'),
('CoffeeDream', 'Cafe', 'Turkey', 'Ankara'),
('TechWorld', 'Electronics', 'USA', 'New York'),
('SevenMarket', 'Supermarket', 'UK', 'London'),
('FastFuel', 'Gas Station', 'Spain', 'Madrid'),
('FlyHigh Airlines', 'Airline', 'UAE', 'Dubai');


INSERT INTO device_info (user_id, device_type, operating_system, app_version, last_login)
VALUES
(1, 'mobile', 'iOS', '1.2.3', NOW() - INTERVAL '1 day'),
(1, 'web', 'Windows', '1.0.0', NOW() - INTERVAL '5 days'),
(2, 'mobile', 'Android', '1.2.1', NOW()),
(3, 'tablet', 'iOS', '1.1.0', NOW() - INTERVAL '2 days'),
(4, 'web', 'MacOS', '1.0.5', NOW() - INTERVAL '7 days');

INSERT INTO transactions (user_id, card_id, merchant_id, amount, transaction_date, status, latitude, longitude)
VALUES
(1, 1, 1, 250.50, NOW() - INTERVAL '3 days', 'SUCCESS', 41.0082, 28.9784),
(1, 1, 2, 18.00, NOW() - INTERVAL '2 days', 'SUCCESS', 39.9208, 32.8541),
(1, 2, 2, 20.00, NOW() - INTERVAL '1 hour', 'SUCCESS', 39.9208, 32.8541),
(1, 1, 1, 1800.00, NOW() - INTERVAL '10 minutes', 'SUCCESS', 41.0082, 28.9784), -- yüksek tutar
(2, 3, 6, 950.00, NOW() - INTERVAL '5 days', 'SUCCESS', 25.276987, 55.296249),
(2, 3, 1, 15.90, NOW() - INTERVAL '3 days', 'SUCCESS', 41.0082, 28.9784),
(3, 4, 3, 130.00, NOW() - INTERVAL '8 days', 'SUCCESS', 40.7128, -74.0060),
(3, 4, 3, 125.00, NOW() - INTERVAL '30 minutes', 'SUCCESS', 40.7128, -74.0060),
(4, 5, 4, 55.00, NOW() - INTERVAL '1 day', 'SUCCESS', 51.5074, -0.1278),
(5, 6, 5, 40.00, NOW() - INTERVAL '2 days', 'SUCCESS', 40.4168, -3.7038),
(6, 7, 6, 4000.00, NOW() - INTERVAL '1 hour', 'SUCCESS', 25.276987, 55.296249), -- çok yüksek
(6, 7, 6, 4100.00, NOW() - INTERVAL '10 minutes', 'SUCCESS', 25.276987, 55.296249),
(6, 7, 6, 4200.00, NOW() - INTERVAL '5 minutes', 'SUCCESS', 25.276987, 55.296249), -- velocity pattern
(1, 2, 3, 550.00, NOW() - INTERVAL '20 minutes', 'SUCCESS', 40.7128, -74.0060), -- aniden ABD'den işlem??
(1, 2, 3, 580.00, NOW() - INTERVAL '15 minutes', 'SUCCESS', 40.7128, -74.0060),
(2, 3, 5, 19.99, NOW() - INTERVAL '10 days', 'SUCCESS', 40.4168, -3.7038);







