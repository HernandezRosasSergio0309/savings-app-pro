# Product Backlog & Software Requirements Specification (SRS)

Este documento contiene la especificación formal de requisitos, la arquitectura de datos y la planeación ágil de alto nivel para **Galaxy Savings**. La estructura descrita garantiza la integridad del patrón MVVM, aislando las reglas de negocio en ViewModels y Providers (Riverpod) de la capa de presentación.

---

## 1. Arquitectura de Datos y Entidades (Data Schema)

El sistema se apoya en una base de datos relacional PostgreSQL (Supabase) estructurada bajo los siguientes esquemas principales, deducidos de los Data Transfer Objects (DTOs) y la capa de dominio:

### 1.1 Entidad: `savings_goals`
Representa la meta central de ahorro, vinculada de forma estricta al propietario de la cuenta.
* `goal_id` (UUID, Primary Key): Identificador único de la meta.
* `user_id` (UUID, Foreign Key): Propietario de la meta (Candado de Seguridad / RLS).
* `goal_name` (Text): Nombre descriptivo de la meta.
* `target_amount` (Numeric, Nullable): Monto objetivo financiero. Si es `null`, el sistema la clasifica automáticamente como una meta de ahorro libre (*Freestyle*).
* `start_date` (Timestamptz): Fecha y hora exacta de creación, utilizada como "Epoch" para el motor de rachas (Streaks).
* `frequency_id` (Integer, Foreign Key): Referencia a la tabla `frequencies` para determinar la periodicidad de ahorro sugerida.

### 1.2 Entidad: `goal_transactions`
Tabla de auditoría inmutable de movimientos financieros.
* `goal_id` (UUID, Foreign Key): Referencia a la meta padre.
* `amount` (Numeric): Cantidad monetaria del movimiento.
* `transaction_type` (String): Clasificación estricta (`'deposito'` o `'retiro'`).
* `transaction_date` (Timestamptz): Marca de tiempo ISO-8601 del momento exacto de la operación.

---

## 2. Software Requirements Specification (SRS)

### 2.1 Requisitos Funcionales y Reglas de Negocio (FR)

#### **Módulo: Motor Transaccional y Tipos de Ahorro**
* **FR-01 (Clasificación Dinámica de Metas):** Al consultar el panel principal, el sistema debe evaluar el campo `target_amount`. Si carece de valor (`null`), la meta operará bajo la modalidad *Freestyle* (ahorro infinito); de lo contrario, operará bajo la modalidad *Target* (objetivo fijo).
* **FR-02 (Reconstrucción de Balance Histórico):** El sistema procesará cronológicamente la tabla `goal_transactions`. Si el `transaction_type` es `'deposito'`, se suma al acumulado; si es `'retiro'`, se resta, generando un balance histórico consolidado.
* **FR-03 (Cálculo de Progreso Clamp):** Para las metas tipo *Target*, el porcentaje de avance se calculará dividiendo el balance actual entre el `target_amount`, restringiendo el valor porcentual entre 0 y 100 (`clamp(0, 100)`) para evitar desbordamientos visuales.
* **FR-04 (Interceptador de Fondos Insuficientes):** El ViewModel debe auditar todo intento de `'retiro'`. Si el `amount` solicitado supera el balance actual, la transacción será abortada antes de alcanzar la base de datos, lanzando una excepción `FormatException('insufficient_funds')`.

#### **Módulo: Gamificación (Streaks Engine)**
* **FR-05 (Auditoría de Rachas de 24 Horas):** El motor iterará sobre la línea de tiempo en bloques exactos de 24 horas, comenzando desde el `start_date` de la meta hasta la fecha y hora actuales.
* **FR-06 (Criterio de Éxito de Racha):** Un bloque de 24 horas se marcará como exitoso (`isSuccess: true`) única y exclusivamente si existe al menos un registro con `transaction_type == 'deposito'` dentro de dicho margen temporal.

### 2.2 Requisitos No Funcionales (NFR)
* **NFR-01 (Aislamiento de Sesión y Seguridad):** Las consultas de metas deben estar filtradas explícitamente a nivel de cliente por el `currentUser.id` proveído por Supabase Auth, complementado con políticas RLS (Row Level Security) en el backend.
* **NFR-02 (Optimización de Memoria Cache):** Los flujos de datos asíncronos en el panel principal (Dashboard) deben utilizar la directiva `.autoDispose` de Riverpod para purgar la memoria caché al desmontar la vista.
* **NFR-03 (Arquitectura e i18n):** Código desacoplado mediante Clean Architecture y soporte multiidioma nativo para 9 idiomas usando archivos `.arb`.

---

## 3. Product Backlog (Epics & User Stories)

### 3.1 Épicas (Epics)
* **EPIC-01: Identidad y Seguridad** (Auth, RLS, Client-Side Isolation).
* **EPIC-02: Dashboard e Interfaz Adaptativa** (Responsive UI, Liquid Glass Design, i18n).
* **EPIC-03: Motor Transaccional y Modelado de Datos** (Validación de balances, Modalidades Target/Freestyle).
* **EPIC-04: Gamificación Espacial** (Motor de Rachas y Animación de Partículas CustomPainter).

### 3.2 User Stories & Acceptance Criteria (Sintaxis Gherkin)

#### **US-01: Dashboard con Aislamiento de Datos**
> **Como** usuario autenticado en la plataforma,
> **Quiero** que el panel principal cargue exclusivamente mis metas de ahorro,
> **Para** garantizar la privacidad de mis finanzas y mantener mi información segura.

**Escenario 1: Carga exitosa de información propia.**
* **Dado que** el usuario ha iniciado sesión correctamente.
* **Cuando** el `savingsProvider` inicializa su petición de carga de metas.
* **Entonces** el sistema inyecta el `currentUser.id` como candado de seguridad, recupera las metas mapeando correctamente si son *Target* o *Freestyle*, y muestra los acumulados dinámicos sin retener datos en caché al salir.

#### **US-02: Registro Transaccional Seguro**
> **Como** usuario del sistema,
> **Quiero** registrar movimientos financieros en mis metas activas,
> **Para** auditar mi progreso real sin exceder mis fondos disponibles.

**Escenario 1: Intercepción de Retiro sin Fondos.**
* **Dado que** el usuario tiene un balance consolidado de `$150.00` en su meta.
* **Cuando** intenta registrar una operación de `'retiro'` por `$200.00`.
* **Entonces** la capa de presentación delega la acción al ViewModel, el cual bloquea la inserción a Supabase, arroja un error `insufficient_funds` y la interfaz despliega una advertencia visual.

#### **US-03: Motor Dinámico de Rachas (Streaks)**
> **Como** usuario enfocado en desarrollar el hábito del ahorro constante,
> **Quiero** que el sistema rastree mis aportaciones en bloques de tiempo,
> **Para** visualizar mis días de éxito y mantener la disciplina.

**Escenario 1: Bloque temporal de 24h exitoso.**
* **Dado que** inició un periodo de evaluación el día de hoy a las `08:00:00`.
* **Cuando** el usuario realiza un `'deposito'` a las `15:30:00` del mismo día.
* **Entonces** el motor de iteración del ViewModel clasifica el bloque temporal como exitoso en la lista de rachas auditadas.
