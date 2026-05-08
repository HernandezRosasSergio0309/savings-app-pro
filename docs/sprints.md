## Planificación de Sprints y Roadmap

### Sprint 1: Fundación Arquitectónica e Infraestructura de Base de Datos
* **Fechas:** Lunes 20 de abril de 2026 – Viernes 24 de abril de 2026
* **Objetivo:** Establecer el entorno de base de datos en Supabase y preparar la estructura base del proyecto en Flutter con los lineamientos de diseño.

**Asignaciones:**
* **Diego Manuel Santos Hernández** *(The Database Administrator)*:
  * Configurar el proyecto en Supabase (entorno de desarrollo).
  * Ejecutar `users.sql` para establecer permisos de roles de la aplicación y políticas de seguridad (RLS).
* **Said Bañuelos García** *(The SQL Developer)*:
  * Ejecutar `schema.sql` y `seed.sql` para crear las tablas (`users`, `frequencies`, `savings_goals`, `goal_transactions`) y poblar datos iniciales.
* **Sergio Hernández Rosas** *(The Analyst and Designer)*:
  * Configurar el proyecto en Flutter instalando dependencias core.
  * Codificar la capa `core/constants/` con las medidas de Figma (Android Compact / iPhone 17 Pro) y la paleta de colores.
* **Jeremiah Venegas Rojas** *(The Query Master)*:
  * Traducir la lógica de `analysis.sql` a consultas REST/RPC preparadas para la futura conexión con la aplicación.
* **Ricardo Hernández Vera** *(The SQL Tester)*:
  * Ejecutar `test_cases.sql` directamente en consola para certificar integridad referencial antes de conectar el frontend.

---

### Sprint 2: Autenticación, UI Inicial y Capa de Dominio
* **Fechas:** Lunes 27 de abril de 2026 – Viernes 1 de mayo de 2026
* **Objetivo:** Permitir el registro e inicio de sesión seguro, mapeando la base de datos a objetos de Dart (Entidades).

**Asignaciones:**
* **Sergio Hernández Rosas** *(The Analyst and Designer)*:
  * Diseñar y programar `splash_screen` y las 3 `onboarding_screens`.
  * Construir UI de `login_screen` y `register_screen`.
* **Said Bañuelos García** *(The SQL Developer)*:
  * Programar las Entidades en Dart (`User`, `SavingsGoal`, `Transaction`) y los DTOs para parsear el JSON de Supabase.
* **Jeremiah Venegas Rojas** *(The Query Master)*:
  * Implementar el `AuthRepository` conectando la vista de Flutter con el servicio de autenticación de Supabase.
* **Ricardo Hernández Vera** *(The SQL Tester)*:
  * Pruebas de QA sobre los flujos de autenticación: verificar la restricción de correos duplicados y auditar el filtro de palabras obscenas.
* **Diego Manuel Santos Hernández** *(The Database Administrator)*:
  * Monitoreo de logs de autenticación y ajustes de latencia en la conexión hacia la base de datos.