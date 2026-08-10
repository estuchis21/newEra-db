-- ============================================================
-- RESET COMPLETO DE LA BASE DE DATOS
-- ============================================================

DROP TABLE IF EXISTS
    liquidacion_profesor,
    reglas_pago_profesor,
    retiro_menor,
    persona_autorizada,
    pago,
    cuota,
    boletin,
    periodo_evaluacion,
    asistencia,
    reserva,
    movimiento_credito,
    compra_creditos,
    paquetes_creditos,
    tipos_credito,
    clase,
    tipos_clase,
    inscripcion,
    horario_grupo,
    grupos,
    disciplinas,
    profesores,
    alumnos,
    users,
    roles
CASCADE;


-- ============================================================
-- 1. ROLES
-- ============================================================

CREATE TABLE roles (
    id_rol INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    rol VARCHAR(50) NOT NULL UNIQUE
);


-- ============================================================
-- 2. USERS
-- ============================================================

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

    CONSTRAINT fk_users_rol
        FOREIGN KEY (id_rol)
        REFERENCES roles(id_rol)
);


-- ============================================================
-- 3. ALUMNOS
-- ============================================================

CREATE TABLE alumnos (
    id_alumno INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_usuario INTEGER UNIQUE NOT NULL,
    es_menor BOOLEAN NOT NULL DEFAULT FALSE,

    CONSTRAINT fk_alumnos_usuario
        FOREIGN KEY (id_usuario)
        REFERENCES users(id_usuario)
);


-- ============================================================
-- 4. PROFESORES
-- ============================================================

CREATE TABLE profesores (
    id_profesor INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_usuario INTEGER UNIQUE NOT NULL,

    CONSTRAINT fk_profesores_usuario
        FOREIGN KEY (id_usuario)
        REFERENCES users(id_usuario)
);


-- ============================================================
-- 5. DISCIPLINAS
-- ============================================================

CREATE TABLE disciplinas (
    id_disciplina INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    disciplina VARCHAR(100) NOT NULL UNIQUE
);


-- ============================================================
-- 6. GRUPOS
-- ============================================================

CREATE TABLE grupos (
    id_grupo INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_disciplina INTEGER NOT NULL,
    id_profesor INTEGER NOT NULL,
    nivel VARCHAR(50) NOT NULL,
    cupo_max INTEGER NOT NULL CHECK (cupo_max > 0),
    activo BOOLEAN NOT NULL DEFAULT TRUE,

    CONSTRAINT fk_grupos_disciplina
        FOREIGN KEY (id_disciplina)
        REFERENCES disciplinas(id_disciplina),

    CONSTRAINT fk_grupos_profesor
        FOREIGN KEY (id_profesor)
        REFERENCES profesores(id_profesor)
);


-- ============================================================
-- 7. HORARIOS DE GRUPOS
-- ============================================================

CREATE TABLE horario_grupo (
    id_horario INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_grupo INTEGER NOT NULL,
    dia_semana VARCHAR(20) NOT NULL,
    hora_inicio TIME NOT NULL,
    hora_fin TIME NOT NULL,

    CONSTRAINT fk_horario_grupo
        FOREIGN KEY (id_grupo)
        REFERENCES grupos(id_grupo),

    CONSTRAINT chk_horario
        CHECK (hora_fin > hora_inicio)
);


-- ============================================================
-- 8. INSCRIPCIONES
-- ============================================================

CREATE TABLE inscripcion (
    id_inscripcion INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_alumno INTEGER NOT NULL,
    id_grupo INTEGER NOT NULL,
    fecha_inscripcion DATE NOT NULL DEFAULT CURRENT_DATE,
    estado VARCHAR(50) NOT NULL DEFAULT 'Activo',

    CONSTRAINT fk_inscripcion_alumno
        FOREIGN KEY (id_alumno)
        REFERENCES alumnos(id_alumno),

    CONSTRAINT fk_inscripcion_grupo
        FOREIGN KEY (id_grupo)
        REFERENCES grupos(id_grupo)
);


-- ============================================================
-- 9. TIPOS DE CLASE
-- ============================================================

CREATE TABLE tipos_clase (
    id_tipo_clase INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    tipo VARCHAR(50) NOT NULL UNIQUE,
    descripcion TEXT
);


-- ============================================================
-- 10. TIPOS DE CRÉDITO
-- ============================================================

CREATE TABLE tipos_credito (
    id_tipo_credito INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL UNIQUE,
    descripcion TEXT,
    activo BOOLEAN NOT NULL DEFAULT TRUE
);


-- ============================================================
-- 11. PAQUETES DE CRÉDITOS
-- ============================================================

CREATE TABLE paquetes_creditos (
    id_paquete INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_tipo_credito INTEGER NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    cantidad_creditos INTEGER NOT NULL CHECK (cantidad_creditos > 0),
    precio NUMERIC(10,2) NOT NULL CHECK (precio >= 0),
    activo BOOLEAN NOT NULL DEFAULT TRUE,

    CONSTRAINT fk_paquetes_tipo_credito
        FOREIGN KEY (id_tipo_credito)
        REFERENCES tipos_credito(id_tipo_credito)
);


-- ============================================================
-- 12. CLASES
-- ============================================================

CREATE TABLE clase (
    id_clase INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,

    id_grupo INTEGER,
    id_tipo_clase INTEGER NOT NULL,

    fecha DATE NOT NULL,
    hora_inicio TIME NOT NULL,
    hora_fin TIME NOT NULL,

    estado VARCHAR(50) NOT NULL DEFAULT 'Pendiente',

    CONSTRAINT fk_clase_grupo
        FOREIGN KEY (id_grupo)
        REFERENCES grupos(id_grupo),

    CONSTRAINT fk_clase_tipo
        FOREIGN KEY (id_tipo_clase)
        REFERENCES tipos_clase(id_tipo_clase),

    CONSTRAINT chk_clase_horario
        CHECK (hora_fin > hora_inicio)
);


-- ============================================================
-- 13. COMPRAS DE CRÉDITOS
-- ============================================================

CREATE TABLE compra_creditos (
    id_compra INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,

    id_alumno INTEGER NOT NULL,
    id_paquete INTEGER NOT NULL,

    cantidad_creditos INTEGER NOT NULL
        CHECK (cantidad_creditos > 0),

    precio_pagado NUMERIC(10,2) NOT NULL
        CHECK (precio_pagado >= 0),

    fecha_compra TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    estado VARCHAR(50) NOT NULL DEFAULT 'Pagado',

    CONSTRAINT fk_compra_alumno
        FOREIGN KEY (id_alumno)
        REFERENCES alumnos(id_alumno),

    CONSTRAINT fk_compra_paquete
        FOREIGN KEY (id_paquete)
        REFERENCES paquetes_creditos(id_paquete)
);


-- ============================================================
-- 14. MOVIMIENTOS DE CRÉDITOS
-- ============================================================

CREATE TABLE movimiento_credito (
    id_movimiento INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,

    id_alumno INTEGER NOT NULL,
    id_tipo_credito INTEGER NOT NULL,
    id_compra INTEGER,

    cantidad INTEGER NOT NULL,

    tipo VARCHAR(30) NOT NULL,

    fecha TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    descripcion TEXT,

    CONSTRAINT fk_movimiento_alumno
        FOREIGN KEY (id_alumno)
        REFERENCES alumnos(id_alumno),

    CONSTRAINT fk_movimiento_tipo
        FOREIGN KEY (id_tipo_credito)
        REFERENCES tipos_credito(id_tipo_credito),

    CONSTRAINT fk_movimiento_compra
        FOREIGN KEY (id_compra)
        REFERENCES compra_creditos(id_compra),

    CONSTRAINT chk_movimiento_tipo
        CHECK (
            tipo IN (
                'COMPRA',
                'CONSUMO',
                'DEVOLUCION',
                'AJUSTE'
            )
        )
);


-- ============================================================
-- 15. RESERVAS
-- ============================================================

CREATE TABLE reserva (
    id_reserva INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,

    id_alumno INTEGER NOT NULL,
    id_clase INTEGER NOT NULL,
    id_movimiento_credito INTEGER,

    fecha_reserva TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    estado VARCHAR(30) NOT NULL DEFAULT 'Reservada',

    CONSTRAINT fk_reserva_alumno
        FOREIGN KEY (id_alumno)
        REFERENCES alumnos(id_alumno),

    CONSTRAINT fk_reserva_clase
        FOREIGN KEY (id_clase)
        REFERENCES clase(id_clase),

    CONSTRAINT fk_reserva_movimiento
        FOREIGN KEY (id_movimiento_credito)
        REFERENCES movimiento_credito(id_movimiento),

    CONSTRAINT chk_reserva_estado
        CHECK (
            estado IN (
                'Reservada',
                'Confirmada',
                'Asistio',
                'Cancelada',
                'No_Asistio'
            )
        ),

    CONSTRAINT uq_reserva_alumno_clase
        UNIQUE (id_alumno, id_clase)
);


-- ============================================================
-- 16. ASISTENCIA
-- ============================================================

CREATE TABLE asistencia (
    id_asistencia INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,

    id_alumno INTEGER NOT NULL,
    id_clase INTEGER NOT NULL,

    estado VARCHAR(50) NOT NULL,

    observaciones TEXT,

    CONSTRAINT fk_asistencia_alumno
        FOREIGN KEY (id_alumno)
        REFERENCES alumnos(id_alumno),

    CONSTRAINT fk_asistencia_clase
        FOREIGN KEY (id_clase)
        REFERENCES clase(id_clase),

    CONSTRAINT uq_asistencia_alumno_clase
        UNIQUE (id_alumno, id_clase)
);


-- ============================================================
-- 17. REGLAS DE PAGO A PROFESORES
-- ============================================================

CREATE TABLE reglas_pago_profesor (
    id_regla INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,

    porcentaje_profesor NUMERIC(5,2) NOT NULL,
    porcentaje_academia NUMERIC(5,2) NOT NULL,

    fecha_inicio DATE NOT NULL,
    fecha_fin DATE,

    activo BOOLEAN NOT NULL DEFAULT TRUE,

    CONSTRAINT chk_porcentajes
        CHECK (
            porcentaje_profesor >= 0
            AND porcentaje_academia >= 0
            AND porcentaje_profesor + porcentaje_academia = 100
        ),

    CONSTRAINT chk_fechas_regla
        CHECK (
            fecha_fin IS NULL
            OR fecha_fin >= fecha_inicio
        )
);


-- ============================================================
-- 18. LIQUIDACIÓN DE PROFESORES
-- ============================================================

CREATE TABLE liquidacion_profesor (
    id_liquidacion INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,

    id_profesor INTEGER NOT NULL,
    id_reserva INTEGER NOT NULL,

    monto_base NUMERIC(10,2) NOT NULL
        CHECK (monto_base >= 0),

    porcentaje NUMERIC(5,2) NOT NULL
        CHECK (porcentaje >= 0),

    monto_profesor NUMERIC(10,2) NOT NULL
        CHECK (monto_profesor >= 0),

    monto_academia NUMERIC(10,2) NOT NULL
        CHECK (monto_academia >= 0),

    fecha_generacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    estado VARCHAR(30) NOT NULL DEFAULT 'Pendiente',

    CONSTRAINT fk_liquidacion_profesor
        FOREIGN KEY (id_profesor)
        REFERENCES profesores(id_profesor),

    CONSTRAINT fk_liquidacion_reserva
        FOREIGN KEY (id_reserva)
        REFERENCES reserva(id_reserva),

    CONSTRAINT chk_liquidacion_estado
        CHECK (
            estado IN (
                'Pendiente',
                'Pagado',
                'Anulado'
            )
        ),

    CONSTRAINT uq_liquidacion_reserva
        UNIQUE (id_reserva)
);


-- ============================================================
-- 19. PERÍODOS DE EVALUACIÓN
-- ============================================================

CREATE TABLE periodo_evaluacion (
    id_periodo INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,

    periodo VARCHAR(100) NOT NULL,

    fecha_inicio DATE NOT NULL,
    fecha_fin DATE NOT NULL,

    CONSTRAINT chk_periodo_fechas
        CHECK (fecha_fin >= fecha_inicio)
);


-- ============================================================
-- 20. BOLETINES
-- ============================================================

CREATE TABLE boletin (
    id_boletin INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,

    id_alumno INTEGER NOT NULL,
    id_grupo INTEGER NOT NULL,
    id_profesor INTEGER NOT NULL,
    id_periodo INTEGER NOT NULL,

    anio INTEGER NOT NULL,

    fecha_evaluacion DATE NOT NULL DEFAULT CURRENT_DATE,

    observaciones TEXT,

    CONSTRAINT fk_boletin_alumno
        FOREIGN KEY (id_alumno)
        REFERENCES alumnos(id_alumno),

    CONSTRAINT fk_boletin_grupo
        FOREIGN KEY (id_grupo)
        REFERENCES grupos(id_grupo),

    CONSTRAINT fk_boletin_profesor
        FOREIGN KEY (id_profesor)
        REFERENCES profesores(id_profesor),

    CONSTRAINT fk_boletin_periodo
        FOREIGN KEY (id_periodo)
        REFERENCES periodo_evaluacion(id_periodo)
);


-- ============================================================
-- 21. CUOTAS
-- ============================================================

CREATE TABLE cuota (
    id_cuota INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,

    id_alumno INTEGER NOT NULL,

    mes_anio VARCHAR(20) NOT NULL,

    monto NUMERIC(10,2) NOT NULL
        CHECK (monto >= 0),

    vencimiento DATE NOT NULL,

    estado VARCHAR(50) NOT NULL DEFAULT 'Pendiente',

    CONSTRAINT fk_cuota_alumno
        FOREIGN KEY (id_alumno)
        REFERENCES alumnos(id_alumno)
);


-- ============================================================
-- 22. PAGOS
-- ============================================================

CREATE TABLE pago (
    id_pago INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,

    id_cuota INTEGER NOT NULL,

    id_inscripcion INTEGER,

    monto NUMERIC(10,2) NOT NULL
        CHECK (monto >= 0),

    fecha_pago TIMESTAMP,

    estado VARCHAR(50),

    id_mercado_pago BIGINT UNIQUE,

    metodo_pago VARCHAR(50),

    detalle TEXT,

    CONSTRAINT fk_pago_cuota
        FOREIGN KEY (id_cuota)
        REFERENCES cuota(id_cuota),

    CONSTRAINT fk_pago_inscripcion
        FOREIGN KEY (id_inscripcion)
        REFERENCES inscripcion(id_inscripcion)
);


-- ============================================================
-- 23. PERSONAS AUTORIZADAS
-- ============================================================

CREATE TABLE persona_autorizada (
    id_autorizada INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,

    id_alumno INTEGER NOT NULL,

    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,

    dni VARCHAR(50) NOT NULL,

    parentesco VARCHAR(50),

    telefono VARCHAR(20),

    CONSTRAINT fk_autorizada_alumno
        FOREIGN KEY (id_alumno)
        REFERENCES alumnos(id_alumno)
);


-- ============================================================
-- 24. RETIRO DE MENORES
-- ============================================================

CREATE TABLE retiro_menor (
    id_retiro INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,

    id_alumno INTEGER NOT NULL,
    id_autorizada INTEGER NOT NULL,
    id_profesor INTEGER NOT NULL,

    fecha_hora TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_retiro_alumno
        FOREIGN KEY (id_alumno)
        REFERENCES alumnos(id_alumno),

    CONSTRAINT fk_retiro_autorizada
        FOREIGN KEY (id_autorizada)
        REFERENCES persona_autorizada(id_autorizada),

    CONSTRAINT fk_retiro_profesor
        FOREIGN KEY (id_profesor)
        REFERENCES profesores(id_profesor)
);


-- ============================================================
-- ÍNDICES
-- ============================================================

CREATE INDEX idx_inscripcion_alumno
    ON inscripcion(id_alumno);

CREATE INDEX idx_inscripcion_grupo
    ON inscripcion(id_grupo);

CREATE INDEX idx_clase_fecha
    ON clase(fecha);

CREATE INDEX idx_clase_grupo
    ON clase(id_grupo);

CREATE INDEX idx_asistencia_clase
    ON asistencia(id_clase);

CREATE INDEX idx_asistencia_alumno
    ON asistencia(id_alumno);

CREATE INDEX idx_pago_estado
    ON pago(estado);

CREATE INDEX idx_compra_creditos_alumno
    ON compra_creditos(id_alumno);

CREATE INDEX idx_movimiento_credito_alumno
    ON movimiento_credito(id_alumno);

CREATE INDEX idx_reserva_alumno
    ON reserva(id_alumno);

CREATE INDEX idx_reserva_clase
    ON reserva(id_clase);

CREATE INDEX idx_liquidacion_profesor
    ON liquidacion_profesor(id_profesor);


-- ============================================================
-- DATOS INICIALES
-- ============================================================

INSERT INTO roles (rol)
VALUES
    ('Administrador'),
    ('Alumno'),
    ('Profesor');


INSERT INTO tipos_clase (tipo, descripcion)
VALUES
    (
        'Libre',
        'Clase libre a la que el alumno puede reservar individualmente'
    ),
    (
        'Coreografica',
        'Clase perteneciente a un grupo coreográfico'
    ),
    (
        'Grupo',
        'Clase correspondiente a un grupo regular'
    );


INSERT INTO tipos_credito (nombre, descripcion)
VALUES
    (
        'Libre',
        'Créditos utilizables en clases libres'
    ),
    (
        'Coreografico',
        'Créditos utilizables en clases coreográficas'
    );


INSERT INTO paquetes_creditos (
    id_tipo_credito,
    nombre,
    cantidad_creditos,
    precio
)
VALUES
    (
        1,
        'Clase Libre Individual',
        1,
        5000
    ),
    (
        1,
        'Pack 15 Clases Libres',
        15,
        50000
    );


INSERT INTO reglas_pago_profesor (
    porcentaje_profesor,
    porcentaje_academia,
    fecha_inicio
)
VALUES (
    30,
    70,
    CURRENT_DATE
);


-- ============================================================
-- VERIFICACIÓN
-- ============================================================

SELECT table_name
FROM information_schema.tables
WHERE table_schema = 'public'
ORDER BY table_name;