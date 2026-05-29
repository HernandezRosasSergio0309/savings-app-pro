# Sprint Backlog: Sprint 3 (Navigation, Settings & Social Auth)

This document tracks the third phase of development for **Galaxy Savings App Pro**, focusing on settings management, global navigation architecture, and integrating Google Authentication.

---

## Sprint Goal
> **"Integrate settings functionality, implement global navigation (Toolbar), and finalize Google Authentication integration with Supabase."**

## Sprint Timeline
* **Start Date:** 2026-04-30
* **End Date:** 2026-05-14 (Sprint 3)

---

## Development Team & Roles
* **Sergio Hernández Rosas** — Analyst and Designer (UI/UX, MVVM Architecture & Flutter Frontend)
* **Diego Manuel Santos Hernández** — Database Administrator (DBA & Supabase Infrastructure)
* **Said Bañuelos García** — SQL Developer (Tables, Relationships, and Row Level Security)
* **Jeremiah Venegas Rojas** — Query Master (Transactional queries and data integrity)
* **Ricardo Hernández Vera** — Tester / QA (Stress testing and use case validation)

---

## Task Board (Sprint 3)

| ID | Task / Technical Description | Assigned To | Status |
| :--- | :--- | :--- | :--- |
| **TSK-01** | **[UI/UX]** Implementation of `savings_selection_screen.dart`, `settings_screen.dart`, and `edit_profile_screen.dart`. | Sergio Hernández | Completed |
| **TSK-02** | **[Logic]** Implement user settings (Logout, Delete Account, Theme, Language, Profile editing). | Sergio Hernández | Completed |
| **TSK-03** | **[Navigation]** Create global Toolbar and integrate with `app_router.dart` for cross-screen navigation. | Sergio Hernández | Completed |
| **TSK-04** | **[Auth]** Integrate Google Sign-In with Supabase. | Sergio Hernández | Completed |
| **TSK-05** | **[Assets]** Update and optimize project imagery. | Sergio Hernández | Completed |

---

## Obstacles & Technical Challenges
*Log of technical challenges overcome during this cycle.*

| ID | Description | Impact | Resolution |
| :--- | :--- | :--- | :--- |
| **IMP-06** | Toolbar layout and design inconsistencies. | Medium | Refactored custom widget layout parameters. |
| **IMP-07** | Routing errors in `settings_screen.dart`. | Medium | Standardized navigation pathing in `app_router.dart`. |
| **IMP-08** | Permission issues for account deletion in Supabase. | High | Updated RLS policies to allow authorized user deletion. |
| **IMP-09** | Profile editing (photo/name) bugs. | Medium | Corrected state management logic in the `edit_profile` view model. |
| **IMP-10** | Google Auth user persistence & post-signup routing. | High | Debugged callback handlers and navigation stack after auth completion. |

---

## Definition of Done (DoD)

For a task to be marked as **Completed**, it must strictly meet the following criteria:

- [ ] The code compiles without warnings or errors in the Dart analyzer.
- [ ] The business logic is completely isolated in its respective `ViewModel` or `Provider`.
- [ ] No hardcoded text strings; all UI text uses `.arb` localization files.
- [ ] The Tester/QA has validated the navigation flow (Dashboard -> Savings -> Settings).
