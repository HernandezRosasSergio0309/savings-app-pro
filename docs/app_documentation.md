# Galaxy Savings

Galaxy Savings is a cross-platform mobile application developed in **Flutter**, designed to revolutionize personal savings management. Its primary objective is to allow users to manage their finances dynamically, intuitively, and in a highly customizable way, offering flows for both flexible (free) savings and fixed-term goals.

## Key Features

The application engine is divided into two core modalities:

* **Target Savings:** The user defines a goal, an amount, a deadline, and a frequency. The application mathematically calculates the necessary periodic contributions and keeps a record of streaks (compliance).
* **Freestyle Savings:** A digital piggy bank without time pressures or fixed amounts, ideal for accumulating funds casually with detailed growth statistics.

## Tech Stack and Architecture

| Component | Technology |
| :--- | :--- |
| **Frontend** | Flutter & Dart |
| **Backend** | Supabase (Authentication & PostgreSQL) |
| **State Management** | Riverpod |
| **Routing** | GoRouter |
| **Architecture** | MVVM (Model-View-ViewModel) + Clean Architecture |

### UI/UX Design (Adaptive)
* **Android:** Strict implementation of Material Design.
* **iOS:** Implementation of Cupertino Glassmorphism (Liquid Glass) with advanced transparency and blur effects (Coming soon).

---

## App Structure

The project consists of **15 main views**, logically organized and connected via a Bottom Toolbar.

### 1. Authentication and Onboarding
* **Splash Screen:** Initial loading screen (3 seconds) with Galaxy Savings branding.
* **Onboarding Screens (3):** Introductory carousel explaining the value of the application.
* **Login Screen:** Access via email and password.
* **Register Screen:** Account creation with strict validations (length, duplicates, and inappropriate language filter).

### 2. Main Dashboard
* **Dashboard Screen:** The core of the app. Displays an overview of accounts. Each savings card includes:
    * Name and current balance vs. goal.
    * Percentage progress bar.
    * **Icono dinámico:** A piggy bank that evolves according to the percentage reached.
    * Edit mode for account management.

### 3. Savings Engine
* **Saving Selection Screen:** Branching to choose between "Target Savings" or "Freestyle Savings".
* **Create Target Saving:** Form with automatic installment calculation based on goal and time.
* **Create Freestyle Saving:** Simplified form for quick piggy banks.
* **Manage Target Saving:** Control panel with progress, streak history (✅/❌), remaining amount, and transaction log.
* **Manage Freestyle Saving:** Panel with accumulated balance, statistics (historical highs), history, and a "Break the piggy bank" option.

### 4. Settings and Profile
* **Settings Screen:** Avatar management, language preferences, theme, and security.
* **Edit Profile Screen:** Profile updates and password changes.
* **Language Screen:** **i18n** support with available languages: English, Spanish, French, Italian, Portuguese, German, Japanese, Chinese, and Korean.
