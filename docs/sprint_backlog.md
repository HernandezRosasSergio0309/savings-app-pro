# Sprint Backlog: Galaxy Savings App Pro (Closing Cycle)

This document reflects the iterative work, role assignment, and tracking of active tasks for the final development cycle before the June 12th milestone.

---

## Sprint Goal
*Define the primary objective for this cycle.*
> **"Complete core savings modalities (Target/Freestyle) and integrate final UI aesthetics (Glassmorphism) for iOS deployment."**

## Sprint Timeline
* **Start Date:** 2026-05-15
* **End Date:** 2026-06-05(Closing Cycle)

---

## Development Team & Roles
* **Sergio Hernández Rosas** — Analyst and Designer (UI/UX, MVVM Architecture & Flutter Frontend)
* **Diego Manuel Santos Hernández** — Database Administrator (DBA & Supabase Infrastructure)
* **Said Bañuelos García** — SQL Developer (Tables, Relationships, and Row Level Security)
* **Jeremiah Venegas Rojas** — Query Master (Transactional queries and data integrity)
* **Ricardo Hernández Vera** — Tester / QA (Stress testing and use case validation)

---

## Task Board (Closing Sprint)

| ID | Task / Technical Description | Assigned To | Status |
| :--- | :--- | :--- | :--- |
| **TSK-08** | **[UI/Logic]** Implement `TargetSaving` workflow (Create/Manage Screens & ViewModel). | Sergio Hernández | Completed |
| **TSK-09** | **[UI/Logic]** Implement `FreestyleSaving` workflow (Create/Manage Screens & ViewModel). | Sergio Hernández | Completed |
| **TSK-07** | **[UI/UX]** Integration of `cosmic_celebration_stars` for goal completion. | Sergio Hernández | Completed |
| **TSK-10** | **[UI/UX]** Implement Glassmorphism design system specifically for iOS. | Sergio Hernández | In Progress |
| **TSK-06** | **[QA]** Withdrawal interception tests (Insufficient funds validation). | Ricardo Hernández | Pending |

---

## Impediments / Blockers
*List any technical or resource-based obstacles currently hindering progress.*

| ID | Blocker Description | Owner | Status |
| :--- | :--- | :--- | :--- |
| **IMP-02** | Optimizing Glassmorphism performance on iOS (Impeller rendering checks). | Sergio H. | Investigating |

---

## Definition of Done (DoD)

For a task on the board above to be marked as **Completed**, it must strictly meet the following criteria:

- [ ] The code compiles without warnings or errors in the Dart analyzer.
- [ ] The business logic is completely isolated in its respective `ViewModel` or `Provider`.
- [ ] There are no hardcoded text strings; all UI text must use `.arb` localization files.
- [ ] The Tester/QA has validated the scenarios described in the acceptance criteria of the corresponding User Story.
