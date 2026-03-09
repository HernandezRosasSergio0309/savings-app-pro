-- Savings App Pro - Quality Assurance Tests
-- Purpose: Verify data integrity and constraints

USE savings_app_db;

-- [TEST 01] Duplicate User Verification
-- Expected Result: ERROR (Duplicate entry for 'username')
-- Description: Testing if UNIQUE constraint prevents duplicate usernames.
INSERT INTO users (username, password) VALUES ('estudiante_cbtis', 'new_pass_123');


-- [TEST 02] Referential Integrity: Frequencies
-- Expected Result: ERROR (Foreign Key constraint fails)
-- Description: Testing if we can create a goal with a non-existent frequency ID (99).
INSERT INTO savings_goals (user_id, frequency_id, goal_name, target_amount, periodic_amount, start_date, end_date) 
VALUES (1, 99, 'Ghost Goal', 1000.00, 100.00, '2026-01-01', '2026-12-31');


-- [TEST 03] Referential Integrity: Transactions
-- Expected Result: ERROR (Foreign Key constraint fails)
-- Description: Testing if we can add a transaction to a non-existent goal ID (500).
INSERT INTO goal_transactions (goal_id, amount) 
VALUES (500, 50.00);


-- [TEST 04] Data Type Precision
-- Expected Result: SUCCESS (but check rounding)
-- Description: Testing how the DECIMAL(10,2) handles more than 2 decimal places.
INSERT INTO goal_transactions (goal_id, amount) 
VALUES (1, 99.999); -- Should be stored as 100.00 or 99.99 depending on DB config.
