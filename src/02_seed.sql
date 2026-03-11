-- Savings App Pro - Seed Data
-- Project: Database Design for Savings Management
-- Version: 2.0

USE savings_app_db;

-- 1. Populating Frequencies
INSERT INTO frequencies (frequency_id, frequency_name) VALUES 
(1, 'Daily'),
(2, 'Weekly'),
(3, 'Biweekly'),
(4, 'Monthly');

-- 2. Populating Users
INSERT INTO users (username, password) VALUES 
('sergio_admin', 'admin123'),
('said_dev', 'dev456'),
('diego_guardian', 'pass789');

-- 3. Populating Savings Goals
-- Note: Goal 1 & 2 are system "Piggy Banks" (No target, no end date)
-- Note: Goal 3 & 4 are specific user goals
INSERT INTO savings_goals (user_id, frequency_id, goal_name, target_amount, periodic_amount, start_date, end_date, is_system_goal) VALUES 
(1, 4, 'General Savings', NULL, 100.00, '2026-01-01', NULL, TRUE),
(2, 4, 'My Piggy Bank', NULL, 50.00, '2026-01-01', NULL, TRUE),
(1, 4, 'New Laptop', 15000.00, 1250.00, '2026-01-01', '2026-12-31', FALSE),
(2, 2, 'Summer Trip', 5000.00, 500.00, '2026-03-01', '2026-06-01', FALSE);

-- 4. Populating Transactions
-- Deposits to General Savings (Goal 1) and Laptop (Goal 3)
INSERT INTO goal_transactions (goal_id, amount) VALUES 
(1, 200.00), -- Deposit to Piggy Bank
(3, 1250.00), -- Deposit to Laptop Goal
(3, 1250.00),
(4, 500.00);
