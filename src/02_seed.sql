-- Savings App Pro - Seed Data
-- Purpose: Populate the database with initial test records

USE savings_app_db;

-- 1. Populate Frequencies (Catalogs first!)
INSERT INTO frequencies (frequency_name) 
VALUES ('Daily'), ('Weekly'), ('Bi-weekly'), ('Monthly');

-- 2. Populate Users
INSERT INTO users (username, password) 
VALUES ('estudiante_cbtis', 'ahorro_2026');

-- 3. Populate Savings Goals (Connecting user 1 and frequency 4)
INSERT INTO savings_goals (user_id, frequency_id, goal_name, target_amount, periodic_amount, start_date, end_date) 
VALUES (1, 4, 'New Laptop', 15000.00, 500.00, '2026-03-01', '2027-03-01');

-- 4. Populate Goal Transactions (A first deposit of 500.00 for goal 1)
INSERT INTO goal_transactions (goal_id, amount) 
VALUES (1, 500.00);
