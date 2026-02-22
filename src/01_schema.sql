-- Savings App Pro - Database Schema
-- Project: Database Design for Savings Management
-- Author: Hernández Rosas Sergio
-- Version: 1.0

-- 0. Environment Setup
-- Create the database if it doesn't exist and select it for use
CREATE DATABASE IF NOT EXISTS savings_app_db;
USE savings_app_db;

-- 1. Table: users
-- Stores authentication credentials
CREATE TABLE IF NOT EXISTS users (
    user_id INT AUTO_INCREMENT,
    username VARCHAR(60) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    PRIMARY KEY (user_id)
);

-- 2. Table: frequencies
-- Catalog table for saving intervals (Daily, Weekly, etc.)
CREATE TABLE IF NOT EXISTS frequencies (
    frequency_id TINYINT AUTO_INCREMENT,
    frequency_name VARCHAR(20) NOT NULL UNIQUE,
    PRIMARY KEY (frequency_id)
);

-- 3. Table: savings_goals
-- Main entity for user saving objectives
CREATE TABLE IF NOT EXISTS savings_goals (
    goal_id INT AUTO_INCREMENT,
    user_id INT NOT NULL,
    frequency_id TINYINT NOT NULL,
    goal_name VARCHAR(100) NOT NULL,
    target_amount DECIMAL(10,2) NOT NULL,
    periodic_amount DECIMAL(10,2) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    PRIMARY KEY (goal_id),
    CONSTRAINT fk_goal_user FOREIGN KEY (user_id) REFERENCES users(user_id),
    CONSTRAINT fk_goal_frequency FOREIGN KEY (frequency_id) REFERENCES frequencies(frequency_id)
);

-- 4. Table: goal_transactions
-- History of deposits made towards specific goals
CREATE TABLE IF NOT EXISTS goal_transactions (
    transaction_id INT AUTO_INCREMENT,
    goal_id INT NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    transaction_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (transaction_id),
    CONSTRAINT fk_transaction_goal FOREIGN KEY (goal_id) REFERENCES savings_goals(goal_id)
);
