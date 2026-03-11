-- Savings App Pro - Database Schema
-- Project: Database Design for Savings Management
-- Author: Hernández Rosas Sergio
-- Version: 1.2

-- 0. Environment Setup
CREATE DATABASE IF NOT EXISTS savings_app_db;
USE savings_app_db;

-- 1. Table: users
CREATE TABLE IF NOT EXISTS users (
    user_id INT AUTO_INCREMENT,
    username VARCHAR(60) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    PRIMARY KEY (user_id)
);

-- 2. Table: frequencies
CREATE TABLE IF NOT EXISTS frequencies (
    frequency_id TINYINT,
    frequency_name VARCHAR(20) NOT NULL UNIQUE,
    PRIMARY KEY (frequency_id)
);

-- 3. Table: savings_goals
CREATE TABLE IF NOT EXISTS savings_goals (
    goal_id INT AUTO_INCREMENT,
    user_id INT NOT NULL,
    frequency_id TINYINT NOT NULL,
    goal_name VARCHAR(100) NOT NULL,
    -- target_amount is now NULLABLE for general savings
    target_amount DECIMAL(10,2) CHECK (target_amount > 0), 
    periodic_amount DECIMAL(10,2) NOT NULL CHECK (periodic_amount > 0),
    start_date DATE NOT NULL,
    -- end_date is now NULLABLE for general savings
    end_date DATE, 
    -- Flag to identify the default system goal
    is_system_goal BOOLEAN DEFAULT FALSE,
    PRIMARY KEY (goal_id),
    CONSTRAINT fk_goal_user FOREIGN KEY (user_id) 
        REFERENCES users(user_id) ON DELETE CASCADE,
    CONSTRAINT fk_goal_frequency FOREIGN KEY (frequency_id) 
        REFERENCES frequencies(frequency_id)
);

-- 4. Table: goal_transactions
CREATE TABLE IF NOT EXISTS goal_transactions (
    transaction_id INT AUTO_INCREMENT,
    goal_id INT NOT NULL,
    amount DECIMAL(10,2) NOT NULL CHECK (amount > 0),
    transaction_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (transaction_id),
    CONSTRAINT fk_transaction_goal FOREIGN KEY (goal_id) 
        REFERENCES savings_goals(goal_id) ON DELETE CASCADE
);
