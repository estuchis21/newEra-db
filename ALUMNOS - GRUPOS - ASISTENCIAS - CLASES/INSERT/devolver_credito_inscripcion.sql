CREATE OR REPLACE FUNCTION devolver_credito_inscripcion()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
DECLARE
    v_id_tipo_credito INTEGER;
BEGIN

    -- Buscar el tipo de crédito Coreografico
    SELECT id_tipo_credito
    INTO v_id_tipo_credito
    FROM tipos_credito
    WHERE nombre = 'Coreografico';

    -- Devolver el crédito utilizado por la inscripción
    INSERT INTO movimiento_credito (
        id_alumno,
        id_tipo_credito,
        cantidad,
        tipo,
        descripcion
    )
    VALUES (
        OLD.id_alumno,
        v_id_tipo_credito,
        1,
        'DEVOLUCION',
        'Devolución de crédito por eliminación de inscripción'
    );

    RETURN OLD;

END;
$$;


DROP TRIGGER IF EXISTS trg_devolver_credito_inscripcion
ON inscripcion;

CREATE TRIGGER trg_devolver_credito_inscripcion
AFTER DELETE ON inscripcion
FOR EACH ROW
EXECUTE FUNCTION devolver_credito_inscripcion();