🌌 Galaxy Savings App Pro
Galaxy Savings es una aplicación móvil multiplataforma desarrollada en Flutter enfocada en la gestión inteligente e interactiva de metas de ahorro. Utiliza metodologías ágiles para su desarrollo, aplicando Clean Architecture y el patrón de diseño MVVM (Model-View-ViewModel).
🎯 Product Goal & Overview
Proveer a los usuarios de una herramienta gamificada, intuitiva y altamente responsiva para establecer objetivos financieros, registrar transacciones (depósitos y retiros), visualizar historiales de balance y mantener la motivación mediante un sistema de rachas diarias y animaciones inmersivas.
🏛️ Software Requirements Specification (SRS)
⚙️ Requisitos Funcionales (FR)
1 Autenticación Segura: El sistema debe permitir el registro, inicio de sesión y eliminación de cuentas de usuario mediante Supabase Auth.
2 Gestión de Metas de Ahorro: El usuario debe poder crear metas con un objetivo financiero (Target) o metas de ahorro libre (Freestyle), definiendo nombre, monto y fecha límite.
3 Control de Transacciones: El sistema debe registrar depósitos y retiros, calculando dinámicamente el balance histórico sin permitir retiros que superen el saldo acumulado (fondos insuficientes).
4 Sistema de Rachas (Streaks): El sistema auditará transacciones en bloques de 24 horas para marcar con éxito o fallo el hábito de ahorro diario del usuario.
5 Personalización de Perfil: El usuario podrá actualizar su ⁠username⁠ (con validación de profanidad) y su ⁠avatar⁠ (subida de imágenes a Supabase Storage).
🛡️ Requisitos No Funcionales (NFR)
1 Arquitectura: Patrón MVVM con gestión de estados reactiva a través de ⁠flutter_riverpod⁠.
2 Internacionalización (i18n): Soporte dinámico para 9 idiomas usando archivos ⁠.arb⁠ sin código duro (hardcoded).
3 Diseño Responsivo UI/UX: Interfaz fluida adaptable a cualquier tamaño de pantalla utilizando ⁠.clamp()⁠ para el cálculo milimétrico de dimensiones, fuentes dinámicas y modo claro/oscuro.
4 Rendimiento Visual: Implementación de animaciones personalizadas ligeras (⁠CustomPainter⁠, ⁠Transform.scale⁠) como CosmicCelebrationStars para evitar dependencias pesadas que afecten el motor Skia/Impeller.
5 Seguridad (Backend): Toda consulta a la base de datos PostgreSQL debe respetar las políticas de seguridad a nivel de fila (Row Level Security - RLS) de Supabase.
🗺️ Product Backlog & Agile Framework
El desarrollo se gestionó mediante un backlog estructurado en Épicas y Historias de Usuario (User Stories).
📌 Epics
￼ Epic 1: Sistema de Identidad y Seguridad (Auth & Perfil).
￼ Epic 2: Dashboard y Visualización de Metas (UI Responsiva).
￼ Epic 3: Motor Transaccional y Gamificación (Rachas y Celebraciones).
￼ Epic 4: Infraestructura, Localización y Temas (i18n, Dark Mode).
👤 Historias de Usuario & Criterios de Aceptación (Gherkin Syntax)
A continuación, un ejemplo del modelo de especificación utilizado durante los sprints, redactado en sintaxis Gherkin (Dado que / Cuando / Entonces):
User Story: Registro de Depósitos y Celebración de Meta
Criterios de Aceptación (Acceptance Criteria):
Escenario 1: Depósito regular que no alcanza la meta al 100%.
￼ Dado que el usuario se encuentra en la pantalla ⁠ManageTargetSavingScreen⁠ con una meta de $1000 y un saldo de $500,
￼ Cuando el usuario ingresa ⁠$100.00⁠ en el campo formateado y presiona "Guardar",
￼ Entonces el saldo acumulado se actualiza a $600,
￼ Y el porcentaje de progreso sube a 60%,
￼ Y se agrega un registro tipo "deposito" al historial de transacciones.
Escenario 2: Depósito que alcanza o supera la meta (Gamificación).
￼ Dado que el usuario tiene una meta de $1000 y un saldo actual de $900,
￼ Cuando el usuario realiza un depósito de ⁠$150.00⁠,
￼ Entonces el sistema registra el nuevo balance de $1050,
￼ Y el indicador de progreso topa visualmente al 100%,
￼ Y el sistema oculta los controles de transacción,
￼ Y se dispara la animación de partículas cósmicas (⁠CosmicCelebrationStars⁠) junto con el mensaje de "¡Felicidades, alcanzaste tu objetivo!".
Escenario 3: Intento de retiro superior a los fondos (Validación de Negocio).
￼ Dado que el usuario tiene un saldo actual de $200,
￼ Cuando intenta realizar un "retiro" por la cantidad de ⁠$300.00⁠,
￼ Entonces el ViewModel intercepta la operación y lanza un error ⁠FormatException('insufficient_funds')⁠,
￼ Y la Vista (UI) muestra un ⁠SnackBar⁠ rojo indicando "No tienes suficientes fondos para realizar esta acción".
🏗️ Stack Tecnológico y Estructura
￼ Frontend: Flutter SDK, Dart.
￼ Backend as a Service: Supabase (PostgreSQL, Auth, Storage).
￼ State Management: Riverpod (⁠StateNotifier⁠, ⁠FutureProvider⁠, ⁠ConsumerWidget⁠).
￼ Enrutamiento: ⁠go_router⁠ para deep-linking e inyección de contexto segura.
🚀 Instalación y Despliegue