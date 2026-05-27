# Sprint Backlog

This document reflects the iterative work, role assignment, and tracking of active tasks for the current development cycle of **Galaxy Savings App Pro**. It is used to maintain transparency and a steady pace for the development team.

---

## Development Team & Roles

The technical squad behind the construction of the database, business logic, and system interface is composed of:

* **Sergio Hernández Rosas** — Analyst and Designer (UI/UX, MVVM Architecture & Flutter Frontend).
* **Diego Manuel Santos Hernández** — Database Administrator (DBA & Supabase Infrastructure).
* **Said Bañuelos García** — SQL Developer (Tables, Relationships, and Row Level Security).
* **Jeremiah Venegas Rojas** — Query Master (Transactional queries and data integrity).
* **Ricardo Hernández Vera** — Tester / QA (Stress testing and use case validation).

---

## Task Board (Current Sprint)

Below is the breakdown of technical tasks derived from the accepted User Stories for the current cycle.

| ID | Tarea / Descripción Técnica | Asignado a | Estado |
| :--- | :--- | :--- | :--- |
| **TSK-01** | **[DB]** Schema design for the `savings_goals` and `goal_transactions` tables in PostgreSQL (Supabase). | Diego Manuel | Completed |
| **TSK-02** | **[UI/UX]** Implementation of the MVVM view for the main screen (Dashboard) using Riverpod (`savings_provider`). | Sergio Hernández | Completed |
| **TSK-03** | **[SQL]** Creation of security policies (RLS) to ensure that each user can only read their own goals. | Said Bañuelos | Completed |
| **TSK-04** | **[Logic]** Development of the logic engine for the reconstruction of the historical balance from deposits and withdrawals. | Jeremiah Venegas | In Progress |
| **TSK-05** | **[Logic]** Implementation of streaks calculation in 24-hour blocks within the `manage_target_screen_view_model`. | Sergio Hernández | In Progress |
| **TSK-06** | **[QA]** Execution of interception tests: Validate that the system blocks withdrawals with insufficient funds. | Ricardo Hernández | Pending |
| **TSK-07** | **[UI/UX]** Integration of immersive animations (`cosmic_celebration_stars`) upon reaching 100% of the goal. | Sergio Hernández | Pending |

---

## Definition of Done (DoD)

For a task on the board above to be marked as **Completed**, it must strictly meet the following criteria:

1. The code compiles without warnings or errors in the Dart analyzer.
2. The business logic is completely isolated in its respective `ViewModel` or `Provider`.
3. There are no hardcoded text strings; all UI text must use `.arb` localization files.
4. The Tester/QA has validated the scenarios described in the acceptance criteria of the corresponding User Story.
