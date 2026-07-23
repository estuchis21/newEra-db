CREATE OR REPLACE PROCEDURE registrar_asistencia(
    p_id_alumno INTEGER,
    p_id_clase INTEGER,
    p_estado VARCHAR(50),
    p_observaciones TEXT DEFAULT NULL
)
LANGUAGE plpgsql
AS $$
BEGIN

    INSERT INTO asistencia(
        id_alumno,
        id_clase,
        estado,
        observaciones
    )
    VALUES(
        p_id_alumno,
        p_id_clase,
        p_estado,
        p_observaciones
    );

END;
$$;