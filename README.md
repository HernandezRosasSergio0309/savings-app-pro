# Galaxy Savings App Pro

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![Supabase](https://img.shields.io/badge/Supabase-3ECF8E?style=for-the-badge&logo=supabase&logoColor=white)
![Riverpod](https://img.shields.io/badge/Riverpod-000000?style=for-the-badge&logo=dart&logoColor=white)

**Galaxy Savings** is a cross-platform mobile application focused on the intelligent, interactive, and gamified management of personal savings goals. The project follows rigorous software engineering principles, utilizing **Clean Architecture**, reactive dependency injection, and the **MVVM (Model-View-ViewModel)** design pattern.

---

## Product Goal & Overview

To provide users with an intuitive, immersive, and highly responsive tool to set financial goals, track transactions (deposits and withdrawals), visualize balance history, and maintain saving consistency through a daily streaks system and interactive animations.

---

## Project Documentation

To ensure maintainability and a clean, agile workflow within the repository, the requirements specification and development planning have been modularly divided into the following documents:

*  **[Product Backlog & SRS](PRODUCT_BACKLOG.md):** Contains the Epics, User Stories (using Gherkin syntax), and the Software Requirements Specification (Functional and Non-Functional Requirements).
*  **[Sprint Backlog](SPRINT_BACKLOG.md):** Details the iterative flow of the current sprint, individual task assignments, and the role breakdown of the development team.

---

## Tech Stack & Structure

* **Frontend:** Flutter SDK, Dart Language.
* **Backend as a Service (BaaS):** Supabase (PostgreSQL Database, Auth, Storage).
* **State Management & DI:** Riverpod (`StateNotifier`, `FutureProvider`, `ConsumerWidget`).
* **Routing:** `go_router` for declarative and secure navigation.
* **Architectural Pattern:** Clean Architecture + Feature-First Presentation + MVVM.

### Detailed Project Structure (`lib/`)

```text
lib/
├── core/                  # Global configurations and system core.
│   ├── constants/         # Validations and static lists (profanity_list).
│   ├── providers/         # Shared global providers (Auth, Theme).
│   ├── router/            # Navigation configuration and guards (go_router).
│   ├── theme/             # App Design System (AppColors, typography).
│   └── utils/             # Helper functions, formatters, and extensions.
├── data/                  # Data Layer: External connections and serialization.
│   ├── data_sources/      # Supabase client and direct API interactions.
│   ├── models/            # DTOs (Data Transfer Objects) mapping JSON to Dart.
│   └── repositories_impl/ # Concrete implementation of domain interfaces.
├── domain/                # Domain Layer: Pure business logic (framework-independent).
│   ├── entities/          # Core business entities (TargetSaving, Transaction, User).
│   ├── repositories/      # Abstract contracts and data access interfaces.
│   └── use_cases/         # System-specific use cases.
├── l10n/                  # Native Internationalization (Dynamic support for 9 languages).
├── presentation/          # Presentation Layer: Views and ViewModels (MVVM).
│   ├── auth/              # Login and account registration flow.
│   ├── common_widgets/    # Reusable visual components (FancySlidingCard, CosmicStars).
│   ├── dashboard/         # Main control panel, progress, and streaks visualization.
│   ├── language/          # View and logic for dynamic language selection.
│   ├── onboarding/        # Introductory flow and welcome tutorial.
│   ├── savings/           # Management, creation, and transactions of savings goals.
│   ├── settings/          # User profile configuration and system preferences.
│   └── splash/            # Initial loading screen and session state validation.
└── main.dart              # Application entry point and services initialization.
```

---

## Installation & Deployment

Follow these steps to clone the project and run it locally in your development environment:

**1. Clone the repository:**

```bash
git clone [https://github.com/HernandezRosasSergio0309/savings-app-pro.git](https://github.com/HernandezRosasSergio0309/savings-app-pro.git)
```

**2. Install Flutter dependencies:**

```bash
flutter pub get
```

**3. Generate localization files (i18n):**

```bash
flutter gen-l10n
```

**4. Run the application in development mode:**

```bash
flutter run
```

---

## 💡 Performance Note:

To test optimal fluidity and native frame rates from the graphics engine (Impeller/Skia) on the spatial particle animations (CosmicCelebrationStars), it is highly recommended to compile the project on a physical device using release mode: `flutter run --release`.
