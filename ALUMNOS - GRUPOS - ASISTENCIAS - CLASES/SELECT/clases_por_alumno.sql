CREATE OR REPLACE FUNCTION clases_por_alumno(
    p_id_alumno INTEGER
)
RETURNS TABLE(
    fecha DATE,
    inicio TIME,
    fin TIME
)
LANGUAGE sql
AS $$
    SELECT
        c.fecha,
        c.hora_inicio,
        c.hora_fin
    FROM clase c
    INNER JOIN grupos g
        ON c.id_grupo = g.id_grupo
    INNER JOIN inscripcion i
        ON g.id_grupo = i.id_grupo
    WHERE i.id_alumno = p_id_alumno;
$$;