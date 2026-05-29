# Sprint History: Galaxy Savings App Pro

This document archives all completed development cycles for the project, tracking our iterative progress from inception to the final milestone.

## Sprint Backlog: Sprint 1 (Foundations & Identity)

This document tracks the initial development phase of **Galaxy Savings App Pro**, focusing on project setup, environment configuration, and the establishment of the user journey.

---

## Sprint Goal
> **"Establish the architectural foundation, project identity, and the initial user journey (Splash & Onboarding screens)."**

## Sprint Timeline
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

## Task Board (Sprint 1)

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
