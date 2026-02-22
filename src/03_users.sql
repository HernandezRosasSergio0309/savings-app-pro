-- Savings App Pro - User Access & Security
-- Purpose: Create a dedicated application user and grant permissions

-- 1. Create the application user
-- We use 'localhost' assuming the App and DB are on the same server
CREATE USER IF NOT EXISTS 'savings_app_user'@'localhost' IDENTIFIED BY 'Cbtis47_2026';

-- 2. Grant permissions on the specific database
-- This follows the Principle of Least Privilege (limiting access to one DB)
GRANT ALL PRIVILEGES ON savings_app_db.* TO 'savings_app_user'@'localhost';

-- 3. Apply changes
FLUSH PRIVILEGES;
