# Galaxy Savings

Galaxy Savings es una aplicación móvil multiplataforma desarrollada en **Flutter**, diseñada para revolucionar la gestión de ahorros personales. Su objetivo principal es permitir a los usuarios administrar sus finanzas de forma dinámica, intuitiva y altamente personalizable, ofreciendo flujos tanto para ahorros libres como para metas a plazo fijo.

## Características Principales

El motor de la aplicación se divide en dos modalidades core:

* **Ahorro con Objetivo (Target Savings):** El usuario define una meta, un monto, una fecha límite y una frecuencia. La aplicación calcula matemáticamente los aportes periódicos necesarios y lleva un registro de rachas (cumplimiento).
* **Cuenta Libre (Freestyle Savings):** Una alcancía digital sin presiones de tiempo ni montos fijos, ideal para acumular fondos de manera casual con estadísticas detalladas de crecimiento.

## Stack Tecnológico y Arquitectura

| Componente | Tecnología |
| :--- | :--- |
| **Frontend** | Flutter & Dart |
| **Backend** | Supabase (Autenticación y PostgreSQL) |
| **Gestor de Estado** | Riverpod |
| **Enrutamiento** | GoRouter |
| **Arquitectura** | MVVM (Model-View-ViewModel) + Clean Architecture |

### Diseño UI/UX (Adaptativo)
* **Android:** Implementación estricta de Material Design.
* **iOS:** Implementación de *Cupertino Glassmorphism* (Liquid Glass) con efectos avanzados de transparencia y desenfoque (Próximamente).

---

## Estructura de la Aplicación

El proyecto se compone de **15 vistas principales**, organizadas lógicamente y conectadas mediante una barra de navegación (*Bottom Toolbar*).

### 1. Autenticación y Onboarding
* **Splash Screen:** Pantalla de carga inicial (3 segundos) con el branding de Galaxy Savings.
* **Onboarding Screens (3):** Carrusel introductorio que explica el valor de la aplicación.
* **Login Screen:** Acceso mediante correo y contraseña.
* **Register Screen:** Creación de cuenta con validaciones estrictas (longitud, duplicados y filtro de lenguaje inapropiado).

### 2. Panel Principal (Dashboard)
* **Dashboard Screen:** El núcleo de la app. Muestra una vista general de las cuentas. Cada tarjeta de ahorro incluye:
    * Nombre y balance actual vs meta.
    * Barra de progreso porcentual.
    * **Icono dinámico:** Un cerdito que evoluciona según el porcentaje alcanzado.
    * Modo edición para gestión de cuentas.

### 3. Motor de Ahorros
* **Saving Selection Screen:** Bifurcación para elegir entre "Ahorro con Objetivo" o "Cuenta Libre".
* **Create Target Saving:** Formulario con cálculo automático de cuotas según meta y tiempo.
* **Create Freestyle Saving:** Formulario simplificado para alcancías rápidas.
* **Manage Target Saving:** Panel de control con progreso, historial de rachas (✅/❌), monto faltante y registro de transacciones.
* **Manage Freestyle Saving:** Panel con balance acumulado, estadísticas (máximos históricos), historial y la opción de "Romper la alcancía".

### 4. Configuración y Perfil
* **Settings Screen:** Gestión de avatar, preferencias de idioma, tema y seguridad.
* **Edit Profile Screen:** Actualización de perfil y cambio de contraseña.
* **Language Screen:** Soporte **i18n** con idiomas disponibles: Inglés, Español, Francés, Italiano, Portugués, Alemán, Japonés, Chino y Coreano.
