# 🏥 Plan de Implementación: StarMedica (App Hospitalaria)

> **Objetivo:** Desarrollar una aplicación multiplataforma (Android/iOS/Web) para gestión hospitalaria utilizando Flutter + Dart + Firebase. Este documento establece el procedimiento paso a paso **sin incluir código**, enfocado en arquitectura, flujos, herramientas y validaciones.

---

## 📋 Información General del Proyecto
| Aspecto | Detalle |
|--------|---------|
| **Framework** | Flutter (Dart) |
| **Backend/BaaS** | Firebase (Authentication + Cloud Firestore) |
| **Gestión de Estado** | `provider` |
| **IDE Recomendado** | VS Code (con extensiones oficiales) / Android Studio |
| **Plataformas Objetivo** | Android, iOS, Web (opcional) |
| **Metodología** | Desarrollo incremental por fases con validación continua |

> 📌 *Nota sobre Antigravity:* No es un IDE estándar para Flutter. Se recomienda **VS Code** o **Android Studio** por su ecosistema completo, depuración nativa y compatibilidad con el toolchain de Flutter.

---

## 🛠️ Herramientas Requeridas
| Categoría | Herramienta | Propósito |
|-----------|-------------|-----------|
| **Desarrollo** | Flutter SDK + Dart | Framework y lenguaje |
| **IDE** | VS Code + Extensiones (`Flutter`, `Dart`, `Error Lens`, `GitLens`, `Firebase`) | Edición, depuración, formateo |
| **Backend** | Firebase Console + Firebase CLI | Creación de proyecto, despliegue de reglas, emuladores |
| **Diseño UI/UX** | Figma / Penpot | Prototipado, sistema de diseño, handoff |
| **Control de Versiones** | Git + GitHub/GitLab | Historial, ramas, colaboración |
| **Pruebas** | Dispositivos reales + Android Emulator / iOS Simulator | Validación multiplataforma |
| **Documentación** | Markdown + Mermaid (opcional) | Diagramas de flujo, estructura, decisiones |

---

## 🎨 UI/UX: Lineamientos y Estrategia
1. **Identidad Visual Médica:** Paleta basada en azul clínico, blanco, gris suave y acentos verdes/teal. Tipografía legible (Inter, Roboto, o SF Pro).
2. **Accesibilidad (WCAG 2.1 AA):** Contraste ≥ 4.5:1, targets táctiles ≥ 48x48, soporte para lectores de pantalla, escalado de texto dinámico.
3. **Navegación:** Barra inferior (`BottomNavigationBar`) + menú lateral para configuración/perfil. Flujos lineales para citas, historial y emergencias.
4. **Estados de Interfaz:** 
   - `Loading` (skeletons o spinners médicos)
   - `Empty` (ilustraciones + CTA claros)
   - `Error` (mensajes humanos + reintentos)
   - `Success` (confirmaciones visuales + feedback háptico)
5. **Validación UX:** Formularios con retroalimentación en tiempo real, autenticación de 2 pasos opcional, y offline-first para lectura básica.

---

## 📦 Dependencias Principales (`pubspec.yaml`)
*(Versiones indicadas como `^latest` para mantener compatibilidad actual)*

| Paquete | Finalidad |
|---------|-----------|
| `flutter` | SDK base |
| `firebase_core` | Inicialización de Firebase |
| `firebase_auth` | Autenticación Email/Password |
| `cloud_firestore` | Base de datos NoSQL en tiempo real |
| `provider` | Gestión de estado y dependencias |
| `go_router` | Enrutamiento declarativo y seguro |
| `intl` | Formateo de fechas, monedas y zonas horarias |
| `flutter_form_builder` + `formz` | Validación y manejo de formularios |
| `shared_preferences` / `flutter_secure_storage` | Persistencia local segura |
| `cached_network_image` | Carga optimizada de avatares/imágenes |
| `logger` + `sentry_flutter` (opcional) | Logging y monitoreo de errores |

> 🔒 *Nota de seguridad:* Para datos médicos sensibles, considerar cifrado local (`encrypt`), cumplimiento normativo (HIPAA/GDPR según región) y reglas estrictas en Firestore.

---

## 🗂️ Arquitectura y Estructura del Proyecto
Se recomienda **Arquitectura por Capas + Patrón Repositorio** para mantener separación de responsabilidades:

```
lib/
├── core/                 # Constantes, temas, utilidades, enrutamiento
├── domain/               # Entidades, casos de uso, interfaces de repositorios
├── data/                 # Implementaciones Firebase, DTOs, mappers
├── presentation/         # Pantallas, widgets, viewmodels/providers
├── main.dart             # Punto de entrada
└── firebase_options.dart # Generado por Firebase CLI
```

- **Provider** se usará para exponer estados de UI, autenticación y datos Firestore.
- **Repositorios** abstraen Firebase: `AuthRepository`, `PatientRepository`, `AppointmentRepository`, etc.
- **Entidades puras** en `domain/` sin dependencias de Flutter/Firebase.

---

## 📝 Plan Paso a Paso (Fases de Desarrollo)

### 🔹 Fase 1: Configuración del Entorno
1. Instalar Flutter SDK, Dart, Git y VS Code.
2. Ejecutar `flutter doctor` y resolver dependencias faltantes (Android SDK, Xcode, emuladores).
3. Instalar extensiones recomendadas en VS Code.
4. Configurar Firebase CLI (`npm install -g firebase-tools`), login con `firebase login`.
5. Crear repositorio Git, estructura de ramas (`main`, `develop`, `feature/*`).

✅ *Validación:* `flutter create starmedica` genera proyecto compilable. `firebase --version` responde correctamente.

---

### 🔹 Fase 2: Arquitectura y Estructura Base
1. Definir carpetas según modelo propuesto (`core/`, `domain/`, `data/`, `presentation/`).
2. Configurar tema global (`ThemeData`), tipografía y colores en `core/theme/`.
3. Implementar enrutador base con `go_router` (rutas públicas vs protegidas).
4. Crear `main.dart` con inicialización de `ProviderScope` y `Firebase.initializeApp()`.

✅ *Validación:* La app arranca, muestra pantalla de carga, y la estructura de directorios es coherente.

---

### 🔹 Fase 3: Diseño UI/UX y Prototipado
1. Crear wireframes en Figma: Login, Dashboard, Perfil, Citas, Historial.
2. Definir componentes reutilizables: `PrimaryButton`, `InputField`, `LoadingOverlay`, `ErrorBanner`.
3. Establecer flujo de navegación y estados de error/éxito.
4. Exportar assets (íconos, logos, imágenes de placeholder) a `assets/`.

✅ *Validación:* Prototipo navegable aprobado por stakeholders. Todos los assets importados y referenciados en `pubspec.yaml`.

---

### 🔹 Fase 4: Configuración de Firebase
1. Crear proyecto en Firebase Console (`StarMedica`).
2. Habilitar **Authentication** → Proveedor Email/Password.
3. Habilitar **Cloud Firestore** → Modo producción con reglas base restrictivas.
4. Ejecutar `flutterfire configure` para generar `firebase_options.dart`.
5. Configurar reglas de seguridad iniciales (solo usuarios autenticados pueden leer/escribir sus propios datos).

✅ *Validación:* `firebase login` y `firebase projects:list` funcionan. `flutterfire configure` genera archivos sin errores.

---

### 🔹 Fase 5: Autenticación (Email/Password)
1. Diseñar contrato de `AuthRepository` (registro, login, logout, estado actual, recuperación).
2. Implementar provider `AuthProvider` que exponga `User?`, `isLoading`, `error`.
3. Conectar formularios de UI al provider.
4. Manejar rutas protegidas: redirigir a Login si no hay sesión válida.
5. Implementar validaciones de contraseña y mensajes de error amigables.

✅ *Validación:* Registro y login exitosos en emulador/dispositivo. Sesión persistente tras reinicio. Rutas protegidas funcionales.

---

### 🔹 Fase 6: Modelo de Datos y Firestore
1. Diseñar estructura de colecciones: `users`, `patients`, `appointments`, `medical_records`, `doctors`.
2. Definir DTOs y mappers para convertir documentos Firestore ↔ Entidades de dominio.
3. Implementar repositorios con métodos: `getById`, `streamAll`, `create`, `update`, `delete`.
4. Aplicar índices compuestos y reglas de seguridad por rol (paciente, médico, admin).
5. Configurar listeners en tiempo real solo para vistas activas.

✅ *Validación:* Lectura/escritura controlada. Reglas Firestore validadas con emuladores. Sin fugas de listeners.

---

### 🔹 Fase 7: Gestión de Estado con Provider
1. Crear `ChangeNotifier` o `ProxyProvider` por módulo (Auth, Appointments, Profile).
2. Inyectar dependencias mediante `Provider` en `main.dart` o por pantalla.
3. Centralizar carga de datos: estados `loading`, `data`, `error`.
4. Implementar refresco manual y sincronización offline básica.
5. Evitar rebuilds innecesarios usando `Consumer<T>` o `Selector<T, R>`.

✅ *Validación:* UI se actualiza correctamente ante cambios de estado. Sin warnings de Provider. Rendimiento estable en scroll/listas.

---

### 🔹 Fase 8: Desarrollo de Módulos Core
1. **Dashboard:** Resumen de citas próximas, accesos rápidos, notificaciones locales.
2. **Gestión de Citas:** CRUD completo, validación de horarios, estados (pendiente, confirmada, cancelada).
3. **Perfil y Configuración:** Edición de datos, cambio de contraseña, preferencias de notificación.
4. **Historial Médico (básico):** Lectura protegida, filtros por fecha/especialidad.
5. Integrar `go_router` con parámetros y guardias de autenticación.

✅ *Validación:* Flujos completos funcionales. Sin crashes en navegación. Datos persisten y se sincronizan.

---

### 🔹 Fase 9: Pruebas y Optimización
1. **Pruebas Unitarias:** Repositorios, mappers, validaciones de formularios.
2. **Pruebas de Widget:** Componentes UI, flujos de autenticación, estados de carga.
3. **Pruebas de Integración:** Flujos E2E críticos (login → crear cita → ver confirmación).
4. Optimizar imágenes, caché de red, y reducir rebuilds.
5. Analizar con `flutter run --profile` y DevTools.

✅ *Validación:* Cobertura ≥ 70% en lógica crítica. 0 warnings en `flutter analyze`. Rendimiento ≥ 60 FPS en scroll.

---

### 🔹 Fase 10: Despliegue y Mantenimiento
1. Configurar entornos (dev, staging, prod) con variables separadas.
2. Generar builds: `flutter build apk --release`, `flutter build ios`, `flutter build web`.
3. Configurar CI/CD (GitHub Actions / Codemagic) para pruebas automáticas y despliegue.
4. Publicar en Play Store / App Store (cumplir guías de apps médicas).
5. Establecer monitoreo con Firebase Crashlytics y Analytics.

✅ *Validación:* Builds firmados y subidos exitosamente. Crashlytics reporta 0 errores críticos en primeras 48h.

---

## ✅ Checklist de Validación por Fase
| Fase | Criterio de Aceptación | Herramienta de Verificación |
|------|------------------------|-----------------------------|
| 1 | Entorno listo y `flutter doctor` verde | Terminal |
| 2 | Estructura coherente y tema aplicado | VS Code + Linter |
| 3 | Prototipo aprobado y assets importados | Figma + `pubspec.yaml` |
| 4 | Firebase configurado y reglas base | Console + CLI |
| 5 | Login/Registro funcional y persistente | Dispositivo + Auth Emulator |
| 6 | Firestore seguro y estructurado | Emulator + Rules Playground |
| 7 | Provider estable y sin rebuilds | DevTools + Performance Overlay |
| 8 | Módulos core operativos | QA Manual + User Testing |
| 9 | Pruebas aprobadas y rendimiento óptimo | `flutter test` + DevTools |
| 10 | Apps publicadas y monitoreadas | Stores + Crashlytics |

---

## 📌 Notas Finales y Siguientes Pasos
- Este plan **no incluye código** por diseño. Sirve como hoja de ruta para ejecución estructurada.
- Antes de comenzar la Fase 5, definir roles de usuario (Paciente, Médico, Admin) y permisos por colección.
- Para cumplimiento normativo, considerar auditoría de cambios, consentimiento explícito y cifrado en tránsito/reposo.
- Una vez aprobado este plan, se puede proceder a la implementación técnica módulo por módulo, con revisiones de código y validación en cada fase.
