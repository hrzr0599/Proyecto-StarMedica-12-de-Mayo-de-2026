# 🏥 Plan de Implementación: StarMedica (App Hospitalaria Multiplataforma)
> **Objetivo:** Desarrollar un sistema CRUD médico profesional para Android, Web y Windows. Basado en el modelo de entidades proporcionado. Enfoque estándar, entorno de desarrollo/test (no producción). Sin código en esta fase.

---

## 🛠️ 1. Herramientas Requeridas
| Categoría | Herramienta | Propósito en el flujo |
|-----------|-------------|----------------------|
| **Framework** | Flutter SDK + Dart | Desarrollo multiplataforma |
| **IDE** | VS Code (recomendado) / Android Studio | Edición, depuración, CLI integrado. *Nota: Antigravity no es un IDE nativo para Flutter; si se utiliza, debe soportar ejecución de `flutter` CLI y depuración de Dart.* |
| **Backend** | Firebase Console + Firebase CLI | Auth, Firestore, emuladores locales, configuración de apps |
| **Control de Versiones** | Git + GitHub/GitLab | Historial, ramas, colaboración |
| **Diseño UI/UX** | Figma / Penpot | Wireframes, sistema de diseño, handoff |
| **Pruebas** | Chrome/Edge (Web), Windows Desktop, Android Emulator/Dispositivo | Validación responsive y multiplataforma |
| **Depuración** | Flutter DevTools, Firebase Emulator Suite | Performance, logs, simulación de Firestore/Auth |

---

## 🎨 2. Estrategia UI/UX (Médica & Moderna)
1. **Diseño Responsivo:** 
   - **Móvil:** Listas verticales, tarjetas, navegación inferior.
   - **Web/Windows:** Layouts tipo dashboard, tablas de datos (`DataGrid`), navegación lateral, múltiples paneles visibles simultáneamente.
2. **Sistema de Diseño Clínico:**
   - Paleta: Azul médico (`#0056A3`), blanco, grises suaves, acentos verdes/teal para estados positivos, rojo suave para alertas.
   - Tipografía: `Inter` o `Roboto` (legible en tablas y formularios).
   - Espaciado: Basado en `8px` para alineación consistente.
3. **Componentes Reutilizables:**
   - `MedicalCard`, `DataTableResponsive`, `FormSection`, `StatusBadge`, `EmptyStateIllustration`, `LoadingSkeleton`.
4. **Estados de Interfaz:**
   - `Cargando` → Skeletons o spinners clínicos.
   - `Vacío` → Ilustración + botón de acción.
   - `Error` → Mensaje humano + reintentos controlados.
   - `Éxito` → Feedback visual + navegación automática.
5. **Accesibilidad:** Contraste ≥ 4.5:1, navegación por teclado (Web/Windows), escalado de texto, etiquetas `semantics` para lectores.

---

## 📦 3. Dependencias (`pubspec.yaml`)
*(Versiones estables recomendadas; se actualizarán a la última compatible al iniciar)*

| Paquete | Finalidad |
|---------|-----------|
| `flutter` | SDK base |
| `firebase_core` | Inicialización de Firebase |
| `firebase_auth` | Autenticación Email/Password |
| `cloud_firestore` | Base de datos NoSQL en tiempo real |
| `provider` | Gestión de estado y inyección de dependencias |
| `go_router` | Enrutamiento declarativo, histórico para Web/Windows |
| `intl` | Formateo de fechas, zonas horarias y números |
| `uuid` | Generación de IDs únicos para entidades locales |
| `flutter_form_builder` + `formz` | Construcción y validación de formularios complejos |
| `data_table_2` | Tablas responsive con paginación, ordenamiento y filtros |
| `cached_network_image` | Carga optimizada de avatares y recursos remotos |
| `logger` | Registro estructurado de eventos (debug) |
| `flutter_secure_storage` | Persistencia segura de tokens/sesiones |
| `window_manager` (opcional Web/Windows) | Control de tamaño mínimo, maximizado y estado de ventana |

---

## 🗂️ 4. Arquitectura y Mapeo del Modelo de Entidades
> **Nota estructural:** Flutter utiliza `lib/` para el código fuente. `bin/` está reservado para herramientas CLI. El plan se estructura en `lib/` siguiendo estándares oficiales, manteniendo la lógica que solicitaste.

### Estructura de Carpetas (`lib/`)
```
lib/
├── core/                 # Tema, rutas, constantes, utilidades, validadores
├── domain/               # Entidades puras (mapeadas desde tu modelo), interfaces de repositorios
├── data/                 # Implementación Firestore, mappers DTO ↔ Entidad, repositorios concretos
├── presentation/         # Pantallas, widgets, providers, controladores de vista
└── main.dart             # Punto de entrada, inicialización de Firebase y Provider
```

### Mapeo de Entidades a Firestore
| Colección Firestore | Entidad Original | Notas de Relación |
|---------------------|------------------|-------------------|
| `pacientes` | PACIENTE | 1:N con `expedientes`, `citas`, `consultas` |
| `expedientes_clinicos` | EXPEDIENTE_CLINICO | Subcolección o referencia por `paciente_id` |
| `seguros_medicos` | SEGURO_MEDICO | Referencia por `paciente_id` |
| `empleados` | EMPLEADO | Padre de `medicos` y `enfermeros` |
| `medicos` / `enfermeros` | MEDICO / ENFERMERO | Referencia a `empleado_id`, `especialidad_id`, `area_id` |
| `especialidades` | ESPECIALIDAD | Catálogo referenciado |
| `citas` | CITA | Agendamiento, estado, vínculo `paciente_id` + `medico_id` |
| `consultas` | CONSULTA | Historial clínico, diagnóstico, estado |
| `hospitalizaciones` / `camas` / `habitaciones` | HOSPITALIZACION, CAMA, HABITACION | Control de ocupación, referencia cruzada |
| `cirugias` / `quirofanos` | CIRUGIA, QUIROFANO | Programación quirúrgica, disponibilidad |
| `recetas` / `medicamentos` / `recetas_medicamentos` | RECETA, MEDICAMENTO, RECETA_MEDICAMENTO | N:N manejado como subcolección o documento con array de referencias |
| `laboratorios` / `resultados_lab` | LABORATORIO, RESULTADO_LAB | Resultados adjuntos a paciente/consulta |
| `consultorios` | CONSULTORIO | Asignación por especialidad y disponibilidad |
| `facturas` | FACTURA | Cálculo, método de pago, estado financiero |
| `inventarios` | INVENTARIO | Control de stock, alertas de mínimo |

> 🔹 **Estrategia Firestore:** Documentos planos con `reference` a otras colecciones. Relaciones 1:N con subcolecciones o campos `array` de IDs. N:N con colecciones puente (`recetas_medicamentos`). Índices compuestos para consultas por fecha, estado y especialidad.

---

## 🔐 5. Configuración Firebase y Autenticación (Modo Desarrollo)
1. **Console:** Crear proyecto `StarMedica-Dev`.
2. **Authentication:** Habilitar `Email/Password`. Desactivar verificación por correo en fase de desarrollo.
3. **Firestore:** Crear base de datos en modo `Test` (sin reglas restrictivas inicialmente). Se migrarán a reglas por rol en fases posteriores.
4. **Apps:** Registrar `Android`, `Web`, `Windows`. Descargar `google-services.json` y `firebase-config.json`.
5. **CLI:** Ejecutar `flutterfire configure` para generar `firebase_options.dart`.
6. **Sesiones:** Persistencia `LOCAL` para desarrollo. Logout manual. Sin tokens de recarga automática complejos.
7. **Roles:** Campo `role` en documento de usuario (`admin`, `medico`, `enfermero`, `recepcion`, `finanzas`). UI se adapta según rol.

---

## 📝 6. Plan Paso a Paso (Fases de Desarrollo)

### 🔹 Fase 1: Entorno y Estructura Base
1. Instalar Flutter, Dart, Firebase CLI, Git.
2. Ejecutar `flutter doctor`, habilitar plataformas: `flutter create . --platforms android,web,windows`.
3. Crear repositorio, ramas `main`, `develop`, `feature/*`.
4. Generar estructura de carpetas (`core/`, `domain/`, `data/`, `presentation/`).
5. Configurar `pubspec.yaml` con dependencias listadas. Ejecutar `flutter pub get`.

✅ *Validación:* `flutter run -d windows` / `web` / `android` muestra app vacía sin errores. `flutter analyze` limpio.

---

### 🔹 Fase 2: Diseño UI/UX y Sistema de Componentes
1. Definir `ThemeData` global: colores, tipografía, elevaciones, bordes redondeados clínicos.
2. Crear biblioteca de componentes base: botones, inputs, tarjetas, badges de estado, tablas responsive.
3. Implementar layout shell con navegación adaptable (barra inferior móvil, lateral desktop).
4. Configurar `go_router` con rutas públicas (`/login`, `/register`) y protegidas (`/dashboard`, `/crud/*`).
5. Importar assets y configurar `pubspec.yaml`.

✅ *Validación:* Navegación fluida entre pantallas vacías. Diseño consistente en Web/Windows/Móvil.

---

### 🔹 Fase 3: Integración Firebase y Autenticación
1. Inicializar Firebase en `main.dart` con `firebase_options.dart`.
2. Implementar `AuthRepository` abstracto en `domain/`.
3. Crear implementación Firestore en `data/` con métodos: `signIn`, `signUp`, `signOut`, `userStream`.
4. Configurar `AuthProvider` con `ChangeNotifier`: expone `currentUser`, `isLoading`, `error`, `role`.
5. Conectar formularios de login/registro al provider. Validar campos en UI.
6. Proteger rutas con guardias de autenticación. Redirigir según rol.

✅ *Validación:* Registro y login funcionales. Sesión persistente en reinicio. Rutas protegidas operativas.

---

### 🔹 Fase 4: Mapeo de Dominio y Repositorios CRUD
1. Definir clases de entidad en `domain/` exactas al modelo proporcionado (sin lógica de UI).
2. Crear `FirestoreMappers` en `data/` para convertir `DocumentSnapshot` ↔ Entidad.
3. Implementar `CrudRepository<T>` genérico con: `create`, `getById`, `getAllStream`, `update`, `delete`, `search`.
4. Instanciar repositorios específicos por colección (`PacienteRepository`, `CitaRepository`, etc.).
5. Configurar listeners en tiempo real solo para vistas activas. Cancelar suscripciones al navegar.

✅ *Validación:* Lectura/escritura en Firestore desde emulador. Mapeo de campos correcto. Sin fugas de memoria.

---

### 🔹 Fase 5: Gestión de Estado con Provider
1. Inyectar repositorios mediante `Provider` en `main.dart`.
2. Crear `CitaProvider`, `PacienteProvider`, `InventarioProvider`, etc.
3. Cada provider maneja estados: `loading`, `data`, `error`, `pagination`, `filters`.
4. Usar `Consumer` o `Selector` en UI para minimizar rebuilds.
5. Centralizar lógica de negocio en repositories, no en UI.

✅ *Validación:* UI se actualiza reactivamente. Sin warnings de `Provider`. Scroll fluido en listas largas.

---

### 🔹 Fase 6: Desarrollo CRUD por Módulos (Priorizado)
1. **Módulo Pacientes:** Alta, edición, historial, búsqueda por nombre/curp/email.
2. **Módulo Citas:** Agendar, confirmar, cancelar, filtrar por fecha/médico/estado.
3. **Módulo Médicos/Enfermeros:** Catálogo, turnos, especialidades, asignación a consultorios.
4. **Módulo Consultas/Expedientes:** Registro diagnóstico, alergias, antecedentes, adjuntar resultados lab.
5. **Módulo Inventario/Farmacia:** Stock, recetas, medicamentos, alertas de mínimo.
6. **Módulo Hospitalización/Camas:** Ocupación, traslados, estado de habitación/cama.
7. Cada módulo sigue flujo: `List → Detail/Form → Save → Sync → Feedback`.

✅ *Validación:* Operaciones CRUD completas por módulo. Validaciones de negocio aplicadas. Sincronización con Firestore.

---

### 🔹 Fase 7: Tablas de Datos y Responsive Layout
1. Implementar `data_table_2` para Web/Windows con columnas configurables.
2. Agregar paginación, ordenamiento por fecha/estado, filtros rápidos.
3. Alternar layout: `DataTable` en desktop, `ListView/Card` en móvil.
4. Optimizar carga: `StreamBuilder` paginado, `ListView.builder` con `itemExtent`.
5. Añadir exportación básica a CSV (opcional en fase 8).

✅ *Validación:* Tablas renderizan >100 registros sin lag. Responsive adaptado a viewport. Filtros funcionales.

---

### 🔹 Fase 8: Validaciones, Errores y Estados de UI
1. Validaciones en formularios: campos obligatorios, formatos (email, curp, teléfono, fechas futuras).
2. Manejo de errores de Firestore: permisos, desconexión, límites de escritura.
3. Implementar banners de error, modales de confirmación, snackbars informativos.
4. Offline básico: mostrar último estado conocido, indicar modo sin conexión.
5. Logs estructurados con `logger` para depuración.

✅ *Validación:* App no se bloquea ante errores. Feedback claro al usuario. Logs legibles en consola.

---

### 🔹 Fase 9: Pruebas y Optimización Multiplataforma
1. Pruebas unitarias: mappers, validadores, lógica de repositorio.
2. Pruebas de widget: formularios, tablas, estados de carga/error.
3. Pruebas de integración: flujo completo Login → Crear Cita → Ver en Lista.
4. Optimizar: evitar rebuilds innecesarios, caché de imágenes, lazy loading.
5. Ejecutar en las 3 plataformas simultáneamente. Ajustar márgenes, tipografía y navegación.

✅ *Validación:* `flutter test` pasa. 0 crashes en DevTools. FPS estable ≥ 60 en desktop/web.

---

### 🔹 Fase 10: Empaquetado y Despliegue Local/Testing
1. Configurar entornos de ejecución: `flutter run -d windows`, `flutter run -d web`, `flutter run -d android`.
2. Generar builds de prueba: `flutter build windows`, `flutter build web --release`, `flutter build apk`.
3. Verificar que Firebase Auth/Firestore responde en cada plataforma.
4. Documentar flujos de uso, credenciales de prueba y estructura de Firestore.
5. Preparar checklist para revisión técnica antes de pasar a código detallado.

✅ *Validación:* Builds ejecutables sin errores. Firebase conectado en todas las plataformas. Documentación actualizada.

---

## ✅ Checklist de Validación por Fase
| Fase | Criterio de Aceptación | Herramienta |
|------|------------------------|-------------|
| 1 | Entorno listo y `flutter doctor` verde | Terminal |
| 2 | Tema aplicado y navegación funcional | VS Code + Emuladores |
| 3 | Login/Registro y rutas protegidas | Firebase Auth + DevTools |
| 4 | Entidades mapeadas y repositorios operativos | Firestore Emulator |
| 5 | Provider estable y sin rebuilds | Flutter DevTools |
| 6 | CRUD funcional por módulo | QA Manual |
| 7 | Tablas responsive y paginadas | Web/Windows Browser |
| 8 | Validaciones y manejo de errores | Formularios + Consola |
| 9 | Pruebas aprobadas y rendimiento óptimo | `flutter test` + DevTools |
| 10 | Builds ejecutables y conectados | `flutter build` + Firebase |

---

## 📌 Notas Críticas y Siguientes Pasos
1. **Estructura de Carpetas:** Flutter utiliza `lib/` para código fuente. `bin/` es para CLI. El plan se alinea al estándar oficial para garantizar compatibilidad con herramientas, compiladores y empaquetadores multiplataforma.
2. **Modo Desarrollo:** Firestore en `Test Mode`, sin reglas estrictas, sin obfuscación, builds debug. Ideal para iteración rápida. Se migrará a producción en fase posterior.
3. **Relaciones en Firestore:** No hay `JOIN` nativo. Se manejan con `reference`, subcolecciones o campos `array`. El plan prioriza consultas eficientes y evita N+1.
4. **Provider:** Se usa para orquestar UI y estado. Lógica pesada permanece en `data/` y `domain/`. Esto facilita migración futura a `Riverpod` o `Bloc` si se requiere.
5. **Próximo Hito:** Una vez validado este plan, se procederá a:
   - Generar el `pubspec.yaml` exacto con versiones compatibles.
   - Crear la estructura de carpetas y archivos `.dart` base.
   - Implementar `main.dart`, configuración Firebase, y primer CRUD funcional.

¿Deseas que ajuste alguna fase, priorice un módulo específico (ej. Citas o Pacientes), o pase a la generación del `pubspec.yaml` y estructura de archivos `.dart` listos para copiar en tu proyecto?
