# Database Normalization Report: Savings App Pro

## 1. Introduction
This document explains the normalization process applied to the Savings App database. The goal is to eliminate data redundancy and ensure logical dependencies.

## 2. First Normal Form (1NF)
**Requirement:** Atomic values and unique Primary Keys.
* **Analysis:** Every table in this schema (e.g., `users`, `savings_goals`, `frequencies`, `goal_transactions`) includes a unique **Primary Key** (ID). There are no repeating groups or multi-valued attributes; for example, the `password` field contains only one string, and `amount` contains a single decimal value.

## 3. Second Normal Form (2NF)
**Requirement:** Meet 1NF and ensure all non-key attributes are fully dependent on the Primary Key.
* **Analysis:** All non-key columns, such as target_amount in savings_goals or amount in goal_transactions, depend entirely on their respective Primary Keys. Since we use surrogate keys (auto-increment IDs), partial dependencies are non-existent.

## 4. Third Normal Form (3NF)
**Requirement:** Meet 2NF and ensure no transitive dependencies exist (Attributes must depend only on the Primary Key, not on other non-key attributes).
* **Analysis:** We eliminated transitive dependencies by separating the saving intervals into a dedicated frequencies table. The savings_goals table only stores a frequency_id. This ensures that changing a frequency name only requires an update in one record, preventing data inconsistency across multiple goals.

## 5. Conclusion
By reaching 3NF, the database structure prevents update anomalies and optimizes storage efficiency.
