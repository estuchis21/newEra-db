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

    email VARCHAR(200) NOT NULL UNIQUE,

    contrasena VARCHAR(300) NOT NULL,

    username VARCHAR(100) NOT NULL UNIQUE,

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

    id_usuario INTEGER NOT NULL UNIQUE,

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

    id_usuario INTEGER NOT NULL UNIQUE,

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

    cupo_max INTEGER NOT NULL,

    activo BOOLEAN NOT NULL DEFAULT TRUE,

    CONSTRAINT chk_grupo_cupo
        CHECK (cupo_max > 0),

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

    CONSTRAINT chk_horario
        CHECK (hora_fin > hora_inicio),

    CONSTRAINT fk_horario_grupo
        FOREIGN KEY (id_grupo)
        REFERENCES grupos(id_grupo)
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
        REFERENCES grupos(id_grupo),

    CONSTRAINT uq_inscripcion_alumno_grupo
        UNIQUE (id_alumno, id_grupo)
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

    cantidad_creditos INTEGER NOT NULL,

    precio NUMERIC(10,2) NOT NULL,

    activo BOOLEAN NOT NULL DEFAULT TRUE,

    CONSTRAINT chk_paquete_creditos
        CHECK (cantidad_creditos > 0),

    CONSTRAINT chk_paquete_precio
        CHECK (precio >= 0),

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

    CONSTRAINT chk_clase_horario
        CHECK (hora_fin > hora_inicio),

    CONSTRAINT fk_clase_grupo
        FOREIGN KEY (id_grupo)
        REFERENCES grupos(id_grupo),

    CONSTRAINT fk_clase_tipo
        FOREIGN KEY (id_tipo_clase)
        REFERENCES tipos_clase(id_tipo_clase)
);


-- ============================================================
-- 13. COMPRAS DE CRÉDITOS
-- ============================================================

CREATE TABLE compra_creditos (
    id_compra INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,

    id_alumno INTEGER NOT NULL,

    id_paquete INTEGER NOT NULL,

    cantidad_creditos INTEGER NOT NULL,

    precio_pagado NUMERIC(10,2) NOT NULL,

    fecha_compra TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    estado VARCHAR(50) NOT NULL DEFAULT 'Pagado',

    CONSTRAINT chk_compra_creditos
        CHECK (cantidad_creditos > 0),

    CONSTRAINT chk_compra_precio
        CHECK (precio_pagado >= 0),

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

    CONSTRAINT chk_movimiento_cantidad
        CHECK (cantidad <> 0),

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

    monto_base NUMERIC(10,2) NOT NULL,

    porcentaje NUMERIC(5,2) NOT NULL,

    monto_profesor NUMERIC(10,2) NOT NULL,

    monto_academia NUMERIC(10,2) NOT NULL,

    fecha_generacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    estado VARCHAR(30) NOT NULL DEFAULT 'Pendiente',

    CONSTRAINT chk_liquidacion_monto_base
        CHECK (monto_base >= 0),

    CONSTRAINT chk_liquidacion_porcentaje
        CHECK (porcentaje >= 0),

    CONSTRAINT chk_liquidacion_profesor
        CHECK (monto_profesor >= 0),

    CONSTRAINT chk_liquidacion_academia
        CHECK (monto_academia >= 0),

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

    monto NUMERIC(10,2) NOT NULL,

    vencimiento DATE NOT NULL,

    estado VARCHAR(50) NOT NULL DEFAULT 'Pendiente',

    CONSTRAINT chk_cuota_monto
        CHECK (monto >= 0),

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

    monto NUMERIC(10,2) NOT NULL,

    fecha_pago TIMESTAMP,

    estado VARCHAR(50),

    id_mercado_pago BIGINT UNIQUE,

    metodo_pago VARCHAR(50),

    detalle TEXT,

    CONSTRAINT chk_pago_monto
        CHECK (monto >= 0),

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

CREATE INDEX idx_users_email
ON users(email);

CREATE INDEX idx_users_rol
ON users(id_rol);

CREATE INDEX idx_inscripcion_alumno
ON inscripcion(id_alumno);

CREATE INDEX idx_inscripcion_grupo
ON inscripcion(id_grupo);

CREATE INDEX idx_horario_grupo
ON horario_grupo(id_grupo);

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

CREATE INDEX idx_pago_cuota
ON pago(id_cuota);

CREATE INDEX idx_compra_creditos_alumno
ON compra_creditos(id_alumno);

CREATE INDEX idx_movimiento_credito_alumno
ON movimiento_credito(id_alumno);

CREATE INDEX idx_movimiento_credito_tipo
ON movimiento_credito(id_tipo_credito);

CREATE INDEX idx_reserva_alumno
ON reserva(id_alumno);

CREATE INDEX idx_reserva_clase
ON reserva(id_clase);

CREATE INDEX idx_liquidacion_profesor
ON liquidacion_profesor(id_profesor);

CREATE INDEX idx_liquidacion_estado
ON liquidacion_profesor(estado);


-- ============================================================
-- DATOS INICIALES
-- ============================================================


-- ============================================================
-- ROLES
-- ============================================================

INSERT INTO roles (rol)
VALUES
    ('Administrador'),
    ('Alumno'),
    ('Profesor');


-- ============================================================
-- TIPOS DE CLASE
-- ============================================================

INSERT INTO tipos_clase (
    tipo,
    descripcion
)
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


-- ============================================================
-- TIPOS DE CRÉDITO
-- ============================================================

INSERT INTO tipos_credito (
    nombre,
    descripcion
)
VALUES
(
    'Libre',
    'Créditos utilizables en clases libres'
),
(
    'Coreografico',
    'Créditos utilizables en clases coreográficas'
);


-- ============================================================
-- PAQUETES DE CRÉDITOS
-- ============================================================

-- CLASES LIBRES

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


-- CLASES COREOGRÁFICAS

INSERT INTO paquetes_creditos (
    id_tipo_credito,
    nombre,
    cantidad_creditos,
    precio
)
VALUES
(
    2,
    'Clase Coreográfica Individual',
    1,
    5000
),
(
    2,
    'Pack 15 Clases Coreográficas',
    15,
    50000
);


-- ============================================================
-- REGLA DE PAGO A PROFESORES
-- ============================================================

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
-- PROCEDURE:
-- COMPRAR CRÉDITOS
-- ============================================================

CREATE OR REPLACE PROCEDURE comprar_creditos (
    p_id_alumno INTEGER,
    p_id_paquete INTEGER
)
LANGUAGE plpgsql
AS $$
DECLARE

    v_tipo_credito INTEGER;

    v_cantidad_creditos INTEGER;

    v_precio NUMERIC(10,2);

    v_id_compra INTEGER;

BEGIN

    -- ========================================================
    -- Buscar paquete
    -- ========================================================

    SELECT
        id_tipo_credito,
        cantidad_creditos,
        precio

    INTO
        v_tipo_credito,
        v_cantidad_creditos,
        v_precio

    FROM paquetes_creditos

    WHERE id_paquete = p_id_paquete
      AND activo = TRUE;


    IF NOT FOUND THEN

        RAISE EXCEPTION
            'El paquete de créditos no existe o está inactivo';

    END IF;


    -- ========================================================
    -- Verificar alumno
    -- ========================================================

    IF NOT EXISTS (
        SELECT 1
        FROM alumnos
        WHERE id_alumno = p_id_alumno
    ) THEN

        RAISE EXCEPTION
            'El alumno % no existe',
            p_id_alumno;

    END IF;


    -- ========================================================
    -- Registrar compra
    -- ========================================================

    INSERT INTO compra_creditos (
        id_alumno,
        id_paquete,
        cantidad_creditos,
        precio_pagado,
        estado
    )
    VALUES (
        p_id_alumno,
        p_id_paquete,
        v_cantidad_creditos,
        v_precio,
        'Pagado'
    )

    RETURNING id_compra
    INTO v_id_compra;


    -- ========================================================
    -- Registrar movimiento de créditos
    -- ========================================================

    INSERT INTO movimiento_credito (
        id_alumno,
        id_tipo_credito,
        id_compra,
        cantidad,
        tipo,
        descripcion
    )
    VALUES (
        p_id_alumno,
        v_tipo_credito,
        v_id_compra,
        v_cantidad_creditos,
        'COMPRA',
        'Compra de paquete de créditos'
    );


END;
$$;


-- ============================================================
-- PROCEDURE:
-- RESERVAR CLASE Y CONSUMIR CRÉDITO
-- ============================================================

CREATE OR REPLACE PROCEDURE reservar_clase (
    p_id_alumno INTEGER,
    p_id_clase INTEGER
)
LANGUAGE plpgsql
AS $$
DECLARE

    v_tipo_clase VARCHAR(50);

    v_tipo_credito INTEGER;

    v_creditos_disponibles INTEGER;

    v_id_movimiento INTEGER;

    v_id_reserva INTEGER;

BEGIN

    -- ========================================================
    -- Buscar tipo de clase
    -- ========================================================

    SELECT
        tc.tipo

    INTO
        v_tipo_clase

    FROM clase c

    INNER JOIN tipos_clase tc
        ON tc.id_tipo_clase = c.id_tipo_clase

    WHERE c.id_clase = p_id_clase;


    IF NOT FOUND THEN

        RAISE EXCEPTION
            'La clase % no existe',
            p_id_clase;

    END IF;


    -- ========================================================
    -- Determinar tipo de crédito
    -- ========================================================

    IF v_tipo_clase = 'Libre' THEN

        SELECT id_tipo_credito
        INTO v_tipo_credito

        FROM tipos_credito

        WHERE nombre = 'Libre';


    ELSIF v_tipo_clase IN ('Coreografica', 'Grupo') THEN

        SELECT id_tipo_credito
        INTO v_tipo_credito

        FROM tipos_credito

        WHERE nombre = 'Coreografico';


    ELSE

        RAISE EXCEPTION
            'Tipo de clase no soportado: %',
            v_tipo_clase;

    END IF;


    -- ========================================================
    -- Verificar que no exista reserva
    -- ========================================================

    IF EXISTS (
        SELECT 1
        FROM reserva
        WHERE id_alumno = p_id_alumno
          AND id_clase = p_id_clase
          AND estado <> 'Cancelada'
    ) THEN

        RAISE EXCEPTION
            'El alumno ya está reservado en esta clase';

    END IF;


    -- ========================================================
    -- Buscar créditos disponibles
    -- ========================================================

    SELECT
        COALESCE(
            SUM(cantidad),
            0
        )

    INTO
        v_creditos_disponibles

    FROM movimiento_credito

    WHERE id_alumno = p_id_alumno

      AND id_tipo_credito = v_tipo_credito;


    -- ========================================================
    -- Verificar saldo
    -- ========================================================

    IF v_creditos_disponibles <= 0 THEN

        RAISE EXCEPTION
            'El alumno no tiene créditos disponibles';

    END IF;


    -- ========================================================
    -- Consumir crédito
    -- ========================================================

    INSERT INTO movimiento_credito (
        id_alumno,
        id_tipo_credito,
        cantidad,
        tipo,
        descripcion
    )
    VALUES (
        p_id_alumno,
        v_tipo_credito,
        -1,
        'CONSUMO',
        'Consumo de crédito por reserva de clase'
    )

    RETURNING id_movimiento
    INTO v_id_movimiento;


    -- ========================================================
    -- Crear reserva
    -- ========================================================

    INSERT INTO reserva (
        id_alumno,
        id_clase,
        id_movimiento_credito,
        estado
    )
    VALUES (
        p_id_alumno,
        p_id_clase,
        v_id_movimiento,
        'Reservada'
    )

    RETURNING id_reserva
    INTO v_id_reserva;


END;
$$;


-- ============================================================
-- PROCEDURE:
-- CANCELAR RESERVA Y DEVOLVER CRÉDITO
-- ============================================================

CREATE OR REPLACE PROCEDURE cancelar_reserva (
    p_id_reserva INTEGER
)
LANGUAGE plpgsql
AS $$
DECLARE

    v_id_alumno INTEGER;

    v_id_tipo_credito INTEGER;

BEGIN

    -- ========================================================
    -- Buscar reserva
    -- ========================================================

    SELECT
        r.id_alumno,
        mc.id_tipo_credito

    INTO
        v_id_alumno,
        v_id_tipo_credito

    FROM reserva r

    INNER JOIN movimiento_credito mc
        ON mc.id_movimiento = r.id_movimiento_credito

    WHERE r.id_reserva = p_id_reserva

      AND r.estado <> 'Cancelada';


    IF NOT FOUND THEN

        RAISE EXCEPTION
            'La reserva no existe o ya fue cancelada';

    END IF;


    -- ========================================================
    -- Cancelar reserva
    -- ========================================================

    UPDATE reserva

    SET estado = 'Cancelada'

    WHERE id_reserva = p_id_reserva;


    -- ========================================================
    -- Devolver crédito
    -- ========================================================

    INSERT INTO movimiento_credito (
        id_alumno,
        id_tipo_credito,
        cantidad,
        tipo,
        descripcion
    )
    VALUES (
        v_id_alumno,
        v_id_tipo_credito,
        1,
        'DEVOLUCION',
        'Devolución de crédito por cancelación de reserva'
    );


END;
$$;


-- ============================================================
-- PROCEDURE:
-- CREAR INSCRIPCIÓN A GRUPO COREOGRÁFICO
-- ============================================================

CREATE OR REPLACE PROCEDURE crear_inscripcion (
    p_id_alumno INTEGER,
    p_id_grupo INTEGER
)
LANGUAGE plpgsql
AS $$
DECLARE

    v_id_tipo_credito INTEGER;

    v_creditos_disponibles INTEGER;

BEGIN

    -- ========================================================
    -- Verificar grupo
    -- ========================================================

    IF NOT EXISTS (
        SELECT 1
        FROM grupos
        WHERE id_grupo = p_id_grupo
          AND activo = TRUE
    ) THEN

        RAISE EXCEPTION
            'El grupo % no existe o está inactivo',
            p_id_grupo;

    END IF;


    -- ========================================================
    -- Verificar que no esté inscripto
    -- ========================================================

    IF EXISTS (
        SELECT 1
        FROM inscripcion
        WHERE id_alumno = p_id_alumno
          AND id_grupo = p_id_grupo
          AND estado = 'Activo'
    ) THEN

        RAISE EXCEPTION
            'El alumno ya está inscripto en este grupo';

    END IF;


    -- ========================================================
    -- Buscar tipo de crédito
    -- ========================================================

    SELECT id_tipo_credito

    INTO v_id_tipo_credito

    FROM tipos_credito

    WHERE nombre = 'Coreografico';


    -- ========================================================
    -- Verificar créditos
    -- ========================================================

    SELECT
        COALESCE(
            SUM(cantidad),
            0
        )

    INTO
        v_creditos_disponibles

    FROM movimiento_credito

    WHERE id_alumno = p_id_alumno
      AND id_tipo_credito = v_id_tipo_credito;


    IF v_creditos_disponibles <= 0 THEN

        RAISE EXCEPTION
            'El alumno no tiene créditos coreográficos disponibles';

    END IF;


    -- ========================================================
    -- Crear inscripción
    -- ========================================================

    INSERT INTO inscripcion (
        id_alumno,
        id_grupo,
        estado
    )
    VALUES (
        p_id_alumno,
        p_id_grupo,
        'Activo'
    );


    -- ========================================================
    -- Consumir crédito
    -- ========================================================

    INSERT INTO movimiento_credito (
        id_alumno,
        id_tipo_credito,
        cantidad,
        tipo,
        descripcion
    )
    VALUES (
        p_id_alumno,
        v_id_tipo_credito,
        -1,
        'CONSUMO',
        'Consumo de crédito por inscripción a grupo coreográfico'
    );

END;
$$;


-- ============================================================
-- FUNCIÓN:
-- CONSULTAR SALDO DE CRÉDITOS DE UN ALUMNO
-- ============================================================

CREATE OR REPLACE FUNCTION obtener_creditos_alumno (
    p_id_alumno INTEGER
)
RETURNS TABLE (
    id_tipo_credito INTEGER,
    tipo_credito VARCHAR(50),
    creditos_disponibles BIGINT
)
LANGUAGE sql
AS $$
    SELECT
        tc.id_tipo_credito,
        tc.nombre,
        COALESCE(
            SUM(mc.cantidad),
            0
        ) AS creditos_disponibles

    FROM tipos_credito tc

    LEFT JOIN movimiento_credito mc
        ON mc.id_tipo_credito = tc.id_tipo_credito
        AND mc.id_alumno = p_id_alumno

    WHERE tc.activo = TRUE

    GROUP BY
        tc.id_tipo_credito,
        tc.nombre

    ORDER BY
        tc.id_tipo_credito;
$$;


-- ============================================================
-- FUNCIÓN:
-- OBTENER DISCIPLINAS
-- ============================================================

CREATE OR REPLACE FUNCTION obtenerDisciplinas()
RETURNS TABLE (
    id_disciplina INTEGER,
    disciplina VARCHAR
)
LANGUAGE plpgsql
AS $$
BEGIN

    RETURN QUERY

    SELECT
        d.id_disciplina,
        d.disciplina

    FROM disciplinas d

    ORDER BY d.id_disciplina;

END;
$$;


-- ============================================================
-- VERIFICACIÓN DE TABLAS
-- ============================================================

SELECT
    table_name

FROM information_schema.tables

WHERE table_schema = 'public'

ORDER BY table_name;


-- ============================================================
-- VERIFICACIÓN DE ROLES
-- ============================================================

SELECT *
FROM roles;


-- ============================================================
-- VERIFICACIÓN DE TIPOS DE CLASE
-- ============================================================

SELECT *
FROM tipos_clase;


-- ============================================================
-- VERIFICACIÓN DE TIPOS DE CRÉDITO
-- ============================================================

SELECT *
FROM tipos_credito;


-- ============================================================
-- VERIFICACIÓN DE PAQUETES
-- ============================================================

SELECT
    pc.id_paquete,
    tc.nombre AS tipo_credito,
    pc.nombre AS paquete,
    pc.cantidad_creditos,
    pc.precio,
    pc.activo

FROM paquetes_creditos pc

INNER JOIN tipos_credito tc
    ON tc.id_tipo_credito = pc.id_tipo_credito

ORDER BY pc.id_paquete;


-- ============================================================
-- VERIFICACIÓN DE REGLAS DE PROFESORES
-- ============================================================

SELECT *
FROM reglas_pago_profesor;