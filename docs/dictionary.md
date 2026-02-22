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
| `frequency_id` | `TINYINT` | `PRIMARY KEY, AUTO_INCREMENT` | Unique identifier for the frequency type. |
| `frequency_name` | `VARCHAR(20)` | `NOT NULL, UNIQUE` | The name of the interval (e.g., Daily, Weekly, Monthly). |

## 3. Table: savings_goals
**Description**: Stores the specific saving objectives created by users, including target amounts and timeframes.

| Field | Data Type | Constraints | Description |
| :--- | :--- | :--- | :--- |
| `goal_id` | `INT` | `PRIMARY KEY, AUTO_INCREMENT` | Unique identifier for the goal. |
| `user_id` | `INT` | `FOREIGN KEY, NOT NULL` | Reference to the owner in the `users` table. |
| `frequency_id` | `TINYINT` | `FOREIGN KEY, NOT NULL` | Reference to the selected interval in `frequencies`. |
| `goal_name` | `VARCHAR(100)` | `NOT NULL` | Name or description of the goal (e.g., "New Laptop"). |
| `target_amount` | `DECIMAL(10,2)` | `NOT NULL` | The total savings target amount. |
| `periodic_amount` | `DECIMAL(10,2)` | `NOT NULL` | The calculated amount to be saved in each period. |
| `start_date` | `DATE` | `NOT NULL` | The date when the saving goal begins. |
| `end_date` | `DATE` | `NOT NULL` | The expected completion date. |

## 4. Table: goal_transactions
**Description**: Records every individual contribution made towards a specific saving goal, maintaining a historical log of all deposits.

| Field | Data Type | Constraints | Description |
| :--- | :--- | :--- | :--- |
| `transaction_id` | `INT` | `PRIMARY KEY, AUTO_INCREMENT` | Unique internal identifier for each transaction. |
| `goal_id` | `INT` | `FOREIGN KEY, NOT NULL` | Reference to the associated goal in `savings_goals`. |
| `amount` | `DECIMAL(10,2)` | `NOT NULL` | The specific amount of money deposited in this transaction. |
| `transaction_date`| `TIMESTAMP` | `DEFAULT CURRENT_TIMESTAMP` | The exact date and time when the deposit was made. |
