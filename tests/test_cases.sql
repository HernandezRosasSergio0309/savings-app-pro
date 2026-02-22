-- Test Cases for Savings App Pro
USE savings_app_db;

-- TEST 1: Unique Constraint
-- Expected: This should fail because 'estudiante_cbtis' already exists.
INSERT INTO users (username, password) VALUES ('estudiante_cbtis', 'another_pass');

-- TEST 2: Invalid Foreign Key
-- Expected: This should fail because frequency 99 does not exist.
INSERT INTO savings_goals (user_id, frequency_id, goal_name, target_amount, periodic_amount, start_date, end_date) 
VALUES (1, 99, 'Glitch Goal', 100, 10, '2026-01-01', '2026-12-31');
