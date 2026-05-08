Galaxy Savings
Galaxy Savings es una aplicación móvil multiplataforma desarrollada en Flutter, diseñada para revolucionar la gestión de ahorros personales. Su objetivo principal es permitir a los usuarios administrar sus finanzas de forma dinámica, intuitiva y altamente personalizable, ofreciendo flujos tanto para ahorros libres como para metas a plazo fijo.
Características Principales
El motor de la aplicación se divide en dos modalidades core:
• Ahorro con Objetivo (Target Savings): El usuario define una meta, un monto, una fecha límite y una frecuencia. La aplicación calcula matemáticamente los aportes periódicos necesarios y lleva un registro de rachas (cumplimiento).
• Cuenta Libre (Freestyle Savings): Una alcancía digital sin presiones de tiempo ni montos fijos, ideal para acumular fondos de manera casual con estadísticas detalladas de crecimiento.
Stack Tecnológico y Arquitectura
• Frontend: Flutter & Dart.
• Backend & Base de Datos: Supabase (Autenticación y PostgreSQL).
• Arquitectura: Patrón MVVM (Model-View-ViewModel) implementado bajo los principios de Clean Architecture para asegurar la separación de responsabilidades, escalabilidad y fácil mantenimiento.
• Gestor de Estado: Riverpod.
• Enrutamiento: GoRouter.
• Diseño UI/UX (Adaptativo):
• Android: Implementación estricta de Material Design.
• iOS: Implementación de Cupertino Glassmorphism (Liquid Glass) con efectos avanzados de transparencia y desenfoque (Próximamente).
Estructura de la Aplicación
El proyecto se compone de 15 vistas principales, organizadas lógicamente y conectadas mediante una barra de navegación (Bottom Toolbar) en las pantallas principales.
1. Autenticación y Onboarding
• Splash Screen: Pantalla de carga inicial (3 segundos) con el branding de Galaxy Savings.
• Onboarding Screens (3): Carrusel introductorio que explica brevemente el valor de la aplicación y sus funcionalidades.
• Login Screen: Acceso para usuarios existentes mediante correo y contraseña, con enlace rápido al registro.
• Register Screen: Creación de cuenta con validaciones estrictas: longitud mínima, prevención de correos/usuarios duplicados en base de datos y filtro de lenguaje inapropiado para el username.
2. Panel Principal (Dashboard)
• Dashboard Screen: El núcleo de la app. Muestra una vista general de las cuentas creadas. Si está vacío, invita a la acción. Cada tarjeta de ahorro muestra: nombre, balance actual vs meta, barra de progreso (%) y un icono dinámico de un cerdito que evoluciona según el porcentaje alcanzado. Permite habilitar el modo edición para eliminar cuentas.
3. Motor de Ahorros
• Saving Selection Screen: Bifurcación principal donde el usuario elige entre un "Ahorro con Objetivo" o "Cuenta Libre".
• Create Target Saving: Formulario detallado que solicita nombre, monto meta, fecha límite y frecuencia. El sistema calcula automáticamente la cuota a aportar.
• Create Freestyle Saving: Formulario rápido que únicamente requiere el nombre de la alcancía.
• Manage Target Saving: Panel de control de la meta. Muestra progreso, cuota requerida (editable en el momento del depósito), historial visual de rachas (✅/❌ por día), cálculos de monto faltante y un registro histórico de transacciones (depósitos/retiros).
• Manage Freestyle Saving: Panel de control libre. Muestra el balance acumulado, input rápido de depósito, estadísticas (fecha de inicio, último depósito, monto máximo histórico), botón de retiro, historial de transacciones y una opción destructiva para "Romper la alcancía".
4. Configuración y Perfil
• Settings Screen: Centro de control del usuario. Muestra el avatar y nombre, acceso a la edición de perfil y menús de preferencias del sistema (Idioma, Tema, Cerrar Sesión y Borrar Cuenta).
• Edit Profile Screen: Interfaz para actualizar el avatar, el nombre de usuario y cambiar la contraseña.
• Language Screen: Soporte i18n multiplataforma. Idiomas disponibles: Inglés, Español, Francés, Italiano, Portugués, Alemán, Japonés, Chino y Coreano.
