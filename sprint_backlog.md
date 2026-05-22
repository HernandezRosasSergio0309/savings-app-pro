# Sprint Backlog

Este documento refleja el trabajo iterativo, la asignación de roles y el seguimiento de las tareas activas para el ciclo de desarrollo actual de **Galaxy Savings App Pro**. Se utiliza para mantener la transparencia y el ritmo constante del equipo de desarrollo.

---

## Equipo de Desarrollo y Roles

El escuadrón técnico detrás de la construcción de la base de datos, la lógica de negocio y la interfaz del sistema está compuesto por:

* **Sergio Hernández Rosas** — Analista y Diseñador (UI/UX, MVVM Architecture & Flutter Frontend).
* **Diego Manuel Santos Hernández** — Database Administrator (DBA & Supabase Infrastructure).
* **Said Bañuelos García** — SQL Developer (Tablas, Relaciones y Row Level Security).
* **Jeremiah Venegas Rojas** — Query Master (Consultas transaccionales e integridad de datos).
* **Ricardo Hernández Vera** — Tester / QA (Pruebas de estrés y validación de casos de uso).

---

## Tablero de Tareas (Sprint Actual)

A continuación se detalla el desglose de tareas técnicas derivadas de las Historias de Usuario aceptadas para el presente ciclo.

| ID | Tarea / Descripción Técnica | Asignado a | Estado |
| :--- | :--- | :--- | :--- |
| **TSK-01** | **[DB]** Esquematización de las tablas `savings_goals` y `goal_transactions` en PostgreSQL (Supabase). | Diego Manuel | Completado ✅ |
| **TSK-02** | **[UI/UX]** Implementación de la vista MVVM para la pantalla principal (Dashboard) utilizando Riverpod (`savingsProvider`). | Sergio Hernández | Completado ✅ |
| **TSK-03** | **[SQL]** Creación de políticas de seguridad (RLS) para asegurar que cada usuario solo lea sus propias metas. | Said Bañuelos | Completado ✅ |
| **TSK-04** | **[Logic]** Desarrollo del motor lógico para la reconstrucción del balance histórico a partir de depósitos y retiros. | Jeremiah Venegas | En Progreso 🔄 |
| **TSK-05** | **[Logic]** Implementación del cálculo de rachas (Streaks) en bloques de 24 horas dentro del `ManageTargetViewModel`. | Sergio Hernández | En Progreso 🔄 |
| **TSK-06** | **[QA]** Ejecución de pruebas de intercepción: Validar que el sistema bloquee retiros con fondos insuficientes. | Ricardo Hernández | Pendiente ⏳ |
| **TSK-07** | **[UI/UX]** Integración de animaciones inmersivas (`CosmicCelebrationStars`) al alcanzar el 100% de la meta. | Sergio Hernández | Pendiente ⏳ |

---

## Definición de Hecho (Definition of Done - DoD)

Para que una tarea del tablero anterior se marque como **Completada ✅**, debe cumplir estrictamente con los siguientes criterios:

1. El código compila sin advertencias (warnings) ni errores en el analizador de Dart.
2. La lógica de negocio está completamente aislada en su respectivo `ViewModel` o `Provider`.
3. No existen cadenas de texto estáticas (hardcoded); todo texto de UI debe utilizar los archivos de localización `.arb`.
4. El Tester/QA ha validado los escenarios descritos en los criterios de aceptación de la Historia de Usuario correspondiente.
