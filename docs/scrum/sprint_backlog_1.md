# Sprint Backlog: Sprint 1 — Project Initialization & Onboarding Experience

Este ciclo inicial comprende la puesta a punto del entorno de desarrollo global, la configuración de la arquitectura base del proyecto, el sistema de internacionalización (l10n) y el flujo de introducción visual para nuevos usuarios.

## Sprint Goal
> **"Establish a multi-language boilerplate configuration for Flutter and deliver a polished first-time user experience via responsive splash and onboarding screens."**

## Sprint Timeline & Capacity
* **Expected Duration:** 2 Weeks (April 1 – April 14, 2026)
* **Total Estimated Effort:** 35 Hours Allocated

---

## Development Team, Roles & Responsibilities (With Estimated Hours)
* **Sergio Hernández Rosas** — *Analyst & Designer* | **Estimated: 15 Hours** Responsible for project scaffolding, creating global style templates (`app_colors`, `app_theme`), and designing/coding the UI layouts for the splash and onboarding sequence.
* **Diego Manuel Santos Hernández** — *Database Administrator (DBA)* | **Estimated: 5 Hours** Responsible for team IDE alignment, Android Studio SDK synchronization, and resolving local device emulator configuration blockers.
* **Said Bañuelos García** — *SQL Developer* | **Estimated: 6 Hours** Responsible for setting up the local file architecture and mapping the translation dictionaries across the 9 multi-language `.arb` resource files.
* **Jeremiah Venegas Rojas** — *Query Master* | **Estimated: 3 Hours** Responsible for managing initialization blocks, third-party plugin declarations, and clean dependency roots within `main.dart`.
* **Ricardo Hernández Vera** — *Tester / QA* | **Estimated: 6 Hours** Responsible for running responsiveness stress tests on multiple screen sizes and validating proper translation loads for all language locales.

---

## User Stories in Scope

### US-INIT-01: Global App Localization (l10n)
* **As a** international user  
* **I want to** have the application automatically display text in my native language  
* **So that** I can navigate and understand the application features without language barriers.
* **Acceptance Criteria:**
  - [ ] The application detects system language settings and adapts automatically.
  - [ ] Localization covers 9 baseline languages: Spanish, English, German, French, Italian, Portuguese, Japanese, Korean, and Chinese.
  - [ ] Zero hardcoded text strings are permitted in subsequent UI development; all references must map to `.arb` files.

### US-ONB-01: First-Time User Welcoming Flow
* **As a** new app user  
* **I want to** view a brief, elegant introductory walkthrough when opening the app for the first time  
* **So that** I can grasp the app's core financial tracking value proposition.
* **Acceptance Criteria:**
  - [ ] The `splash_screen.dart` displays smooth brand asset presentation before routing.
  - [ ] Users can smoothly swipe through 3 distinct onboarding screens explaining the system.
  - [ ] Layout transitions operate seamlessly without frame drops or visual alignment breaks.

---

## Task Board & Hourly Estimation

| Task ID | Linked US | Technical Description / Work Item | Category | Assigned To | Est. Hours | Status |
| :--- | :---: | :--- | :--- | :--- | :---: | :---: |
| **TSK-01** | *None* | Install Flutter SDK, Android Studio, and development extensions across team systems. | Environment | All Team | 5 hrs | `Done` |
| **TSK-02** | *None* | Build core folder architecture setup (views, viewmodels, providers, themes). | Architecture | Sergio H. | 3 hrs | `Done` |
| **TSK-03** | US-ONB-01 | Define global palette parameters inside `app_colors.dart` and `app_theme.dart`. | UI/UX | Sergio H. | 4 hrs | `Done` |
| **TSK-04** | US-INIT-01 | Configure `l10n` parameters in `pubspec.yaml` and compile 9 localized `.arb` matrices. | Localization | Said B. | 6 hrs | `Done` |
| **TSK-05** | US-INIT-01 | Set up base runner initialization blocks and clean dependency roots in `main.dart`. | Architecture | Jeremiah V. | 3 hrs | `Done` |
| **TSK-06** | US-ONB-01 | Develop UI layouts for `splash_screen.dart` and the 3 onboarding views. | UI/UX | Sergio H. | 8 hrs | `Done` |
| **TSK-07** | US-INIT-01 | Test dictionary loads and run integration checks on UI rendering. | QA | Ricardo H. | 6 hrs | `Done` |

---

## Active Impediments & Blocker Log

| ID | Blocker Description | Impact | Assigned Owner | Status |
| :--- | :--- | :--- | :--- | :--- |
| **IMP-01** | Initial configuration delays with Android Studio emulator drivers on local systems. | Minor timeline lag. | Diego S. | `Resolved` |

---

## Definition of Done (DoD)
- [ ] Application compiles successfully on target simulators with zero critical warnings.
- [ ] Language switching between all 9 language codes loads corresponding text matrices seamlessly.
- [ ] The onboarding sliding sequence operates with fully responsive properties across multi-resolution tests.
