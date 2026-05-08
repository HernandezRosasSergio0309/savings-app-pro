## Documentación de Casos de Uso (Core System)

### CU-01: Creación de Ahorro con Objetivo (Target Saving)
* **Actor Principal:** Usuario Autenticado.
* **Pantallas Involucradas:** `saving_selection_screen`, `create_target_saving_screen`.
* **Descripción:** Permite al usuario configurar una meta financiera con fecha y monto límite, delegando al sistema el cálculo de los aportes periódicos.

**Precondiciones:** 
El usuario tiene una sesión activa y se encuentra en la pantalla de selección de ahorro.

**Flujo Principal (Éxito):**
1. El usuario selecciona la opción "Ahorro con Objetivo".
2. El sistema despliega el formulario en `create_target_saving_screen`.
3. El usuario ingresa: Nombre del objetivo, Monto total a alcanzar, Fecha límite (*Target Date*) y selecciona una Frecuencia (Diaria, Semanal, Quincenal, Mensual).
4. El usuario presiona el botón "Calcular y Crear".
5. El sistema valida que los campos no estén vacíos, que el monto sea `> 0` y que la fecha límite sea mayor a la fecha actual.
6. El sistema calcula la cantidad matemática a aportar por periodo (`periodic_amount`).
7. El sistema inserta un nuevo registro en la tabla `savings_goals` asociando el `user_id` y el `frequency_id`.
8. El sistema notifica el éxito, redirige a `dashboard_screen` y actualiza la lista de tarjetas.

**Flujos Alternativos:**
* **1a. Datos inválidos:** El sistema detecta una fecha en el pasado o texto en campos numéricos. Bloquea la acción y muestra un mensaje de error bajo el campo correspondiente (estilo Material/Cupertino).

**Postcondiciones:** 
La meta existe en la base de datos y el motor de cálculos está listo para recibir transacciones.

---

### CU-02: Registro de Depósito y Cálculo de Racha
* **Actor Principal:** Usuario Autenticado.
* **Pantallas Involucradas:** `manage_target_saving_screen`.
* **Descripción:** El usuario realiza una aportación de dinero hacia su meta de ahorro, actualizando su balance y su historial de cumplimiento.

**Precondiciones:** 
El usuario seleccionó una meta activa desde el dashboard.

**Flujo Principal (Éxito):**
1. El sistema carga los datos de la meta y sugiere en el input la cantidad pre-calculada (`periodic_amount`).
2. El usuario acepta la sugerencia o modifica la cantidad con un monto personalizado.
3. El usuario presiona "Ingresar cantidad".
4. El sistema inserta el registro en la tabla `goal_transactions` con `transaction_type = 'deposit'` y el `amount` ingresado.
5. El sistema ejecuta el recálculo (sumando depósitos, restando retiros) para actualizar el `Current_Balance`.
6. El sistema actualiza el historial de rachas en la interfaz, marcando el día actual con una palomita (✅).

**Flujos Alternativos:**
* **1a. Monto cero o negativo:** El sistema desactiva el botón de ingreso o muestra un error de validación para evitar romper la regla `CHECK (amount > 0)` de la base de datos.

**Postcondiciones:** 
El balance general del usuario aumenta, la meta reduce su saldo faltante y se actualiza la interfaz de progreso (ej. el icono del cerdito avanza).

---

### CU-03: Romper Alcancía (Destrucción de Cuenta Libre)
* **Actor Principal:** Usuario Autenticado.
* **Pantallas Involucradas:** `manage_freestyle_saving_screen`.
* **Descripción:** El usuario decide liquidar y eliminar por completo una cuenta de ahorro libre.

**Precondiciones:** 
El usuario está visualizando los detalles de una cuenta "Freestyle".

**Flujo Principal (Éxito):**
1. El usuario presiona el botón de acción destructiva "Romper la alcancía".
2. El sistema despliega un diálogo modal de confirmación (*Alert Dialog*) advirtiendo que esta acción es irreversible y simulará el retiro total de los fondos.
3. El usuario confirma la acción ("Sí, romper").
4. El sistema ejecuta un `DELETE` sobre la tabla `savings_goals` utilizando el `goal_id` (debido al `ON DELETE CASCADE` de Supabase, todas las transacciones asociadas en `goal_transactions` se eliminan automáticamente).
5. El sistema redirige al `dashboard_screen` y muestra una notificación de éxito.

**Flujos Alternativos:**
* **1a. Cancelación:** En el paso 2, el usuario presiona "Cancelar". El diálogo se cierra y no se altera la base de datos.

**Postcondiciones:** 
La meta y todo su historial de transacciones son eliminados del sistema de forma permanente.

---

### CU-04: Autenticación y Bloqueo de Lenguaje Inapropiado
* **Actor Principal:** Usuario No Registrado.
* **Pantallas Involucradas:** `register_screen`.
* **Descripción:** Un usuario nuevo intenta crear una cuenta, pasando por las barreras de seguridad y validación de datos.

**Precondiciones:** 
La aplicación se encuentra en la pantalla de registro.

**Flujo Principal (Éxito):**
1. El usuario ingresa un `username`, un `email` válido, y una `password` (repitiéndola para confirmación).
2. El usuario presiona "Crear Cuenta".
3. El sistema valida que las contraseñas coincidan y cumplan la longitud específica requerida.
4. El sistema pasa el `username` por un filtro interno de validación léxica para detectar palabras obscenas.
5. El sistema consulta a Supabase para asegurar que el `username` y el `email` no violan la restricción `UNIQUE`.
6. El sistema crea el usuario en la tabla `users` mediante el servicio de autenticación.
7. El sistema redirige al `dashboard_screen`.

**Flujos Alternativos:**
* **1a. Lenguaje obsceno detectado:** En el paso 4, el filtro da positivo. El sistema bloquea el registro y muestra un error: "El nombre de usuario contiene palabras no permitidas".
* **1b. Duplicidad de datos:** En el paso 5, el correo o usuario ya existen (`[TEST 01]`). El sistema rechaza el registro e informa al usuario qué campo específico está duplicado.

**Postcondiciones:** 
Se genera un nuevo perfil seguro en el sistema y se emite un token de sesión.
