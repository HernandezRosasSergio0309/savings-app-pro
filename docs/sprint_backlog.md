# Sprint Backlog: Galaxy Savings App Pro

This document reflects the iterative work, role assignment, and tracking of active tasks for the current development cycle of **Galaxy Savings App Pro**.

---

## Sprint Goal
*Define the primary objective for this cycle.*
> **"Finalize the core transaction engine and implement secure streak tracking to ensure data integrity and user consistency."**

## Sprint Timeline
* **Start Date:** 2026-05-29
* **End Date:** 2026-06-12 (2-week Sprint)

---

## Development Team & Roles
* **Sergio Hernández Rosas** — Analyst and Designer (UI/UX, MVVM Architecture & Flutter Frontend)
* **Diego Manuel Santos Hernández** — Database Administrator (DBA & Supabase Infrastructure)
* **Said Bañuelos García** — SQL Developer (Tables, Relationships, and Row Level Security)
* **Jeremiah Venegas Rojas** — Query Master (Transactional queries and data integrity)
* **Ricardo Hernández Vera** — Tester / QA (Stress testing and use case validation)

---

## Task Board (Current Sprint)

| ID | Task / Technical Description | Assigned To | Status |
| :--- | :--- | :--- | :--- |
| **TSK-01** | **[DB]** Schema design for the `savings_goals` and `goal_transactions` tables. | Diego Manuel | Completed |
| **TSK-02** | **[UI/UX]** Implementation of the MVVM view for the Dashboard using Riverpod. | Sergio Hernández | Completed |
| **TSK-03** | **[SQL]** Creation of security policies (RLS). | Said Bañuelos | Completed |
| **TSK-04** | **[Logic]** Historical balance reconstruction engine. | Jeremiah Venegas | In Progress |
| **TSK-05** | **[Logic]** Streaks calculation in 24-hour blocks. | Sergio Hernández | In Progress |
| **TSK-06** | **[QA]** Withdrawal interception tests (Insufficient funds). | Ricardo Hernández | Pending |
| **TSK-07** | **[UI/UX]** Cosmic celebration animations (100% goal). | Sergio Hernández | Pending |

---

## Impediments / Blockers
*List any technical or resource-based obstacles currently hindering progress.*

| ID | Blocker Description | Owner | Status |
| :--- | :--- | :--- | :--- |
| **IMP-01** | Need to confirm Impeller rendering behavior with current shaders. | Sergio H. | Investigating |

---

## Definition of Done (DoD)

For a task on the board above to be marked as **Completed**, it must strictly meet the following criteria:

- [ ] The code compiles without warnings or errors in the Dart analyzer.
- [ ] The business logic is completely isolated in its respective `ViewModel` or `Provider`.
- [ ] There are no hardcoded text strings; all UI text must use `.arb` localization files.
- [ ] The Tester/QA has validated the scenarios described in the acceptance criteria of the corresponding User Story.
