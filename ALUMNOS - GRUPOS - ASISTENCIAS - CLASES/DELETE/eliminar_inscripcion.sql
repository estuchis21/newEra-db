CREATE OR REPLACE PROCEDURE eliminar_inscripcion(
    p_id_inscripcion INTEGER
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_id_alumno INTEGER;
    v_id_tipo_credito INTEGER;
BEGIN

    -- ==========================================
    -- Buscar inscripción activa
    -- ==========================================

    SELECT id_alumno
    INTO v_id_alumno
    FROM inscripcion
    WHERE id_inscripcion = p_id_inscripcion
      AND estado = 'Activo';

    IF NOT FOUND THEN
        RAISE EXCEPTION
            'La inscripción % no existe o no está activa',
            p_id_inscripcion;
    END IF;


    -- ==========================================
    -- Verificar pagos asociados
    -- ==========================================

    IF EXISTS (
        SELECT 1
        FROM pago
        WHERE id_inscripcion = p_id_inscripcion
    ) THEN
        RAISE EXCEPTION
            'No se puede eliminar la inscripción % porque tiene pagos asociados',
            p_id_inscripcion;
    END IF;


    -- ==========================================
    -- Obtener tipo de crédito
    -- ==========================================

    SELECT id_tipo_credito
    INTO v_id_tipo_credito
    FROM tipos_credito
    WHERE nombre = 'Coreografico';

    IF NOT FOUND THEN
        RAISE EXCEPTION
            'No existe el tipo de crédito Coreografico';
    END IF;


    -- ==========================================
    -- Eliminar inscripción
    -- ==========================================

    DELETE FROM inscripcion
    WHERE id_inscripcion = p_id_inscripcion;


    -- ==========================================
    -- Devolver el crédito
    -- ==========================================

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
        'Devolución de crédito por eliminación de inscripción'
    );

END;
$$;