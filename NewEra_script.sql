CREATE TABLE roles (
    id_rol INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    rol VARCHAR(50) NOT NULL UNIQUE
);


CREATE TABLE users (
    id_usuario INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    dni VARCHAR(50) UNIQUE,
    email VARCHAR(200) UNIQUE NOT NULL,
    contrasena VARCHAR(300) NOT NULL,
    username VARCHAR(100) UNIQUE NOT NULL,
    celular VARCHAR(20),
    id_rol INTEGER NOT NULL,

    FOREIGN KEY (id_rol)
    REFERENCES roles(id_rol)
);


CREATE TABLE alumnos (
    id_alumno INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_usuario INTEGER UNIQUE NOT NULL,
    es_menor BOOLEAN DEFAULT FALSE,

    FOREIGN KEY(id_usuario)
    REFERENCES users(id_usuario)
);


CREATE TABLE profesores (
    id_profesor INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_usuario INTEGER UNIQUE NOT NULL,

    FOREIGN KEY(id_usuario)
    REFERENCES users(id_usuario)
);


CREATE TABLE disciplinas (
    id_disciplina INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    disciplina VARCHAR(100) NOT NULL UNIQUE
);


CREATE TABLE grupos (
    id_grupo INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_disciplina INTEGER NOT NULL,
    id_profesor INTEGER NOT NULL,
    nivel VARCHAR(50) NOT NULL,
    cupo_max INTEGER NOT NULL,
    activo BOOLEAN DEFAULT TRUE,

    FOREIGN KEY(id_disciplina)
    REFERENCES disciplinas(id_disciplina),

    FOREIGN KEY(id_profesor)
    REFERENCES profesores(id_profesor)
);


CREATE TABLE horario_grupo (
    id_horario INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_grupo INTEGER NOT NULL,
    dia_semana VARCHAR(20) NOT NULL,
    hora_inicio TIME NOT NULL,
    hora_fin TIME NOT NULL,

    FOREIGN KEY(id_grupo)
    REFERENCES grupos(id_grupo)
);


CREATE TABLE inscripcion (
    id_inscripcion INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_alumno INTEGER NOT NULL,
    id_grupo INTEGER NOT NULL,
    fecha_inscripcion DATE DEFAULT CURRENT_DATE,
    estado VARCHAR(50) DEFAULT 'Activo',

    FOREIGN KEY(id_alumno)
    REFERENCES alumnos(id_alumno),

    FOREIGN KEY(id_grupo)
    REFERENCES grupos(id_grupo)
);


CREATE TABLE clase (
    id_clase INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_grupo INTEGER NOT NULL,
    fecha DATE NOT NULL,
    hora_inicio TIME NOT NULL,
    hora_fin TIME NOT NULL,
    estado VARCHAR(50) DEFAULT 'Pendiente',

    FOREIGN KEY(id_grupo)
    REFERENCES grupos(id_grupo)
);


CREATE TABLE asistencia (
    id_asistencia INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_alumno INTEGER NOT NULL,
    id_clase INTEGER NOT NULL,
    estado VARCHAR(50) NOT NULL,
    observaciones TEXT,

    FOREIGN KEY(id_alumno)
    REFERENCES alumnos(id_alumno),

    FOREIGN KEY(id_clase)
    REFERENCES clase(id_clase)
);


CREATE TABLE periodo_evaluacion (
    id_periodo INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    periodo VARCHAR(100) NOT NULL,
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE NOT NULL
);


CREATE TABLE boletin (
    id_boletin INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_alumno INTEGER NOT NULL,
    id_grupo INTEGER NOT NULL,
    id_profesor INTEGER NOT NULL,
    id_periodo INTEGER NOT NULL,
    anio INTEGER NOT NULL,
    fecha_evaluacion DATE DEFAULT CURRENT_DATE,
    observaciones TEXT,

    FOREIGN KEY(id_alumno)
    REFERENCES alumnos(id_alumno),

    FOREIGN KEY(id_grupo)
    REFERENCES grupos(id_grupo),

    FOREIGN KEY(id_profesor)
    REFERENCES profesores(id_profesor),

    FOREIGN KEY(id_periodo)
    REFERENCES periodo_evaluacion(id_periodo)
);


CREATE TABLE cuota (
    id_cuota INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_alumno INTEGER NOT NULL,
    mes_anio VARCHAR(20) NOT NULL,
    monto NUMERIC(10,2) NOT NULL,
    vencimiento DATE NOT NULL,
    estado VARCHAR(50) DEFAULT 'Pendiente',

    FOREIGN KEY(id_alumno)
    REFERENCES alumnos(id_alumno)
);


CREATE TABLE pago (
    id_pago INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_cuota INTEGER NOT NULL,
    id_inscripcion INTEGER,
    monto NUMERIC(10,2) NOT NULL,
    fecha_pago TIMESTAMP,
    estado VARCHAR(50),
    id_mercado_pago BIGINT UNIQUE,
    metodo_pago VARCHAR(50),
    detalle TEXT,

    FOREIGN KEY(id_cuota)
    REFERENCES cuota(id_cuota),

    FOREIGN KEY(id_inscripcion)
    REFERENCES inscripcion(id_inscripcion)
);


CREATE TABLE persona_autorizada (
    id_autorizada INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_alumno INTEGER NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    dni VARCHAR(50) NOT NULL,
    parentesco VARCHAR(50),
    telefono VARCHAR(20),

    FOREIGN KEY(id_alumno)
    REFERENCES alumnos(id_alumno)
);


CREATE TABLE retiro_menor (
    id_retiro INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_alumno INTEGER NOT NULL,
    id_autorizada INTEGER NOT NULL,
    id_profesor INTEGER NOT NULL,
    fecha_hora TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY(id_alumno)
    REFERENCES alumnos(id_alumno),

    FOREIGN KEY(id_autorizada)
    REFERENCES persona_autorizada(id_autorizada),

    FOREIGN KEY(id_profesor)
    REFERENCES profesores(id_profesor)
);    



CREATE INDEX idx_usuario_email
ON users(email);


CREATE INDEX idx_inscripcion_alumno
ON inscripcion(id_alumno);


CREATE INDEX idx_inscripcion_grupo
ON inscripcion(id_grupo);


CREATE INDEX idx_clase_fecha
ON clase(fecha);


CREATE INDEX idx_asistencia_clase
ON asistencia(id_clase);


CREATE INDEX idx_pago_estado
ON pago(estado);