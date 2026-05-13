# Galaxy Savings

![Flutter](https://img.shields.io/badge/Flutter-3.x-blue?logo=flutter)
![Supabase](https://img.shields.io/badge/Supabase-Backend-47C28B?logo=supabase)
![Riverpod](https://img.shields.io/badge/State_Management-Riverpod-00A8E1)
![Architecture](https://img.shields.io/badge/Architecture-MVVM_%2B_Clean-orange)
![License](https://img.shields.io/badge/license-MIT-green)

> [!NOTE]
> **Bilingual Repository:** Scroll down for the Spanish version. / Desplázate hacia abajo para la versión en español.

---

## [English Version]

A comprehensive multi-platform mobile application built with Flutter that empowers users to seamlessly manage their finances through target-based goals and free-form saving accounts. 

### Table of Contents
* [Getting Started](#-getting-started)
* [Architecture & Tech Stack](#-architecture--tech-stack)
* [Design System](#-design-system)
* [Project Structure](#-project-structure)
* [Team & Authors](#-team--authors)

---

### Getting Started

Follow these instructions to set up a local copy of the project for development.

**Prerequisites:**

* [Flutter SDK](https://docs.flutter.dev/get-started/install)
* Git
* A Supabase project instance

**Installation:**

1. Clone the repository:
```bash
git clone [https://github.com/HernandezRosasSergio0309/savings-app-pro.git](https://github.com/HernandezRosasSergio0309/savings-app-pro.git)
```
2. Navigate to the project directory:
```bash
cd savings-app-pro
```
3. Install software dependencies:
```bash
flutter pub get
```
4. Set up the Database (Supabase):
```bash
Execute the SQL scripts located in the src/ folder in the following order inside your Supabase SQL Editor:
src/01_schema.sql - Core database structure.
src/02_seed.sql - Seed data for testing.
src/03_users.sql - Security policies (RLS) and triggers.
```
**Architecture & Tech Stack**

This project strictly follows the Clean Architecture principles combined with the MVVM (Model-View-ViewModel) design pattern to ensure maximum decoupling, scalability, and testability.
* Frontend: Flutter (Dart)
* Backend & Database: Supabase (PostgreSQL, Auth)
* State Management: Riverpod
* Routing: GoRouter
* Naming Convention: snake_case for files/folders, CamelCase for classes, and camelCase for variables.
* Internationalization (i18n): Native support configured via .arb files.

**Design System**

The application is highly adaptive, strictly adhering to platform-specific guidelines:
* Android (Material Design): Base reference frames built on "Android Compact" (412x917 px). Utilizes standard Material elevation (Y: 4, Blur: 8, 10% opacity) and 12px border radius.
* iOS (Cupertino Glassmorphism): Base reference frames built on "iPhone 17 Pro" (402x874px). Implements "Liquid Glass" effects utilizing precise refraction, depth (50%), and frost (3%) properties over a dark slate base (#94A3B8) with 20% opacity.

**Project Structure**
```bash
savings-app-pro/
├── docs/                 # ERD Diagram, Backlog, Normalization, User Stories
├── lib/                  # Flutter Application Source Code
│   ├── core/             # Routing, Constants, Localization, Themes
│   ├── data/             # Models (DTOs), Repositories, Data Sources
│   ├── domain/           # Pure Entities, Repository Interfaces, Use Cases
│   └── presentation/     # Screens, Widgets, ViewModels (MVVM)
├── queries/              # Business intelligence SQL scripts
├── src/                  # Core database DDL and DML scripts
└── tests/                # QA bug reports and test cases
```
**Team & Authors**

| Role | Name | Responsibilities |
| :--- | :--- | :--- |
| The Analyst & Designer (Architect) | Hernández Rosas Sergio | Visual model, Normalization (3NF), Flutter core setup & UI/UX. |
| The SQL Developer (Builder) | Bañuelos García Said | DDL code, accurate data types, Dart Entities & DTOs. |
| The Database Administrator (Guardian) | Santos Hernández Diego Manuel | Security, RLS, backups, and user permissions. |
| The Query Master (Manipulator) | Venegas Rojas Jeremiah Domingo | Seed data, BI reports, AuthRepository implementation. |
| The SQL Tester (QA / Breaker) | Hernández Vera Ricardo | Referential integrity validation, E2E testing, Bug reporting. |
```

---

## [Versión en Español]

Aplicación móvil multiplataforma desarrollada en Flutter, diseñada para revolucionar la gestión de ahorros personales permitiendo administrar finanzas mediante metas a plazo fijo y cuentas de ahorro libre.

### Inicio Rápido

Sigue estas instrucciones para configurar una copia local del proyecto.

### Tabla de Contenido
* [Getting Started](#-getting-started)
* [Architecture & Tech Stack](#-architecture--tech-stack)
* [Design System](#-design-system)
* [Project Structure](#-project-structure)
* [Team & Authors](#-team--authors)


**Prerrequisitos:**

* Flutter SDK
* Git
* Un proyecto configurado en Supabase

**Instalación:**

1. Clona el repositorio:
```bash
git clone https://github.com/HernandezRosasSergio0309/savings-app-pro.git
```
2. Entra al directorio:
```bash
cd savings-app-pro
```
3. Instala las dependencias:
```bash
flutter pub get
```
4. Configura la base de datos ejecutando los scripts de la carpeta src/ en el SQL Editor de Supabase:
5. ```bash
src/01_schema.sql - Core database structure.
src/02_seed.sql - Seed data for testing.
src/03_users.sql - Security policies (RLS) and triggers.
```
**Arquitectura y Stack**

El proyecto implementa Clean Architecture y el patrón MVVM para separar la lógica de negocio de la interfaz.

* Frontend: Flutter & Dart
* Backend: Supabase (PostgreSQL)
* Gestor de Estado: Riverpod
* Nomenclatura: snake_case para archivos y documentación bilingüe.

**Sistema de Diseño**

* Android: Material Design basado en el frame "Android compacto" (412x917 px).
* iOS: Cupertino Glassmorphism (Liquid Glass) adaptado para "iPhone 17 Pro".

**Estructura del proyecto**
```bash
savings-app-pro/
├── docs/                 # ERD Diagram, Backlog, Normalization, User Stories
├── lib/                  # Flutter Application Source Code
│   ├── core/             # Routing, Constants, Localization, Themes
│   ├── data/             # Models (DTOs), Repositories, Data Sources
│   ├── domain/           # Pure Entities, Repository Interfaces, Use Cases
│   └── presentation/     # Screens, Widgets, ViewModels (MVVM)
├── queries/              # Business intelligence SQL scripts
├── src/                  # Core database DDL and DML scripts
└── tests/                # QA bug reports and test cases
```
**Equipo y autores**

| Rol | Nombre | Responsabilidades |
| :--- | :--- | :--- |
| The Analyst & Designer (Architect) | Hernández Rosas Sergio | Visual model, Normalization (3NF), Flutter core setup & UI/UX. |
| The SQL Developer (Builder) | Bañuelos García Said | DDL code, accurate data types, Dart Entities & DTOs. |
| The Database Administrator (Guardian) | Santos Hernández Diego Manuel | Security, RLS, backups, and user permissions. |
| The Query Master (Manipulator) | Venegas Rojas Jeremiah Domingo | Seed data, BI reports, AuthRepository implementation. |
| The SQL Tester (QA / Breaker) | Hernández Vera Ricardo | Referential integrity validation, E2E testing, Bug reporting. |
```
