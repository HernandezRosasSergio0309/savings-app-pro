# Sprint Backlog: Sprint 2 — Authentication UI, Validation & Theme Infrastructure

This second cycle covers the design and visual implementation of the authentication flows (Login and Registration), the centralization of universal navigation components, the global form validation framework, and the initialization of essential state providers (Authentication, Locale, and Theme), concluding with the visual shell of the Dashboard.

## Sprint Goal
> **"Implement high-fidelity user authentication screens with robust form validation utilities, centralize core structural router mechanisms, and initialize baseline state management modules."**

## Sprint Timeline & Capacity
* **Expected Duration:** 2 Weeks (April 15 – April 29, 2026)
* **Total Estimated Effort:** 40 Hours Allocated

---

## Development Team, Roles & Responsibilities (With Estimated Hours)
* **Sergio Hernández Rosas** — *Analyst & Designer* | **Estimated: 16 Hours** Responsible for drafting and coding structural screens (`login_screen`, `register_screen`, `dashboard_screen`), creating the responsive input wrapper (`auth_scaffold`), and building the reusable global fields.
* **Diego Manuel Santos Hernández** — *Database Administrator (DBA)* | **Estimated: 4 Hours** Responsible for path mapping and testing core navigation controls inside the routing manager framework.
* **Said Bañuelos García** — *SQL Developer* | **Estimated: 6 Hours** Responsible for managing systematic regex evaluation rules and tracking key static strings inside core asset configurations.
* **Jeremiah Venegas Rojas** — *Query Master* | **Estimated: 7 Hours** Responsible for establishing core boilerplate instances for async state notifier configurations across localization, authentication, and layout theme providers.
* **Ricardo Hernández Vera** — *Tester / QA* | **Estimated: 7 Hours** Responsible for execution of rigorous form validation stress-testing, layout rendering audits across multiple themes, and edge-case form testing.

---

## User Stories in Scope

### US-AUTH-03: Secure Access Forms & Data Validation
* **As a** user looking to manage my savings  
* **I want to** fill out standardized login and registration forms with real-time feedback  
* **So that** I can prevent typing errors and ensure my security parameters match formatting rules before submission.
* **Acceptance Criteria:**
  - [ ] Forms under `login_screen.dart` and `register_screen.dart` consume localized, unified fields.
  - [ ] Input strings undergo structural verification using rules compiled inside `app_validators.dart`.
  - [ ] Configuration parameters dynamically adapt styles using constant values defined in `app_constants.dart`.

### US-NAV-02: Centralized Back-Navigation Management
* **As a** multi-view application user  
* **I want to** experience consistent backward navigation components across workflows  
* **So that** my navigation habits remain intuitive regardless of the active visual module.
* **Acceptance Criteria:**
  - [ ] The custom controller in `universal_back_button.dart` handles target pop actions through configuration bindings.
  - [ ] The global router configuration layer `app_router.dart` properly references and structures historical navigation stacks.

### US-STATE-02: Core State Engine Initialization
* **As a** system layer component  
* **I want to** bind foundational states to multi-view provider environments  
* **So that** localized settings, active themes, and session configurations synchronize reactively.
* **Acceptance Criteria:**
  - [ ] `auth_provider.dart` maps access control flags securely across structural layers.
  - [ ] `locale_provider.dart` and `theme_provider.dart` correctly emit active language and visual state updates.

### US-DASH-02: Main Application Shell Design
* **As an** authenticated user  
* **I want to** land on a high-fidelity dashboard layout placeholder immediately after entry  
* **So that** I can preview the visual grid and modular layout distribution of my account data.
* **Acceptance Criteria:**
  - [ ] `dashboard_screen.dart` renders high-fidelity visual UI skeletons matching design specifications.
  - [ ] Layout contains static element wireframes with zero operational backend dependencies required for this sprint phase.

---

## Task Board & Hourly Estimation

| Task ID | Linked US | Technical Description / Work Item | Category | Assigned To | Est. Hours | Status |
| :--- | :---: | :--- | :--- | :--- | :---: | :---: |
| **TSK-08** | US-AUTH-03 | Code interface layouts for `login_screen.dart` and `register_screen.dart`. | UI/UX | Sergio H. | 5 hrs | `Done` |
| **TSK-09** | US-NAV-02 | Integrate programmatic triggers for `universal_back_button.dart` inside `app_router.dart`. | Architecture | Diego S. | 4 hrs | `Done` |
| **TSK-10** | US-AUTH-03 | Build input visual wrappers `auth_scaffold.dart` and custom `custom_auth_field.dart`. | UI/UX | Sergio H. | 6 hrs | `Done` |
| **TSK-11** | US-STATE-02 | Set up baseline structural code footprints for `auth_provider.dart`, `locale_provider.dart`, and `theme_provider.dart`. | Architecture | Jeremiah V. | 7 hrs | `Done` |
| **TSK-12** | US-DASH-02 | Draft structural components, grid alignments, and styling blocks for `dashboard_screen.dart`. | UI/UX | Sergio H. | 5 hrs | `Done` |
| **TSK-13** | US-AUTH-03 | Code evaluation logic in `app_validators.dart` and define configurations inside `app_constants.dart`. | Logic | Said B. | 6 hrs | `Done` |
| **TSK-14** | US-AUTH-03 | Conduct user input boundary checks and multi-theme rendering validation runs. | QA | Ricardo H. | 7 hrs | `Done` |

---

## Active Impediments & Blocker Log

| ID | Blocker Description | Impact | Assigned Owner | Status |
| :--- | :--- | :--- | :--- | :--- |
| **IMP-02** | Structural dependencies overlap between `auth_scaffold` styles and localized layout matrices. | Minor delay in field alignment. | Sergio H. | `Resolved` |

---

## Definition of Done (DoD)
- [ ] Visual UI components render correctly without layout constraint breaks on diverse simulated screens.
- [ ] Email and password input validators reject anomalous structures based on regex rules.
- [ ] Base Riverpod providers expose active default data elements across target components without runtime errors.
