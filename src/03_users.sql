-- Savings App Pro - Security Configuration
-- Project: Database Design for Savings Management
-- Author: Hernández Rosas Sergio
-- Version: 1.0

USE savings_app_db;

-- 1. Create a dedicated application user
-- We use 'localhost' to ensure the user can only connect from this machine
CREATE USER IF NOT EXISTS 'savings_app_user'@'localhost' 
IDENTIFIED BY 'Cbtis47_2026';

-- 2. Grant specific privileges
-- The app needs to read, insert, and update, but NOT drop tables
GRANT SELECT, INSERT, UPDATE, DELETE ON savings_app_db.* TO 'savings_app_user'@'localhost';

-- 3. Apply changes
FLUSH PRIVILEGES;
