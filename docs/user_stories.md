## Épicas e Historias de Usuario

### Épica 1: Autenticación y Onboarding

**US-1.01: Experiencia de Bienvenida (Onboarding)**
> **Historia:** Como usuario nuevo, quiero ver pantallas introductorias al abrir la aplicación, para entender rápidamente cómo Galaxy Savings me ayudará a gestionar mi dinero.

**Criterios de Aceptación:**
* Debe mostrar la `splash_screen` durante exactamente 3 segundos.
* Debe mostrar un carrusel de 3 pantallas de onboarding.
* Debe almacenar en caché (`SharedPreferences`) que el usuario ya vio el onboarding para evitar mostrarlo en futuros inicios.

**US-1.02: Registro de Cuenta Nueva**
> **Historia:** Como usuario sin cuenta, quiero registrarme con mi correo y contraseña, para guardar mis metas de ahorro de forma segura.

**Criterios de Aceptación:**
* Debe validar que el nombre de usuario y el correo no existan previamente en la base de datos (Supabase).
* Debe incluir un filtro que bloquee el uso de palabras obscenas en el nombre de usuario.
* Debe validar la longitud mínima de usuario y contraseña.
* Debe requerir la confirmación de la contraseña.

**US-1.03: Inicio de Sesión**
> **Historia:** Como usuario registrado, quiero iniciar sesión con mis credenciales, para acceder a mi panel personal.

**Criterios de Aceptación:**
* Debe permitir el acceso mediante correo electrónico y contraseña.
* Debe mostrar mensajes de error claros si las credenciales son incorrectas.

---

### Épica 2: Panel Principal (Dashboard)

**US-2.01: Visualización General de Ahorros**
> **Historia:** Como usuario autenticado, quiero ver una lista de todas mis cuentas de ahorro en el dashboard, para conocer mi progreso de un vistazo.

**Criterios de Aceptación:**
* Si no hay ahorros, debe mostrar un mensaje invitando a crear uno.
* Cada tarjeta debe mostrar: nombre del ahorro, cantidad actual, cantidad meta (si aplica) y porcentaje logrado.
* La tarjeta debe incluir un icono de un cerdito que cambie visualmente según el porcentaje de progreso.

**US-2.02: Edición del Dashboard**
> **Historia:** Como usuario con ahorros activos, quiero un botón para editar mi dashboard, para poder eliminar cuentas que ya no necesito.

**Criterios de Aceptación:**
* El botón de editar solo debe ser visible si existe al menos un ahorro creado.
* Al eliminar un ahorro, debe borrarse de la tabla `savings_goals` y actualizar la interfaz inmediatamente.

---

### Épica 3: Creación de Ahorros

**US-3.01: Selección de Tipo de Ahorro**
> **Historia:** Como usuario, quiero poder elegir entre crear un "Ahorro con objetivo" o una "Cuenta libre", para adaptar la herramienta a mis necesidades financieras.

**Criterios de Aceptación:**
* Debe mostrar la pantalla `saving_selection_screen` con dos opciones claras que redirijan a sus respectivos formularios.

**US-3.02: Creación de Ahorro con Objetivo**
> **Historia:** Como usuario, quiero crear una meta de ahorro con montos y fechas específicas, para que la app calcule automáticamente mis cuotas.

**Criterios de Aceptación:**
* Debe pedir: Nombre, Monto a alcanzar, Fecha meta, y Frecuencia (Diaria, Semanal, Quincenal, Mensual).
* El sistema debe realizar el cálculo matemático para mostrar y guardar la cantidad exacta que se debe aportar por periodo.

**US-3.03: Creación de Ahorro Libre**
> **Historia:** Como usuario, quiero crear una alcancía sin presiones, para guardar dinero cuando yo quiera.

**Criterios de Aceptación:**
* Solo debe requerir el campo "Nombre del ahorro".
* Los campos `target_amount` y `end_date` deben guardarse como `NULL` en la base de datos.

---

### Épica 4: Gestión y Transacciones

**US-4.01: Gestión de Ahorro con Objetivo**
> **Historia:** Como usuario, quiero registrar mis aportaciones en mi meta fija y ver mi racha, para mantenerme motivado.

**Criterios de Aceptación:**
* Debe sugerir la cuota pre-calculada, pero permitir ingresar un monto diferente si el usuario lo desea.
* Debe registrar el depósito en la tabla `goal_transactions`.
* Debe mostrar un calendario/historial de cumplimiento (✅ si aportó, ❌ si falló).
* Debe actualizar el monto faltante en tiempo real.

**US-4.02: Gestión de Ahorro Libre**
> **Historia:** Como usuario, quiero depositar, retirar o "romper" mi alcancía libre, para tener control total sobre mis fondos acumulados.

**Criterios de Aceptación:**
* Debe permitir registrar depósitos y retiros.
* Debe mostrar estadísticas: fecha de inicio, fecha del último depósito, monto máximo alcanzado.
* Debe incluir un botón destructivo para "Romper la alcancía" (eliminar meta y extraer fondos virtuales).

---

### Épica 5: Configuración y Perfil

**US-5.01: Configuración de Idioma y Preferencias**
> **Historia:** Como usuario, quiero cambiar el idioma y el tema de mi aplicación, para personalizar mi experiencia.

**Criterios de Aceptación:**
* Debe permitir seleccionar entre: Inglés, Español, Francés, Italiano, Portugués, Alemán, Japonés, Chino y Coreano.
* El cambio de idioma debe aplicarse en toda la app de forma inmediata.

**US-5.02: Edición de Perfil**
> **Historia:** Como usuario, quiero actualizar mi foto, nombre de usuario y contraseña, para mantener mi información al día.

**Criterios de Aceptación:**
* Debe actualizar los datos en la tabla `users` de Supabase.
* Debe aplicar las mismas reglas de validación (sin lenguaje inapropiado, sin duplicados) que en el proceso de registro.
