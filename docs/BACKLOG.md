# Product Backlog: Galaxy Savings
---

## Épica 1: Fundación Arquitectónica e Infraestructura
> **Objetivo:** Establecer el entorno de base de datos y la arquitectura del frontend.

- [x] **PB-01:** Configurar proyecto Flutter e instalar dependencias core (`riverpod`, `go_router`, `supabase`).
  * *Asignado a:* Sergio Hernández Rosas (The Analyst and Designer)
- [x] **PB-02:** Codificar `design_constants.dart` (Android Compact 412x917 px) y `app_colors.dart` (Light/Dark).
  * *Asignado a:* Sergio Hernández Rosas (The Analyst and Designer)
- [x] **PB-03:** Configurar proyecto en Supabase, establecer roles y políticas de seguridad (RLS) con `users.sql`.
  * *Asignado a:* Diego Manuel Santos Hernández (The Database Administrator)
- [x] **PB-04:** Ejecutar `schema.sql` y poblar datos iniciales con `seed.sql`.
  * *Asignado a:* Said Bañuelos García (The SQL Developer)
- [x] **PB-05:** Traducir lógica de `analysis.sql` a consultas preparadas para la futura conexión con la aplicación.
  * *Asignado a:* Jeremiah Venegas Rojas (The Query Master)
- [x] **PB-06:** Ejecutar y certificar pruebas de integridad referencial locales (`test_cases.sql`).
  * *Asignado a:* Ricardo Hernández Vera (The SQL Tester)

---

## Épica 2: Autenticación, UI Inicial y Capa de Dominio
> **Objetivo:** Permitir el registro e inicio de sesión seguro, mapeando la base de datos a objetos de Dart.

- [x] **PB-07:** Diseñar y programar `splash_screen` y las 3 `onboarding_screens` con caché en `SharedPreferences`.
  * *Asignado a:* Sergio Hernández Rosas (The Analyst and Designer)
- [x] **PB-08:** Programar las Entidades puras en Dart (`User`, `SavingsGoal`, `Transaction`) y los DTOs.
  * *Asignado a:* Said Bañuelos García (The SQL Developer)
- [x] **PB-09:** Implementar el `AuthRepository` conectando la vista de Flutter con el servicio de autenticación de Supabase.
  * *Asignado a:* Jeremiah Venegas Rojas (The Query Master)
- [x] **PB-10:** Construir UI de `login_screen` y `register_screen` aplicando MVVM.
  * *Asignado a:* Sergio Hernández Rosas (The Analyst and Designer)
- [x] **PB-11:** Pruebas de QA sobre flujos de autenticación: bloqueo de duplicados y auditoría del filtro de palabras obscenas.
  * *Asignado a:* Ricardo Hernández Vera (The SQL Tester)
- [x] **PB-12:** Monitoreo de logs de autenticación y ajustes de latencia en la conexión hacia la base de datos.
  * *Asignado a:* Diego Manuel Santos Hernández (The Database Administrator)

---

## Épica 3: Motor de Ahorros y Dashboard
> **Objetivo:** Implementar la lógica matemática de metas financieras y reflejar el progreso.

- [ ] **PB-13:** Construir la UI del `dashboard_screen` integrando el componente dinámico del cerdito.
  * *Asignado a:* Sergio Hernández Rosas (The Analyst and Designer)
- [ ] **PB-14:** Diseñar `saving_selection_screen` y los formularios de creación de metas (`create_target_saving_screen` y `create_freestyle_saving_screen`).
  * *Asignado a:* Sergio Hernández Rosas (The Analyst and Designer)
- [ ] **PB-15:** Implementar el Caso de Uso (Dart) para calcular el `periodic_amount` matemático tomando fechas y la tabla `frequencies`.
  * *Asignado a:* Jeremiah Venegas Rojas (The Query Master)
- [ ] **PB-16:** Implementar los Repositorios para inyectar transacciones a las tablas `savings_goals` y `goal_transactions` desde la app.
  * *Asignado a:* Said Bañuelos García (The SQL Developer)
- [ ] **PB-17:** Pruebas unitarias al motor de cálculo de fechas e intervalos para asegurar cuotas precisas.
  * *Asignado a:* Ricardo Hernández Vera (The SQL Tester)
- [ ] **PB-18:** Optimización de índices en PostgreSQL para acelerar la carga de la pantalla principal.
  * *Asignado a:* Diego Manuel Santos Hernández (The Database Administrator)

---

## Épica 4: Gestión de Transacciones y Pulido UX
> **Objetivo:** Cerrar el ciclo de uso permitiendo ingresos/retiros y estabilizar el sistema.

- [ ] **PB-19:** Construir `manage_target_saving_screen` y `manage_freestyle_saving_screen`.
  * *Asignado a:* Sergio Hernández Rosas (The Analyst and Designer)
- [ ] **PB-20:** Implementar la acción destructiva "Romper alcancía" y el borrado en cascada desde la interfaz.
  * *Asignado a:* Said Bañuelos García (The SQL Developer)
- [ ] **PB-21:** Integrar los reportes de `report_savings.sql` en las pantallas de detalles para mostrar el historial de transacciones.
  * *Asignado a:* Jeremiah Venegas Rojas (The Query Master)
- [ ] **PB-22:** Configurar los archivos base de internacionalización `.arb` (i18n) en `language_screen` y `login_language_screen`.
  * *Asignado a:* Jeremiah Venegas Rojas (The Query Master)
- [ ] **PB-23:** Refinar efectos Liquid Glass (iOS) y sombras Material (Android) en pantallas finales y `settings_screen`.
  * *Asignado a:* Sergio Hernández Rosas (The Analyst and Designer)
- [ ] **PB-24:** Habilitar rutinas de respaldos programados (Backups) en Supabase para proteger los datos financieros.
  * *Asignado a:* Diego Manuel Santos Hernández (The Database Administrator)
- [ ] **PB-25:** Ejecutar pruebas de regresión End-to-End (E2E): ciclo completo de registro, meta, aportaciones múltiples y cierre de sesión.
  * *Asignado a:* Ricardo Hernández Vera (The SQL Tester)
