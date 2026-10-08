CREATE OR REPLACE FUNCTION clases_por_alumno(
    p_id_alumno INTEGER
)
RETURNS TABLE (
    id_inscripcion INTEGER,
    id_alumno INTEGER,
    id_grupo INTEGER,
    id_disciplina INTEGER,
    disciplina VARCHAR,
    nivel VARCHAR,
    cupo_max INTEGER,
    activo BOOLEAN,
    estado VARCHAR
)
LANGUAGE plpgsql
AS $$
BEGIN

    RETURN QUERY
    SELECT
        i.id_inscripcion,
        i.id_alumno,
        g.id_grupo,
        g.id_disciplina,
        d.disciplina,
        g.nivel,
        g.cupo_max,
        g.activo,
        i.estado
    FROM inscripcion i
    INNER JOIN grupos g
        ON g.id_grupo = i.id_grupo
    INNER JOIN disciplinas d
        ON d.id_disciplina = g.id_disciplina
    WHERE i.id_alumno = p_id_alumno
      AND i.estado = 'Activo'
    ORDER BY d.disciplina, g.nivel;

END;
$$;