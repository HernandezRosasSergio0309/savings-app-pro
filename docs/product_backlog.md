# Product Backlog & Software Requirements Specification (SRS)

This document details the formal software requirements specification, the underlying data architecture, and the high-level agile planning for **Galaxy Savings App Pro**. The described structure ensures the integrity of the MVVM pattern, isolating business rules from the presentation layer.

---

## 1. Data Architecture & Entities (Data Schema)

The system relies on a PostgreSQL relational database (Supabase) structured under the following main schemas:

### 1.1 Entity: `savings_goals`
Represents the central savings goal, strictly linked to the account owner.
*   `goal_id` (UUID, Primary Key): Unique identifier for the goal.
*   `user_id` (UUID, Foreign Key): Goal owner (Security Lock for RLS).
*   `goal_name` (Text): Descriptive name of the goal.
*   `target_amount` (Numeric, Nullable): Financial target amount. If `null`, the system automatically classifies the goal as **Freestyle** savings.
*   `start_date` (Timestamptz): Exact creation date and time, used as the starting point ("Epoch") for the streaks engine.
*   `frequency_id` (Integer, Foreign Key): Reference to the `frequencies` table to determine the suggested periodicity.

### 1.2 Entity: `goal_transactions`
Immutable audit table for financial movements.
*   `goal_id` (UUID, Foreign Key): Reference to the parent goal.
*   `amount` (Numeric): Monetary amount of the operation.
*   `transaction_type` (String): Strict classification (`'deposito'` or `'retiro'`).
*   `transaction_date` (Timestamptz): ISO-8601 timestamp of the exact moment of the record.

---

## 2. Software Requirements Specification (SRS)

### 2.1 Functional Requirements & Business Rules (FR)

#### **Module: Transactional Engine & Modalities**
*   **FR-01 (Dynamic Classification):** When querying the system, the `target_amount` field must be evaluated. If it lacks a value, the goal will operate in **Freestyle** mode (limitless savings); otherwise, it will operate in **Target** mode (fixed objective).
*   **FR-02 (Historical Balance):** The system will chronologically process the `goal_transactions` table. Every `transaction_type` equal to `'deposito'` will add to the accumulated total; if it is `'retiro'`, it will subtract, generating a historical balance.
*   **FR-03 (Visual Restriction - Clamp):** For **Target** goals, the progress percentage will be calculated by dividing the current balance by the `target_amount`, mathematically restricting the value between 0 and 100 (`clamp(0, 100)`) to prevent overflows in the UI.
*   **FR-04 (Insufficient Funds Interception):** The ViewModel must audit every `'retiro'` attempt. If the `amount` exceeds the current balance, the transaction will be aborted by throwing the `FormatException('insufficient_funds')` exception.

#### **Module: Gamification (Streaks Engine)**
*   **FR-05 (Streaks Audit):** The engine will evaluate exact 24-hour blocks, starting from the goal's `start_date` up to the current date.
*   **FR-06 (Success Criteria):** A 24-hour block will be marked as successful (`isSuccess: true`) if and only if there is at least one `'deposito'` record within that time frame.

### 2.2 Non-Functional Requirements (NFR)
*   **NFR-01 (Data Isolation):** Queries must be filtered at the client level using the active session identifier (`eq('user_id', currentUser.id)`), backed by Row Level Security (RLS) policies in PostgreSQL.
*   **NFR-02 (Memory Management):** Asynchronous data streams in navigation screens must use the `.autoDispose` directive to purge the cache and prevent memory leaks when unmounting the view.
*   **NFR-03 (Internationalization):** The system must provide native and instant support for 9 languages through `.arb` files, avoiding the use of hardcoded text strings in the UI.

---

## 3. Product Backlog (Epics & User Stories)

### 3.1 Epics
*   **EPIC-01: Identity & Security** (Auth, Row Level Security, Client-Side Filtering).
*   **EPIC-02: Dashboard & Adaptive Interface** (Responsive UI, Liquid Glass Aesthetics, i18n).
*   **EPIC-03: Transactional Engine** (Target/Freestyle logic, Balance Reconstruction).
*   **EPIC-04: Spatial Gamification** (Streaks Engine, CustomPainter Animations).

### 3.2 User Stories & Acceptance Criteria (Gherkin Syntax)

| ID | User Story | Priority | Estimate | Status |
| :--- | :--- | :---: | :---: | :--- |
| **US-01** | Private Goal Loading on Dashboard | High | 3 pts | 🟡 To Do |
| **US-02** | Invalid Transaction Interception | High | 2 pts | 🟡 To Do |
| **US-03** | Savings Streaks Audit | Medium | 5 pts | 🟡 To Do |

#### **Detailed US-01: Private Goal Loading on Dashboard**
> **As an** authenticated user,
> **I want** the main dashboard to display only my information,
> **So that** I can ensure the absolute privacy of my finances.

**Acceptance Scenarios:**
*   **Given that** the user has logged into the device,
*   **When** the system initializes the loading of the dashboard,
*   **Then** the Provider injects the `currentUser.id` into the request, exclusively retrieves the associated goals, and clears the data from memory upon changing modules.

#### **Detailed US-02: Invalid Transaction Interception**
> **As a** system user,
> **I want** to record withdrawals from my goals,
> **So that** I can use my funds, ensuring I do not exceed what I have saved.

**Acceptance Scenarios:**
*   **Given that** the user has a consolidated balance of `$150.00`,
*   **When** attempting to record a `'retiro'` operation for `$200.00`,
*   **Then** the ViewModel blocks data persistence, throws the `insufficient_funds` error, and the view displays a transactional
