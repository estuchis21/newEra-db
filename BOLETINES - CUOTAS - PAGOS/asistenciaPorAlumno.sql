CREATE OR REPLACE FUNCTION obtener_asistencia_alumno(p_alumno_id INTEGER)
RETURNS TABLE (
    fecha DATE,
    estado TEXT
)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT
        c.fecha,
        a.estado
    FROM asistencias a
    INNER JOIN Clase c
        ON c.id = a.clase_id
    WHERE a.alumno_id = p_alumno_id
    ORDER BY c.fecha;
END;
$$;