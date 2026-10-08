CREATE OR REPLACE FUNCTION obtener_id_alumno_por_usuario(p_id_usuario INTEGER)
RETURNS INTEGER
LANGUAGE plpgsql
AS $$
DECLARE
    v_id_alumno INTEGER;
BEGIN
    SELECT id_alumno
    INTO v_id_alumno
    FROM alumnos
    WHERE id_usuario = p_id_usuario;

    RETURN v_id_alumno;
END;
$$;