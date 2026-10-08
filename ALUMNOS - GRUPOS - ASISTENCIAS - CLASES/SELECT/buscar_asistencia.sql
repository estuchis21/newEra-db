CREATE OR REPLACE FUNCTION buscar_asistencia(
    p_id_alumno INTEGER,
    p_id_clase INTEGER
)
RETURNS asistencia
LANGUAGE plpgsql
AS $$
DECLARE
    v_asistencia asistencia;
BEGIN

    SELECT *
    INTO v_asistencia
    FROM asistencia
    WHERE id_alumno = p_id_alumno
    AND id_clase = p_id_clase;

    RETURN v_asistencia;

END;
$$;