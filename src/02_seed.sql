-- Savings App Pro - Seed Data
-- Project: Database Design for Savings Management
-- Author: Venegas Rojas Jeremiah
-- Version: 1.1

USE savings_app_db;

-- 1. Populating Frequencies (Manual IDs as we removed AUTO_INCREMENT)
INSERT INTO frequencies (frequency_id, frequency_name) VALUES 
(1, 'Daily'),
(2, 'Weekly'),
(3, 'Biweekly'),
(4, 'Monthly');

-- 2. Populating Users (Passwords should be hashed in production, using plain text for testing)
INSERT INTO users (username, password) VALUES 
('sergio_admin', 'admin123'),
('said_dev', 'dev456'),
('diego_guardian', 'pass789');

-- 3. Populating Savings Goals
-- Note: user_id 1 is Sergio, frequency_id 4 is Monthly
INSERT INTO savings_goals (user_id, frequency_id, goal_name, target_amount, periodic_amount, start_date, end_date) VALUES 
(1, 4, 'New Laptop', 15000.00, 1250.00, '2026-01-01', '2026-12-31'),
(2, 2, 'Summer Trip', 5000.00, 500.00, '2026-03-01', '2026-06-01');

-- 4. Populating Transactions
-- Note: goal_id 1 is the Laptop goal
INSERT INTO goal_transactions (goal_id, amount) VALUES 
(1, 1250.00),
(1, 1250.00),
(2, 500.00);
