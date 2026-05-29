# Sprint History: Galaxy Savings App Pro

This document archives all completed development cycles for the project, tracking our iterative progress from inception to the final milestone.

## Sprint 1 (Foundations & Identity)

This document tracks the initial development phase of **Galaxy Savings App Pro**, focusing on project setup, environment configuration, and the establishment of the user journey.

---

## Goal
> **"Establish the architectural foundation, project identity, and the initial user journey (Splash & Onboarding screens)."**

## Timeline
* **Start Date:** 2026-04-01
* **End Date:** 2026-04-14 (Sprint 1)

---

## Development Team & Roles
* **Sergio Hernández Rosas** — Analyst and Designer (UI/UX, MVVM Architecture & Flutter Frontend)
* **Diego Manuel Santos Hernández** — Database Administrator (DBA & Supabase Infrastructure)
* **Said Bañuelos García** — SQL Developer (Tables, Relationships, and Row Level Security)
* **Jeremiah Venegas Rojas** — Query Master (Transactional queries and data integrity)
* **Ricardo Hernández Vera** — Tester / QA (Stress testing and use case validation)

---

## Task Board

| ID | Task / Technical Description | Assigned To | Status |
| :--- | :--- | :--- | :--- |
| **TSK-01** | **[Setup]** Flutter project initialization and folder structure architecture (MVVM). | Sergio Hernández | Completed |
| **TSK-02** | **[DB]** Supabase project initialization and initial SQL table creation. | Diego Manuel | Completed |
| **TSK-03** | **[UI/UX]** Design and implementation of `splash_screen.dart` and Onboarding suite. | Sergio Hernández | Completed |
| **TSK-04** | **[UI/UX]** Creation of `universal_back_button.dart` in common_widgets. | Sergio Hernández | Completed |
| **TSK-05** | **[Routing]** Configuration of `app_router.dart` for navigation flow. | Sergio Hernández | Completed |

---

## Obstacles & Technical Challenges
*Details regarding technical hurdles encountered during this sprint.*

| ID | Description | Impact | Resolution |
| :--- | :--- | :--- | :--- |
| **IMP-01** | Flutter SDK installation/compilation errors. | High | Environment re-configuration and SDK path fix. |
| **IMP-02** | Layout sizing issues on different screens. | Medium | Adjusted responsive constraints and media queries. |
| **IMP-03** | Routing conflicts in `app_router.dart`. | Medium | Refactored route handlers and state management logic. |

---

## Definition of Done (DoD)

For a task to be marked as **Completed**, it must meet the following:

- [ ] Project compiles and builds on target devices.
- [ ] Folder structure adheres to the defined MVVM architecture.
- [ ] Splash and Onboarding screens are visually aligned with the design system.
- [ ] Navigation flow is functional without errors in `app_router.dart`.

---

## Sprint 2 (Authentication & Visual Identity)

This document tracks the second phase of development for **Galaxy Savings App Pro**, focusing on the authentication ecosystem, visual design architecture, and laying the groundwork for the Dashboard.

---

## Goal
> **"Implement the authentication ecosystem (Login/Register), global design architecture, and the foundation of the Dashboard."**

## Timeline
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

## Task Board

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

---
