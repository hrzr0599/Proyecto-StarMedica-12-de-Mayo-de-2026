# Actua como un administrador de base de datos; proyecto Hospital StarMedica, que entidades se necesitan para su gestion

Como DBA del proyecto Hospital StarMedica, aquí está el análisis de entidades necesarias para una gestión hospitalaria completa:

**Dominios principales identificados:** Pacientes, Personal clínico, Operaciones médicas, Administración y Recursos.---

<img width="759" height="388" alt="image" src="https://github.com/user-attachments/assets/8f5818e2-ebb2-423b-bcd5-dbe967e0859f" />

El modelo se organiza en **6 dominios funcionales**:

**Atención al paciente**
`PACIENTE`, `EXPEDIENTE_CLINICO`, `CONSULTA`, `HOSPITALIZACION`, `CIRUGÍA` — núcleo del sistema. Cada paciente tiene un expediente único y puede generar múltiples eventos clínicos.

**Personal clínico**
`MEDICO`, `ENFERMERO`, `EMPLEADO`, `ESPECIALIDAD` — se usa herencia (`MEDICO` y `ENFERMERO` extienden a `EMPLEADO`) para no duplicar datos de RH.

**Farmacia y prescripción**
`RECETA`, `MEDICAMENTO`, `RECETA_MEDICAMENTO` — tabla puente con dosis y frecuencia para la relación M:N entre receta y medicamento.

**Infraestructura hospitalaria**
`HABITACION`, `CAMA`, `QUIROFANO` — modela la capacidad física del hospital, permitiendo control de disponibilidad en tiempo real.

**Laboratorio**
`LABORATORIO`, `RESULTADO_LAB` — catálogo de estudios y sus resultados vinculados al paciente y al médico solicitante.

**Administración y finanzas**
`FACTURA`, `SEGURO_MEDICO`, `INVENTARIO` — gestión de cobros, cobertura de aseguradoras y control de insumos.

---

**Consideraciones de diseño importantes:**

- Se recomienda usar **UUIDs** como PKs para evitar colisiones en ambientes multi-sede (StarMedica tiene varias sucursales).
- Las entidades `MEDICO` y `ENFERMERO` usan **herencia por referencia** a `EMPLEADO`, facilitando la gestión de nómina centralizada.
- `INVENTARIO` puede expandirse con una entidad `PROVEEDOR` y `ORDEN_COMPRA` si se requiere módulo de abastecimiento.
- Se puede agregar `CONSULTORIO` como entidad separada si el hospital maneja múltiples consultorios con agenda propia.

¿Quieres que profundice en algún dominio específico, defina los tipos de datos exactos, o diseñe el esquema SQL de alguna tabla?


# Las entidades con sus atributos y tipo en forma de tabla para cada una de las entidades

<img width="1440" height="3248" alt="image" src="https://github.com/user-attachments/assets/310b75cf-122d-44a4-8603-01676f6a1fb0" />

