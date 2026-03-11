# Data Dictionary - Savings App Pro

This document provides a detailed description of the database schema, including tables, fields, data types, constraints, and their respective purposes within the savings management system.

## 1. Table: users
**Description**: Stores authentication credentials and identity information for each account holder.

| Field | Data Type | Constraints | Description |
| :--- | :--- | :--- | :--- |
| `user_id` | `INT` | `PRIMARY KEY, AUTO_INCREMENT` | Unique internal identifier for the user. |
| `username` | `VARCHAR(60)` | `NOT NULL, UNIQUE` | Unique name used for account identification and login. |
| `password` | `VARCHAR(255)` | `NOT NULL` | The hashed security key for user authentication. |

## 2. Table: frequencies
**Description**: A catalog table that defines the available recurrence intervals for savings contributions.

| Field | Data Type | Constraints | Description |
| :--- | :--- | :--- | :--- |
| `frequency_id` | `TINYINT` | `PRIMARY KEY` | Unique identifier for the frequency type. (Manual Assignment). |
| `frequency_name` | `VARCHAR(20)` | `NOT NULL, UNIQUE` | The name of the interval (e.g., Daily, Weekly, Monthly). |

## 3. Table: savings_goals
**Description**: Stores specific saving objectives. Supports both defined targets and general "Piggy Bank" savings.

| Field | Data Type | Constraints | Description |
| :--- | :--- | :--- | :--- |
| `goal_id` | `INT` | `PRIMARY KEY, AUTO_INCREMENT` | Unique identifier for the goal. |
| `user_id` | `INT` | `FOREIGN KEY, NOT NULL` | Reference to the owner in the `users` table. |
| `frequency_id` | `TINYINT` | `FOREIGN KEY, NOT NULL` | Reference to the selected interval in `frequencies`. |
| `goal_name` | `VARCHAR(100)` | `NOT NULL` | Name of the goal (e.g., "New Laptop" or "General Savings"). |
| `target_amount` | `DECIMAL(10,2)` | `CHECK > 0, NULLABLE` | The total savings target. Can be NULL for general savings. |
| `periodic_amount` | `DECIMAL(10,2)` | `NOT NULL, CHECK > 0` | The amount to be saved in each period. |
| `start_date` | `DATE` | `NOT NULL` | The date when the saving goal begins. |
| `end_date` | `DATE` | `NULLABLE` | The expected completion date. Can be NULL for general savings. |
| `is_system_goal` | `BOOLEAN` | `DEFAULT FALSE` | Flag: `TRUE` for the default piggy bank, `FALSE` for user-defined goals. |

## 4. Table: goal_transactions
**Description**: Records every individual contribution made towards a specific saving goal.

| Field | Data Type | Constraints | Description |
| :--- | :--- | :--- | :--- |
| `transaction_id` | `INT` | `PRIMARY KEY, AUTO_INCREMENT` | Unique internal identifier for each transaction. |
| `goal_id` | `INT` | `FOREIGN KEY, NOT NULL` | Reference to the associated goal. |
| `amount` | `DECIMAL(10,2)` | `NOT NULL, CHECK > 0` | The specific amount of money deposited. |
| `transaction_date`| `TIMESTAMP` | `DEFAULT CURRENT_TIMESTAMP` | Exact date and time when the deposit was made. |
