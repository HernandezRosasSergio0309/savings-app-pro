# Software Requirements Specification (SRS)
## Project: Galaxy Savings

**Project Team:** Sergio Hernández Rosas, Diego Manuel Santos Hernández, Said Bañuelos García, Jeremiah Venegas Rojas, Ricardo Hernández Vera.  
**Institution:** CBTis 47.  
**Architecture Framework:** MVVM & Clean Architecture (Flutter + Riverpod + Supabase).

---

## 1. Introduction

### 1.1 Purpose
This Software Requirements Specification (SRS) establishes the complete functional, non-functional, and interface requirements for the **Galaxy Savings App Pro** mobile ecosystem. This document serves as the single source of truth for the development team, QA testers, and academic evaluators to ensure alignment during the system construction lifecycle.

### 1.2 Scope
Galaxy Savings is a cross-platform mobile application designed to gamify and simplify personal savings management. Developed using the Flutter framework and Dart programming language, and powered by a cloud-hosted Supabase backend, the application provides interactive financial tracking mechanics. Key capabilities include dual-mode savings workflows (Target and Freestyle goals), active ledger transaction matrices, secure multi-method identity provisioning, interactive analytics visualization, localized language support, and interactive gamified visual elements.

### 1.3 Definitions, Acronyms, and Abbreviations
* **SRS:** Software Requirements Specification.
* **MVVM:** Model-View-ViewModel architectural design pattern.
* **l10n:** Localization (specifically, multi-language internationalization strings).
* **ARB:** Application Resource Bundle (JSON-based localization format used by Flutter).
* **OAuth:** Open Authorization standard for token-based social access management.
* **RLS:** Row Level Security (database security engine mapping records to specific user sessions).
* **RPC:** Remote Procedure Call (stored database routines executed remotely via API).
* **UI/UX:** User Interface / User Experience.

### 1.4 References
* Flutter SDK & Localization Engineering Guides.
* Supabase Auth & Relational Database Management Engine Documentation.
* Riverpod State Architecture Patterns Specification.
* CBTis 47 Engineering Delivery Guidelines and Milestone Documentation.

### 1.5 Overview
This document is divided into six logical sections. Section 2 establishes the overall description, including the product perspective, assumptions, and system limitations. Section 3 outlines specific Functional and Non-Functional Requirements. Section 4 details the interface requirements (UI and Database). Section 5 records absolute Business Rules, and Section 6 presents the operational conclusion.

---

## 2. Overall Description

### 2.1 Product Perspective
The Galaxy Savings operates as an independent, data-driven mobile product interacting with a secure remote Relational Database Service (RDBMS) provided by Supabase. It targets cross-platform consistency across Android and iOS systems from a single unified codebase.


```
+--------------------------------------------------------+
|          Galaxy Savings (Flutter UI)           |
|     [Material Design 3 + Glassmorphism Core Views]     |
+--------------------------------------------------------+
|
v
+--------------------------------------------------------+
|       Reactive State Management Layer (Riverpod)       |
+--------------------------------------------------------+
|
v
+--------------------------------------------------------+
|        Supabase Client SDK (Data Stream Broker)        |
+--------------------------------------------------------+
|
v
+--------------------------------------------------------+
|  Cloud Backend [Auth Engine / PostgreSQL Database]    |
+--------------------------------------------------------+
```

### 2.2 Assumptions and Dependencies
* **Connectivity Availability:** The application assumes continuous or intermittent internet connections to sync transactional entities to the cloud database.
* **Ecosystem Availability:** It depends on the operational uptime of Supabase authentication containers and Google OAuth endpoints.
* **Development Foundation:** Code architectures assume the stability of specific package dependencies declared within the project configuration files.

### 2.3 Constraints
* **Language and Framework:** System production is constrained strictly to the Dart language and Flutter framework.
* **Academic Milestones:** Feature implementation schedules are bound tightly to standard project sprint deadlines.
* **Target OS Limitations:** UI features must scale responsively down to iOS 15+ and Android 9+ target versions.

---

## 3. System Features and Requirements

### 3.1 Functional Requirements

#### 3.1.1 Authentication
* **FR-AUTH-01 (Session Persistence):** The system must independently evaluate and recover active user tokens upon app startup to bypass entry screens via programmatic checks.
* **FR-AUTH-02 (Multi-Method Sign-In):** The system must accept traditional credentials (email/password validation) and third-party Google OAuth integration.
* **FR-AUTH-03 (Account Destruction):** The application must provide a destructive workflow executing remote RPC database triggers to cleanly wipe active cloud data structures and sign out the user.

#### 3.1.2 User Profile Management
* **FR-PROF-01 (Reactive State Updates):** Profile name adjustments and avatar selections must immediately update internal states across active user views without requiring database refreshes.
* **FR-PROF-02 (Database Profile Mirroring):** Profile updates must synchronize immediately with dedicated user profile schemas in the remote database.
* **FR-PROF-03 (Metadata Fallback):** If a user does not have a dedicated profile row yet, the system must use metadata attributes generated during the sign-up phase.

#### 3.1.3 Saving Management
* **FR-MGMT-01 (Dynamic Ledger Calculations):** Balance metrics must be calculated reactively by aggregating ledger transactions, adding deposits and subtracting withdrawals.
* **FR-MGMT-02 (Overdraft Security Guard):** The viewmodel must block withdrawal transactions that exceed the current calculated balance, throwing semantic errors to the user.
* **FR-MGMT-03 (Analytical Coordinates):** Freestyle modules must process transaction timelines into linear chart coordinate nodes, grouping same-day movements into singular historical data marks.

#### 3.1.4 Saving Creation
* **FR-CREA-01 (Target Savings Form):** The system must capture fixed-target structures, including numeric target amounts, target dates, and explicit saving frequencies.
* **FR-CREA-02 (Freestyle Savings Flow):** The system must allow users to create freestyle goals by passing null target amount conditions to the database schema.

---

### 3.2 Non-Functional Requirements

#### 3.2.1 Performance Requirements
* **NFR-PERF-01 (Memory Lifecycle Optimization):** All data-fetching streams must use automated disposal mechanisms to clear provider caches from device memory when exiting views.
* **NFR-PERF-02 (UI Frame Performance):** Interface views must maintain smooth rendering speeds (60fps+) during layout adjustments and data loading states.

#### 3.2.2 Security Requirements
* **NFR-SECU-01 (Tenant Isolation):** Every database query must use Row Level Security (RLS) constraints to isolate data access boundaries to the active user's ID.
* **NFR-SECU-02 (Cryptographic Storage):** Sensitive credential objects must be stored and processed using encrypted authentication tokens on the remote server.

#### 3.2.3 Reliability Requirements
* **NFR-RELI-01 (Fault-Tolerant Queries):** If a query failure occurs or connection is dropped during backend profile inquiries, the engine must fall back to metadata profiles safely.
* **NFR-RELI-02 (State Rollbacks):** Transaction operations must execute as single database transactions, rolling back completely if a failure occurs mid-process to prevent data corruption.

#### 3.2.4 Maintainability Requirements
* **NFR-MAIN-01 (Architectural Decoupling):** Code structures must strictly separate structural layout configurations (Views) from transactional state operations (ViewModels).
* **NFR-MAIN-02 (Multi-Language Maintainability):** Hardcoded UI strings are prohibited; the app must draw copy tokens from centralized ARB files supporting 9 active languages.

---

## 4. Interface Requirements

### 4.1 User Interface Requirements
* **UI-REQD-01 (Responsive Grids):** Dashboards must present responsive layouts that gracefully scale structural component grids across a variety of screen resolutions.
* **UI-REQD-02 (Design Consistency):** System views must support both Light and Dark modes, combining premium Material Design tokens with customized Glassmorphism liquid blur accents.
* **UI-REQD-03 (Gamified Feedback Canvas):** Reaching target milestones (100% completion) must trigger a performant star particle canvas celebration overlay.

### 4.2 Database Interface Requirements
* **DB-INTF-01 (Relational Integrations):** The client data layer must interact with relational PostgreSQL structures via secure clients executing remote filter joins on foreign user tracking keys.
* **DB-INTF-02 (Procedural Triggers):** User deletion events must route through encrypted client calls to invoke underlying PL/pgSQL stored backend deletion triggers.

---

## 5. Business Rules

> **BR-01: Zero Overdraft Enforcement**  
> A withdrawal record cannot be created if its transaction amount is greater than the current balance of that specific saving goal.

> **BR-02: Target Distinction**  
> Any goal entity containing a null value for its target amount field is classified as a Freestyle account, bypassing deadline constraints.

> **BR-03: Strict Multi-Tenant Boundary**  
> A user session is completely blocked from reading, modifying, or querying transactional indices belonging to a different owner ID.

---

## 6. Conclusion
This SRS outlines the core technical and operational requirements for the **Galaxy Savings** mobile platform. By adhering to these functional definitions, non-functional performance benchmarks, and strict structural business rules, the engineering team ensures the delivery of a stable, secure, and cross-platform financial tracking system. This blueprint guides all development phases toward a successful, unified deployment.