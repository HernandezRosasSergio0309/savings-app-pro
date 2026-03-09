# Bug Report - Savings App Pro

## Bug #001: Missing Referential Integrity on Delete
- **Status**: Fixed
- **Severity**: High
- **Description**: During initial testing, deleting a user did not trigger any error even if they had active savings goals, leaving "orphan" records in the `savings_goals` table.
- **Root Cause**: Foreign keys were defined without proper RESTRICT or CASCADE rules.
- **Resolution**: Updated `01_schema.sql` to ensure that `user_id` in `savings_goals` correctly references `users(user_id)`.

## Bug #002: Goal Name Truncation
- **Status**: Fixed
- **Severity**: Low
- **Description**: Long goal titles like "New specialized gaming laptop for college" were being cut off.
- **Root Cause**: The `goal_name` column was initially defined as `VARCHAR(30)`.
- **Resolution**: Altered the table schema to increase the limit to `VARCHAR(100)`.

## Bug #003: Negative Transaction Amount
- **Status**: Documented
- **Severity**: Medium
- **Description**: The database accepts negative numbers in the `amount` column of `goal_transactions`.
- **Note**: This is currently handled via application logic, but a `CHECK (amount > 0)` constraint is recommended for future database versions.
