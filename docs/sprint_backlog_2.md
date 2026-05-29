# Sprint Backlog: Sprint 2 (Authentication & Visual Identity)

This document tracks the second phase of development for **Galaxy Savings App Pro**, focusing on the authentication ecosystem, visual design architecture, and laying the groundwork for the Dashboard.

---

## Sprint Goal
> **"Implement the authentication ecosystem (Login/Register), global design architecture, and the foundation of the Dashboard."**

## Sprint Timeline
* **Start Date:** 2026-04-15
* **End Date:** 2026-04-29 (Sprint 2)

---

## Development Team & Roles
* **Sergio Hernández Rosas** — Analyst and Designer (UI/UX, MVVM Architecture & Flutter Frontend)
* **Diego Manuel Santos Hernández** — Database Administrator (DBA & Supabase Infrastructure)
* **Said Bañuelos García** — SQL Developer (Tables, Relationships, and Row Level Security)
* **Jeremiah Venegas Rojas** — Query Master (Transactional queries and data integrity)
* **Ricardo Hernández Vera** — Tester / QA (Stress testing and use case validation)

---

## Task Board (Sprint 2)

| ID | Task / Technical Description | Assigned To | Status |
| :--- | :--- | :--- | :--- |
| **TSK-01** | **[UI/UX]** Setup color palette and themes (`app_colors.dart`, `app_theme.dart`). | Sergio Hernández | Completed |
| **TSK-02** | **[UI/UX]** Implementation of `login_screen.dart` and `register_screen.dart`. | Sergio Hernández | Completed |
| **TSK-03** | **[UI/UX]** Implementation of `language_screen.dart`. | Sergio Hernández | Completed |
| **TSK-04** | **[Logic]** Creation of Providers for authentication state management. | Sergio Hernández | Completed |
| **TSK-05** | **[UI/UX]** Structural design for `dashboard_screen.dart`. | Sergio Hernández | Completed |

---

## Obstacles & Technical Challenges
*Log of technical challenges overcome during this cycle.*

| ID | Description | Impact | Resolution |
| :--- | :--- | :--- | :--- |
| **IMP-04** | Error connecting user registration to Supabase. | High | Debugged credentials and reconfigured Auth methods. |
| **IMP-05** | Responsiveness issues in `language_screen.dart`. | Low | Adjusted constraints and media query handling. |

---

## Definition of Done (DoD)

For a task to be marked as **Completed**, it must strictly meet the following criteria:

- [ ] The code compiles without warnings or errors in the Dart analyzer.
- [ ] The business logic is completely isolated in its respective `ViewModel` or `Provider`.
- [ ] No hardcoded text strings; all UI text uses `.arb` localization files.
- [ ] The Tester/QA has validated the navigation flow (Login -> Dashboard).
