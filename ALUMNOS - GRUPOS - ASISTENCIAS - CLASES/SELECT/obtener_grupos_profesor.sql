CREATE OR REPLACE FUNCTION obtener_grupos_profesor(
    p_id_profesor INTEGER
)
RETURNS TABLE (
    id_grupo INTEGER,
    id_disciplina INTEGER,
    disciplina VARCHAR,
    nivel VARCHAR,
    cupo_max INTEGER,
    activo BOOLEAN,
    dia_semana VARCHAR,
    hora_inicio TIME,
    hora_fin TIME
)
LANGUAGE plpgsql
AS $$
BEGIN

    RETURN QUERY

    SELECT
        g.id_grupo,
        d.id_disciplina,
        d.disciplina,
        g.nivel,
        g.cupo_max,
        g.activo,
        hg.dia_semana,
        hg.hora_inicio,
        hg.hora_fin

    FROM grupos g

    INNER JOIN disciplinas d
        ON d.id_disciplina = g.id_disciplina

    LEFT JOIN horario_grupo hg
        ON hg.id_grupo = g.id_grupo

    WHERE g.id_profesor = p_id_profesor

    ORDER BY
        g.id_grupo,
        hg.dia_semana,
        hg.hora_inicio;

END;
$$;