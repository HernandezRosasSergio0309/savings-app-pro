# Sprint Backlog: Sprint 4 — Core Savings Engines, Cosmic Celebrations & iOS Optimization

This fourth and final sprint focuses on deploying the operational core of the savings modules (Target and Freestyle options), connecting the data pipeline to reactive dashboard metric cards, implementing profile editing capabilities, and introducing a rewarding visual feedback framework. It concludes with an emphasis on code stabilization, bug fixing, and native iOS layout optimization.

## Sprint Goal
> **"Complete the end-to-end savings management lifecycle, integrate reactive dashboard metrics with a cosmic celebration trigger, and finalize platform optimization for iOS while resolving outstanding software bugs."**

## Sprint Timeline & Capacity
* **Expected Duration:** 4 Weeks (May 15 – June 12, 2026)
* **Total Estimated Effort:** 50 Hours Allocated

---

## Development Team, Roles & Responsibilities (With Estimated Hours)
* **Sergio Hernández Rosas** — *Analyst & Designer* | **Estimated: 20 Hours** Responsible for coding creation and management screens (`create_target_saving_screen`, `create_freestyle_saving_screen`, `manage_target_saving_screen`, `manage_freestyle_saving_screen`), structuring their ViewModels, designing profile modification interfaces, integrating the cosmic animation asset, and leading the specialized iOS visual optimization.
* **Diego Manuel Santos Hernández** — *Database Administrator (DBA)* | **Estimated: 6 Hours** Responsible for reviewing record deletion paths, optimizing database indexing execution for dashboard card rendering, and safeguarding relational keys.
* **Said Bañuelos García** — *SQL Developer* | **专 Estimated: 6 Hours** Responsible for managing table constraint modifications for fixed-target amount parameters vs freestyle null-state fields inside Supabase.
* **Jeremiah Venegas Rojas** — *Query Master* | **Estimated: 8 Hours** Responsible for writing reactive state calculations inside `savings_provider.dart` and setting up clean background repository links for goal administration.
* **Ricardo Hernández Vera** — *Tester / QA* | **Estimated: 10 Hours** Responsible for supervising cross-platform interface checks on iOS simulators, filing validation logs, executing stress testing for boundary bugs, and verifying code stabilization fixes.

---

## User Stories in Scope

### US-SAVE-05: Dual-Mode Saving Workspace & Lifecycle
* **As a** diligent saver  
* **I want to** build fixed-target goals or freestyle ledger entries and monitor them within dedicated administrative dashboards  
* **So that** I can track my exact progression, deposit or withdraw assets, or close out goals cleanly.
* **Acceptance Criteria:**
  - [ ] Creation views (`create_target_saving_screen.dart`, `create_freestyle_saving_screen.dart`) correctly enforce input paradigms.
  - [ ] Management viewmodels (`manage_target_saving_view_model.dart`, `manage_freestyle_saving_view_model.dart`) calculate historical ledger inputs perfectly.

### US-DASH-04: Integrated Dashboard Asset Matrix
* **As an** authenticated app user  
* **I want to** see my active savings accounts mapped into real-time interactive asset cards on my home screen  
* **So that** I can click to edit or completely remove them instantly.
* **Acceptance Criteria:**
  - [ ] `dashboard_screen.dart` utilizes data mappings provided by `savings_provider.dart` to draw dynamic elements.
  - [ ] Delete/Edit triggers instantly delete backend records and drop elements from the view context seamlessly.

### US-PROF-03: Advanced Profiles & Gamified Visual Rewards
* **As an** active saver achieving a milestone  
* **I want to** update my personal information effortlessly and enjoy an engaging visual reward when a saving goal hits 100% completion  
* **So that** my app profile stays updated and my financial discipline is reinforced.
* **Acceptance Criteria:**
  - [ ] Navigation button inside `settings_screen.dart` routes correctly to `edit_profile_screen.dart` with working edit inputs.
  - [ ] Reaching 100% of a saving target safely triggers the `cosmic_celebration_stars.dart` overlay effect without memory leaks.

### US-OPT-02: iOS Optimization & Stabilization
* **As a** multi-platform smartphone user  
* **I want to** experience polished user interfaces on iOS that align with native layouts and run completely free of bugs  
* **So that** the financial application runs reliably under any operating system environment.
* **Acceptance Criteria:**
  - [ ] Visual properties (Glassmorphism blurs and sheet behaviors) are optimized for iOS systems.
  - [ ] Layout formatting and boundary defects identified in QA testing are completely resolved.

---

## Task Board & Hourly Estimation

| Task ID | Linked US | Technical Description / Work Item | Category | Assigned To | Est. Hours | Status |
| :--- | :---: | :--- | :--- | :--- | :---: | :---: |
| **TSK-22** | US-SAVE-05 | Build UI forms for `create_target_saving_screen.dart` and `create_freestyle_saving_screen.dart`. | UI/UX | Sergio H. | 4 hrs | `Done` |
| **TSK-23** | US-DASH-04 | Program query consolidation maps inside `savings_provider.dart`. | Architecture | Jeremiah V. | 4 hrs | `Done` |
| **TSK-24** | US-SAVE-05 | Code interactive workspace frames for `manage_target_saving_screen.dart` and freestyle counterparts. | UI/UX | Sergio H. | 4 hrs | `Done` |
| **TSK-25** | US-SAVE-05 | Implement mathematical business logic maps in management ViewModels. | Logic | Sergio H. | 4 hrs | `Done` |
| **TSK-26** | US-DASH-04 | Bind interactive dashboard elements to collection arrays and integrate deletion routes. | UI/UX | Sergio H. | 3 hrs | `Done` |
| **TSK-27** | US-PROF-03 | Code profile editing workflows for `edit_profile_screen.dart` and link custom parameters to settings. | UI/UX | Sergio H. | 3 hrs | `Done` |
| **TSK-28** | US-PROF-03 | Build custom Canvas or Particle animation frames inside `cosmic_celebration_stars.dart`. | Animation | Sergio H. | 2 hrs | `Done` |
| **TSK-29** | US-DASH-04 | Set up database deletions and transaction rules inside database storage configurations. | Database | Diego S. / Said B. | 4 hrs | `Done` |
| **TSK-30** | US-OPT-02 | Resolve layout constraints, fix runtime exceptions, and clean up testing discrepancies. | Stabilization | Ricardo H. / All | 12 hrs | `In Progress` |
| **TSK-31** | US-OPT-02 | Optimize styling properties, layout padding adjustments, and theme profiles for native iOS. | Optimization | Sergio H. | 10 hrs | `Todo` |

---

## Active Impediments & Blocker Log

| ID | Blocker Description | Impact | Assigned Owner | Status |
| :--- | :--- | :--- | :--- | :--- |
| **IMP-04** | Font variations and blur clipping issues detected on native iOS simulator runtimes. | Minor UI distortion on Apple systems. | Sergio H. / Ricardo H. | `Active` |

---

## Definition of Done (DoD)
- [ ] Users can create, modify, record transactions, and delete savings records with zero local cache or data syncing anomalies.
- [ ] Hitting 100% on a goal triggers the particle animation cleanly without crashing runtime states.
- [ ] Layout profiles display correctly on iOS devices, meeting standard performance criteria without UI glitches.
- [ ] The testing tracker confirms all critical code bugs have been addressed and closed out.
