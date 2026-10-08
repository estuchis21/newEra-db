CREATE OR REPLACE FUNCTION porcentaje_asistencia_alumno (
    p_id_alumno INT
)
RETURNS TABLE (
    nombre VARCHAR,
    apellido VARCHAR,
    total_clases NUMERIC(10,2),
    clases_asistidas NUMERIC(10,2),
    clases_ausentes NUMERIC(10,2),
    porcentaje_asistencia NUMERIC(10,2),
    porcentaje_ausencia NUMERIC(10,2)
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_total_clases NUMERIC(10,2);
    v_clases_asistidas NUMERIC(10,2);
    v_clases_ausentes NUMERIC(10,2);
    v_porcentaje_asistencia NUMERIC(10,2);
    v_porcentaje_ausencia NUMERIC(10,2);

BEGIN

    SELECT COUNT(*)
    INTO v_total_clases
    FROM asistencia
    WHERE id_alumno = p_id_alumno;


    SELECT COUNT(*) FILTER (WHERE estado = 'Asistío')
    INTO v_clases_asistidas
    FROM asistencia
    WHERE id_alumno = p_id_alumno;


    SELECT COUNT(*) FILTER (WHERE estado = 'No Asistiío')
    INTO v_clases_ausentes
    FROM asistencia
    WHERE id_alumno = p_id_alumno;


    IF v_total_clases <= 0 THEN
        RAISE EXCEPTION 'NO SE PUEDE DIVIDIR POR CERO';
    END IF;


    v_porcentaje_asistencia :=
        (v_clases_asistidas / v_total_clases) * 100;

    v_porcentaje_ausencia :=
        (v_clases_ausentes / v_total_clases) * 100;


    RETURN QUERY
    SELECT
        u.nombre,
        u.apellido,
        v_total_clases,
        v_clases_asistidas,
        v_clases_ausentes,
        v_porcentaje_asistencia,
        v_porcentaje_ausencia
    FROM alumnos al
    JOIN users u
        ON u.id_usuario = al.id_usuario
    WHERE al.id_alumno = p_id_alumno;

END;
$$;