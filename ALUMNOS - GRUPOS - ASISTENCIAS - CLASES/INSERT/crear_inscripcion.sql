CREATE OR REPLACE PROCEDURE crear_inscripcion(
    p_id_alumno INTEGER,
    p_id_grupo INTEGER
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_id_tipo_credito INTEGER;
    v_creditos INTEGER;
    v_cupo_max INTEGER;
    v_inscriptos INTEGER;
BEGIN

    -- ==========================================
    -- Verificar que el grupo exista y esté activo
    -- ==========================================

    SELECT cupo_max
    INTO v_cupo_max
    FROM grupos
    WHERE id_grupo = p_id_grupo
      AND activo = TRUE;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'El grupo % no existe o no está activo', p_id_grupo;
    END IF;


    -- ==========================================
    -- Verificar que el alumno exista
    -- ==========================================

    IF NOT EXISTS (
        SELECT 1
        FROM alumnos
        WHERE id_alumno = p_id_alumno
    ) THEN
        RAISE EXCEPTION 'El alumno % no existe', p_id_alumno;
    END IF;


    -- ==========================================
    -- Verificar que no esté ya inscripto
    -- ==========================================

    IF EXISTS (
        SELECT 1
        FROM inscripcion
        WHERE id_alumno = p_id_alumno
          AND id_grupo = p_id_grupo
          AND estado = 'Activo'
    ) THEN
        RAISE EXCEPTION 'El alumno ya está inscripto en este grupo';
    END IF;


    -- ==========================================
    -- Verificar cupo
    -- ==========================================

    SELECT COUNT(*)
    INTO v_inscriptos
    FROM inscripcion
    WHERE id_grupo = p_id_grupo
      AND estado = 'Activo';

    IF v_inscriptos >= v_cupo_max THEN
        RAISE EXCEPTION 'El grupo no tiene cupos disponibles';
    END IF;


    -- ==========================================
    -- Obtener tipo de crédito Coreografico
    -- ==========================================

    SELECT id_tipo_credito
    INTO v_id_tipo_credito
    FROM tipos_credito
    WHERE nombre = 'Coreografico';

    IF NOT FOUND THEN
        RAISE EXCEPTION 'No existe el tipo de crédito Coreografico';
    END IF;


    -- ==========================================
    -- Obtener saldo de créditos
    -- ==========================================

    SELECT COALESCE(SUM(cantidad), 0)
    INTO v_creditos
    FROM movimiento_credito
    WHERE id_alumno = p_id_alumno
      AND id_tipo_credito = v_id_tipo_credito;


    IF v_creditos <= 0 THEN
        RAISE EXCEPTION 'El alumno no tiene créditos Coreograficos disponibles';
    END IF;


    -- ==========================================
    -- Crear inscripción
    -- ==========================================

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


    -- ==========================================
    -- Consumir 1 crédito
    -- ==========================================

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