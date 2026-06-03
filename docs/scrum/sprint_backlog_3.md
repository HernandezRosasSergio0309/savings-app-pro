# Sprint Backlog: Sprint 3 — Navigation Elements, Profile Onboarding & Social Auth

This third cycle covers the implementation of a floating Glassmorphism navigation interface, multi-path saving selectors, a comprehensive user settings profile panel, Google OAuth ecosystem integration, and post-signup user data provisioning workflows.

## Sprint Goal
> **"Deliver an interactive draggable floating toolbar, deploy core configuration toggle interfaces for user accounts, and complete the integration of Google OAuth alongside profile onboarding states."**

## Sprint Timeline & Capacity
* **Expected Duration:** 2 Weeks (April 30 – May 14, 2026)
* **Total Estimated Effort:** 42 Hours Allocated

---

## Development Team, Roles & Responsibilities (With Estimated Hours)
* **Sergio Hernández Rosas** — *Analyst & Designer* | **Estimated: 16 Hours** Responsible for implementing Glassmorphism UI visual effect modules, building responsive view structures (`saving_selection_screen`, `settings_screen`, `complete_profile_screen`), and assembling gesture architectures for floating controls.
* **Diego Manuel Santos Hernández** — *Database Administrator (DBA)* | **Estimated: 6 Hours** Responsible for managing state overlays and optimizing window paths within the global shell navigation routing rules.
* **Said Bañuelos García** — *SQL Developer* | **Estimated: 6 Hours** Responsible for database trigger validation rules during account provisioning and structuring standard database parameters for social profiles.
* **Jeremiah Venegas Rojas** — *Query Master* | **Estimated: 7 Hours** Responsible for binding OAuth token handlers, executing automated profile lookup queries, and connecting asynchronous remote database deletions.
* **Ricardo Hernández Vera** — *Tester / QA* | **Estimated: 7 Hours** Responsible for cross-platform validation of secure social workflows, performing gesture collision tests for interactive UI components, and auditing structural data wiping routines.

---

## User Stories in Scope

### US-NAV-03: Draggable Glassmorphism Floating Interface
* **As a** user navigating the dashboard ecosystem  
* **I want to** use an interactive, draggable floating utility menu  
* **So that** I can seamlessly jump between different modules without permanently sacrificing screen real estate.
* **Acceptance Criteria:**
  - [ ] The `draggable_glass_toolbar.dart` overlay renders cleanly across active navigation indexes within `app_router.dart`.
  - [ ] Component exhibits responsive drag mechanics with localized boundaries to prevent dropping items off-screen.

### US-SET-03: Centralized User Preferences & Security Portal
* **As an** account owner  
* **I want to** access a dedicated preferences control panel  
* **So that** I can change display language settings, switch themes, sign out safely, or definitively remove my profile data.
* **Acceptance Criteria:**
  - [ ] Interface controls inside `settings_screen.dart` dynamically dispatch state triggers for theme and translation engines.
  - [ ] Account purging operations execute secure asynchronous processes, wiping active remote credentials before wiping local storage caches.

### US-AUTH-04: Unified Google Social Sign-In Ecosystem
* **As a** mobile application consumer  
* **I want to** authenticate using my existing Google Identity credentials  
* **So that** I can bypass traditional registration form entries.
* **Acceptance Criteria:**
  - [ ] Authorization triggers redirect to target authentication pop-ups on mobile devices and desktop clients.
  - [ ] Successful authorization parses data strings, routing first-time sign-ups through `complete_profile_screen.dart` to gather necessary metadata.

---

## Task Board & Hourly Estimation

| Task ID | Linked US | Technical Description / Work Item | Category | Assigned To | Est. Hours | Status |
| :--- | :---: | :--- | :--- | :--- | :---: | :---: |
| **TSK-15** | US-NAV-03 | Code UI layouts, blur layers, and physics parameters for `draggable_glass_toolbar.dart`. | UI/UX | Sergio H. | 6 hrs | `Done` |
| **TSK-16** | US-SET-03 | Implement layout configurations and option lists inside `saving_selection_screen.dart` and `settings_screen.dart`. | UI/UX | Sergio H. | 5 hrs | `Done` |
| **TSK-17** | US-AUTH-04 | Design Google authentication access components and code interface frameworks for `complete_profile_screen.dart`. | UI/UX | Sergio H. | 5 hrs | `Done` |
| **TSK-18** | US-NAV-03 | Incorporate global layout views and structural path rules for overlay items inside `app_router.dart`. | Architecture | Diego S. | 6 hrs | `Done` |
| **TSK-19** | US-SET-03 / US-AUTH-04 | Bind functional code definitions for Google sign-in methods, logouts, and structural profile destructions. | Architecture | Jeremiah V. | 7 hrs | `Done` |
| **TSK-20** | US-AUTH-04 | Map database properties and metadata attributes to match custom fields inside user tables. | Database | Said B. | 6 hrs | `Done` |
| **TSK-21** | All | Execute operational testing cycles on integration features, state updates, and data deletion flows. | QA | Ricardo H. | 7 hrs | `Done` |

---

## Active Impediments & Blocker Log

| ID | Blocker Description | Impact | Assigned Owner | Status |
| :--- | :--- | :--- | :--- | :--- |
| **IMP-03** | Google sign-in configuration keys require custom SHA certificate fingerprints for native testing setups. | Temporarily blocked testing on physical devices. | Said B. / Jeremiah V. | `Resolved` |

---

## Definition of Done (DoD)
- [ ] Users can log in using Google OAuth and fill out the profile configuration forms without data loss.
- [ ] Language and visual theme toggles dynamically re-render active modules instantly.
- [ ] The floating navigation hub handles boundary checking and avoids blocking interactive field components.
