# Project Presentation: Galaxy Savings
### Modern Cross-Platform Gamified Finance Ecosystem

Welcome to the official portfolio presentation for **Galaxy Savings App Pro**. This project represents a production-grade mobile application designed to gamify, streamline, and scale personal savings management through an intelligent, user-centric ecosystem.

---

## Academic & Project Context
* **Institution:** CBTis 47
* **Course:** Computer Science / Software Development Project
* **Development Methodology:** Agile Scrum (4 Sprints)
* **Architecture Framework:** Clean Architecture + MVVM (Model-View-ViewModel)

---

## The Development Team & Core Roles
Our team operates under structured engineering workflows, separating concerns across data management, UI orchestration, and quality assurance:

| Team Member | Engineering Role | Core Repository Responsibilities |
| :--- | :--- | :--- |
| **Sergio Hernández Rosas** | Lead Frontend & UI/UX Designer | UI/UX Forms, ViewModels, Theme Systems, iOS Optimization |
| **Diego Manuel Santos Hernández** | Database Administrator (DBA) | Relational Mapping, Deletion Constraints, Key Integrity |
| **Said Bañuelos García** | SQL Developer | Table Constraints, Stored Procedures, Schema Migrations |
| **Jeremiah Venegas Rojas** | Query Master | State Architecture, Riverpod Data Pipelines, Repository Links |
| **Ricardo Hernández Vera** | Tester / Quality Assurance | Multi-OS Emulation Audits, Exception Logging, Bug Tracking |

---

## Core Architectural Philosophy
Galaxy Savings App Pro rejects messy code. The entire system is built upon **Clean Architecture** patterns decoupled from the UI layer via **MVVM** and unified by robust state management.

              ┌─────────────────────────────────────┐
              │      Presentation Layer (Views)     │
              └──────────────────┬──────────────────┘
                                 │ (Observes State)
              ┌──────────────────v──────────────────┐
              │             ViewModels              │
              └──────────────────┬──────────────────┘
                                 │ (Triggers Business Rules)
              ┌──────────────────v──────────────────┐
              │    Domain Layer (Use Cases/Models)  │
              └──────────────────┬──────────────────┘
                                 │ (Requests Data)
              ┌──────────────────v──────────────────┐
              │     Data Layer (Supabase/Repos)     │
              └─────────────────────────────────────┘

### Key Technical Patterns Implemented:
* **Decoupled Architecture:** Absolute separation between layouts (`Views`) and business states (`ViewModels`).
* **Reactive Data Binding:** Powered by **Riverpod** to propagate background ledger calculations immediately to frontend metric elements.
* **Strict Multi-Tenant Security:** Enforced at the cloud layer through Supabase **Row Level Security (RLS)**, ensuring a user can never touch or read another user's financial entities.

---

## Unified Technological Stack

### Frontend & Layout Runtime
* **Framework:** Flutter (v3.136.0)
* **Language:** Dart (v3.137.20260601)
* **State Management:** Riverpod (Fully decoupled providers)
* **Internationalization:** Multi-language ARB localization engine (Supporting 9 distinct layout copy languages).

### Cloud Backend & Storage
* **Database Engine:** PostgreSQL hosted via **Supabase**.
* **Identity Management:** Multi-method secure token handling (Credentials & Google OAuth endpoints).
* **Database Triggers:** Native PL/pgSQL stored routines for secure cascading entity removal.

### Tooling & Testing Hardware
* **Primary Workspaces:** Visual Studio Code (v1.123) & Android Studio Quail 1.
* **Localization Control:** ARB Editor (v0.2.2).
* **Virtual Testing Environment:** Android Studio Pixel 7 Emulation Framework.
* **Physical Testing Target Matrix:** Oppo A17 (Android Target Deployment) & iPhone 17 Pro (High-Fidelity Native iOS Fluid Blur/Glassmorphism Tuning).

---

## System Features & Requirements

### Functional Capabilities
* **Session & Authentication:** Supports programmatic evaluation and recovery of active user sessions upon app startup, secure traditional credential matching, third-party Google OAuth token resolution, and account destruction pipelines via custom remote RPC database wipes.
* **User Profile Management:** Processes instant reactive updates for custom names and avatar graphics across layouts without full-page database refreshes, mirrors state properties directly to cloud tables, and handles automated metadata fallback extraction upon initial account setup.
* **Social Network Linkages:** Allows real-time remote lookup operations using unique database username strings, dispatches pending friend invitations, and implements a resolution pipeline for users to cleanly accept or decline incoming links.
* **Advanced Ledger Engine:** Aggregates multi-entry transaction histories reactively to yield precision balances, utilizes strict overdraft security bounds to drop invalid withdrawal inputs, and transforms freestyle transaction timelines into clean chart coordinates.
* **Dynamic Target Formulation:** Captures explicit fixed-target requirements including numeric goal caps, scheduled deadlines, and custom frequency metrics, or provisions open-ended freestyle accounts by injecting managed null parameters to backend schemas.

### Non-Functional Architecture
* **Performance & Memory Optimization:** Enforces strict state disposal parameters to release cached data instances immediately upon view destruction and preserves smooth layout drawing performance (60fps+) under active data streaming states.
* **Security Framework:** Guarantees structural tenant isolation by locking data fetch queries to target user IDs using Row Level Security (RLS) and handles sensitive token configurations securely in cloud environments.
* **Reliability & Core Resilience:** Provides graceful user performance degradation via database metadata query fallbacks during connection loss and processes critical ledger transactions using rollback properties to block fractional data writes.
* **Maintainability & Layout Decoupling:** Enforces complete code layer insulation between interactive templates and backend logic engines, avoiding hardcoded presentation text by relying on external ARB globalization maps.

---

## Featured App Highlights

### 1. Dual-Mode Savings Workspace
Supports structural financial tracking divided into two core user workflows:
1. **Target Saving Engines:** Time-locked parameters tracking against specific target goals, automated deadlines, and rigid savings frequency alerts.
2. **Freestyle Saving Engines:** Asynchronous financial ledger logging acting as open-ended asset trackers without artificial time barriers or zero-balance constraints.

### 2. Interactive Gamified Feedback
Reaching a milestone or hitting a 100% savings threshold instantly triggers specialized background particle effects (`cosmic_celebration_stars.dart`), turning financial discipline into an engaging visual reward without risking device thread performance or leaking runtime memory.

### 3. Precision Layout Standards
The system interface scales natively to specialized framework standards, engineered around concise mobile view boundaries (**Android Compact - 412x917 px**) to maintain robust UI positioning and pixel-perfect responsiveness across target deployment screens.

---

## Key Code Highlights & Repository Map
To explore the core engineering blocks of this repository, navigate through these structured milestones:
* [`/lib/core/providers/`](../lib/core/providers/): Houses `savings_provider.dart`, the reactive central data hub.
* [`/queries/`](../queries/): Holds our relational data schemas, cascading database triggers, and performance optimizations.
* [`/docs/`](../docs/): Contains our formalized Software Requirements Specification (SRS) and Agile Sprint Backlogs.

---

> **Project Motto:** "Bridging clean software architectures with modern visual gamification to build robust multi-platform experiences."
