# Product Backlog & Software Requirements Specification (SRS)

Este documento detalla la especificación formal de requisitos, la arquitectura de datos subyacente y la planeación ágil de alto nivel para **Galaxy Savings App Pro**. La estructura descrita garantiza la integridad del patrón MVVM, aislando las reglas de negocio de la capa de presentación.

---

## 1. Arquitectura de Datos y Entidades (Data Schema)

El sistema se apoya en una base de datos relacional PostgreSQL (Supabase) estructurada bajo los siguientes esquemas principales:

### 1.1 Entidad: `savings_goals`
Representa la meta central de ahorro, vinculada de forma estricta al propietario de la cuenta.
* `goal_id` (UUID, Primary Key): Identificador único de la meta.
* `user_id` (UUID, Foreign Key): Propietario de la meta (Candado de Seguridad para RLS).
* `goal_name` (Text): Nombre descriptivo de la meta.
* `target_amount` (Numeric, Nullable): Monto objetivo financiero. Si es `null`, el sistema clasifica automáticamente la meta como ahorro libre (*Freestyle*).
* `start_date` (Timestamptz): Fecha y hora exacta de creación, utilizada como punto de partida ("Epoch") para el motor de rachas.
* `frequency_id` (Integer, Foreign Key): Referencia a la tabla `frequencies` para determinar la periodicidad sugerida.

### 1.2 Entidad: `goal_transactions`
Tabla de auditoría inmutable de movimientos financieros.
* `goal_id` (UUID, Foreign Key): Referencia a la meta padre.
* `amount` (Numeric): Cantidad monetaria de la operación.
* `transaction_type` (String): Clasificación estricta (`'deposito'` o `'retiro'`).
* `transaction_date` (Timestamptz): Marca de tiempo ISO-8601 del momento exacto del registro.

---

## 2. Software Requirements Specification (SRS)

### 2.1 Requisitos Funcionales y Reglas de Negocio (FR)

#### **Módulo: Motor Transaccional y Modalidades**
* **FR-01 (Clasificación Dinámica):** Al consultar el sistema, se debe evaluar el campo `target_amount`. Si carece de valor, la meta operará en modalidad *Freestyle* (ahorro sin límite); de lo contrario, operará en modalidad *Target* (objetivo fijo).
* **FR-02 (Balance Histórico):** El sistema procesará cronológicamente la tabla `goal_transactions`. Todo `transaction_type` igual a `'deposito'` sumará al acumulado; si es `'retiro'`, restará, generando un balance histórico.
* **FR-03 (Restricción Visual - Clamp):** Para metas *Target*, el porcentaje de avance se calculará dividiendo el balance actual entre el `target_amount`, restringiendo matemáticamente el valor entre 0 y 100 (`clamp(0, 100)`) para prevenir desbordamientos en la UI.
* **FR-04 (Intercepción de Fondos Insuficientes):** El ViewModel debe auditar todo intento de `'retiro'`. Si el `amount` supera el balance actual, la transacción será abortada lanzando la excepción `FormatException('insufficient_funds')`.

#### **Módulo: Gamificación (Streaks Engine)**
* **FR-05 (Auditoría de Rachas):** El motor evaluará bloques exactos de 24 horas, comenzando desde el `start_date` de la meta hasta la fecha actual.
* **FR-06 (Criterio de Éxito):** Un bloque de 24 horas será marcado como exitoso (`isSuccess: true`) si y solo si existe al menos un registro de `'deposito'` dentro de dicho margen temporal.

### 2.2 Requisitos No Funcionales (NFR)
* **NFR-01 (Aislamiento de Datos):** Las consultas deben estar filtradas a nivel de cliente usando el identificador de la sesión activa (`eq('user_id', currentUser.id)`), respaldado por políticas RLS en PostgreSQL.
* **NFR-02 (Gestión de Memoria):** Los flujos de datos asíncronos en pantallas de navegación deben utilizar la directiva `.autoDispose` para purgar la caché y prevenir fugas de memoria al desmontar la vista.
* **NFR-03 (Internacionalización):** El sistema debe proveer soporte nativo e instantáneo para 9 idiomas a través de archivos `.arb`, evitando el uso de cadenas de texto estáticas (hardcoded) en la UI.

---

## 3. Product Backlog (Epics & User Stories)

### 3.1 Épicas (Epics)
* **EPIC-01: Identidad y Seguridad** (Auth, Row Level Security, Client-Side Filtering).
* **EPIC-02: Dashboard e Interfaz Adaptativa** (Responsive UI, Liquid Glass Aesthetics, i18n).
* **EPIC-03: Motor Transaccional** (Target/Freestyle logic, Balance Reconstruction).
* **EPIC-04: Gamificación Espacial** (Streaks Engine, CustomPainter Animations).

### 3.2 User Stories & Acceptance Criteria (Sintaxis Gherkin)

#### **US-01: Carga Privada de Metas en Dashboard**
> **Como** usuario autenticado,
> **Quiero** que el panel principal muestre únicamente mi información,
> **Para** garantizar la privacidad absoluta de mis finanzas.

**Escenarios de Aceptación:**
* **Dado que** el usuario ha iniciado sesión en el dispositivo,
* **Cuando** el sistema inicializa la carga del panel de control,
* **Entonces** el Provider inyecta el `currentUser.id` en la petición, recupera exclusivamente las metas asociadas, y limpia los datos de la memoria al cambiar de módulo.

#### **US-02: Intercepción de Transacciones Inválidas**
> **Como** usuario del sistema,
> **Quiero** registrar retiros de mis metas,
> **Para** utilizar mis fondos, asegurando que no excedo lo que he ahorrado.

**Escenarios de Aceptación:**
* **Dado que** el usuario tiene un balance consolidado de `$150.00`,
* **Cuando** intenta registrar una operación de `'retiro'` por `$200.00`,
* **Entonces** el ViewModel bloquea la persistencia de datos, arroja el error `insufficient_funds`, y la vista despliega una notificación de error transaccional.

#### **US-03: Auditoría de Rachas de Ahorro**
> **Como** usuario enfocado en la constancia,
> **Quiero** que el sistema rastree mis aportaciones diarias,
> **Para** visualizar mi disciplina financiera a través del tiempo.

**Escenarios de Aceptación:**
* **Dado que** inició un periodo de evaluación hoy a las `08:00:00`,
* **Cuando** el usuario registra un `'deposito'` a las `15:30:00`,
* **Entonces** la iteración del motor clasifica ese bloque de 24 horas como exitoso en el historial de la meta.
