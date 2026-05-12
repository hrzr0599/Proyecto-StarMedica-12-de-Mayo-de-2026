/*
  Base de Datos: StarMedica
  Descripción: Script DDL para la gestión hospitalaria, clínica y administrativa.
  Fecha: 12 de Mayo, 2026
*/

-- 1. CREACIÓN DE LA BASE DE DATOS (Opcional)
-- CREATE DATABASE dbStarMedica;
-- \c dbStarMedica;

-- ======================================================
-- DOMINIO: Infraestructura y Especialidades
-- ======================================================

CREATE TABLE ESPECIALIDAD (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    nombre VARCHAR(100) NOT NULL,
    descripcion TEXT
);

CREATE TABLE PISO (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    numero INTEGER NOT NULL
);

CREATE TABLE HABITACION (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    numero VARCHAR(10) NOT NULL,
    tipo VARCHAR(50), -- Sencilla, Doble, Suite
    capacidad INTEGER,
    piso_id UUID REFERENCES PISO(id)
);

CREATE TABLE CAMA (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    habitacion_id UUID REFERENCES HABITACION(id),
    numero VARCHAR(10) NOT NULL,
    tipo VARCHAR(50),
    disponible BOOLEAN DEFAULT TRUE
);

CREATE TABLE QUIROFANO (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    nombre VARCHAR(50) NOT NULL,
    estado VARCHAR(20), -- Disponible, En Uso, Mantenimiento
    piso_id UUID REFERENCES PISO(id)
);

CREATE TABLE CONSULTORIO (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    numero VARCHAR(10) NOT NULL,
    especialidad_id UUID REFERENCES ESPECIALIDAD(id),
    disponible BOOLEAN DEFAULT TRUE
);

-- ======================================================
-- DOMINIO: Personal Clínico (Empleados)
-- ======================================================

CREATE TABLE EMPLEADO (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    nombre VARCHAR(100) NOT NULL,
    apellidos VARCHAR(100) NOT NULL,
    puesto VARCHAR(100),
    departamento VARCHAR(100),
    telefono VARCHAR(20),
    email VARCHAR(100),
    fecha_ingreso DATE
);

CREATE TABLE MEDICO (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    empleado_id UUID REFERENCES EMPLEADO(id),
    especialidad_id UUID REFERENCES ESPECIALIDAD(id),
    cedula_profesional VARCHAR(50) UNIQUE NOT NULL,
    turno VARCHAR(20) -- Matutino, Vespertino, Nocturno
);

CREATE TABLE ENFERMERO (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    empleado_id UUID REFERENCES EMPLEADO(id),
    nivel VARCHAR(50),
    turno VARCHAR(20),
    area_id UUID -- Referencia interna a departamento/área
);

-- ======================================================
-- DOMINIO: Paciente y Expediente
-- ======================================================

CREATE TABLE PACIENTE (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    nombre VARCHAR(100) NOT NULL,
    apellidos VARCHAR(100) NOT NULL,
    fecha_nacimiento DATE,
    sexo VARCHAR(10),
    curp CHAR(18) UNIQUE,
    telefono VARCHAR(20),
    email VARCHAR(100),
    tipo_sangre VARCHAR(10)
);

CREATE TABLE EXPEDIENTE_CLINICO (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    paciente_id UUID REFERENCES PACIENTE(id),
    fecha_apertura DATE DEFAULT CURRENT_DATE,
    antecedentes TEXT,
    alergias TEXT,
    enfermedades_cronicas TEXT
);

CREATE TABLE SEGURO_MEDICO (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    paciente_id UUID REFERENCES PACIENTE(id),
    aseguradora VARCHAR(100),
    no_poliza VARCHAR(50),
    vigencia DATE,
    cobertura_max DECIMAL(15,2)
);

-- ======================================================
-- DOMINIO: Atención Clínica
-- ======================================================

CREATE TABLE CONSULTA (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    paciente_id UUID REFERENCES PACIENTE(id),
    medico_id UUID REFERENCES MEDICO(id),
    consultorio_id UUID REFERENCES CONSULTORIO(id),
    fecha_hora TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    motivo TEXT,
    diagnostico TEXT,
    tratamiento TEXT,
    estado VARCHAR(20) -- Programada, Completada, Cancelada
);

CREATE TABLE HOSPITALIZACION (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    paciente_id UUID REFERENCES PACIENTE(id),
    medico_id UUID REFERENCES MEDICO(id),
    cama_id UUID REFERENCES CAMA(id),
    fecha_ingreso TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fecha_egreso TIMESTAMP,
    motivo TEXT,
    estado VARCHAR(20)
);

CREATE TABLE CIRUGIA (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    paciente_id UUID REFERENCES PACIENTE(id),
    medico_id UUID REFERENCES MEDICO(id),
    quirofano_id UUID REFERENCES QUIROFANO(id),
    fecha_hora TIMESTAMP,
    tipo_cirugia VARCHAR(100),
    duracion_min INTEGER,
    estado VARCHAR(20)
);

-- ======================================================
-- DOMINIO: Farmacia y Laboratorio
-- ======================================================

CREATE TABLE MEDICAMENTO (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    nombre_generico VARCHAR(100),
    nombre_comercial VARCHAR(100),
    presentacion VARCHAR(50),
    via_administracion VARCHAR(50),
    precio_unitario DECIMAL(12,2)
);

CREATE TABLE RECETA (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    consulta_id UUID REFERENCES CONSULTA(id),
    medico_id UUID REFERENCES MEDICO(id),
    paciente_id UUID REFERENCES PACIENTE(id),
    fecha DATE DEFAULT CURRENT_DATE
);

CREATE TABLE RECETA_MEDICAMENTO (
    receta_id UUID REFERENCES RECETA(id),
    medicamento_id UUID REFERENCES MEDICAMENTO(id),
    dosis VARCHAR(100),
    frecuencia VARCHAR(100),
    duracion_dias INTEGER,
    PRIMARY KEY (receta_id, medicamento_id)
);

CREATE TABLE LABORATORIO (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    nombre VARCHAR(100),
    descripcion TEXT,
    precio DECIMAL(12,2)
);

CREATE TABLE RESULTADO_LAB (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    paciente_id UUID REFERENCES PACIENTE(id),
    laboratorio_id UUID REFERENCES LABORATORIO(id),
    medico_id UUID REFERENCES MEDICO(id),
    fecha DATE DEFAULT CURRENT_DATE,
    resultado TEXT,
    observaciones TEXT
);

-- ======================================================
-- DOMINIO: Administración e Inventario
-- ======================================================

CREATE TABLE FACTURA (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    paciente_id UUID REFERENCES PACIENTE(id),
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    subtotal DECIMAL(15,2),
    iva DECIMAL(15,2),
    total DECIMAL(15,2),
    metodo_pago VARCHAR(50),
    estado VARCHAR(20) -- Pagada, Pendiente, Cancelada
);

CREATE TABLE INVENTARIO (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    descripcion VARCHAR(200),
    categoria VARCHAR(50),
    cantidad_disponible INTEGER,
    cantidad_minima INTEGER,
    unidad VARCHAR(20)
);

-- Tabla sugerida para agenda
CREATE TABLE CITA (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    paciente_id UUID REFERENCES PACIENTE(id),
    medico_id UUID REFERENCES MEDICO(id),
    fecha_hora TIMESTAMP,
    estado VARCHAR(20)
);
