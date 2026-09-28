CREATE OR REPLACE FUNCTION grupos_disponibles()
RETURNS TABLE (
    id_grupo INT,
    nombre VARCHAR,
    cupo_maximo INT,
    id_disciplina INT
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        g.id_grupo,
        (d.disciplina || ' - ' || g.nivel)::VARCHAR AS nombre,
        g.cupo_max AS cupo_maximo,
        g.id_disciplina
    FROM grupos g
    JOIN disciplinas d ON g.id_disciplina = d.id_disciplina
    WHERE g.activo = TRUE;
END;
$$ LANGUAGE plpgsql;

ALTER FUNCTION grupos_disponibles() OWNER TO academia_backend;