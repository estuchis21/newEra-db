-- ============================================================
-- FUNCIÓN:
-- CLASES POR PROFESOR
-- ============================================================

CREATE OR REPLACE FUNCTION clases_por_profesor (
    p_id_profesor INTEGER,
    p_fecha DATE DEFAULT NULL
)
RETURNS TABLE (
    id_clase INTEGER,
    id_grupo INTEGER,
    disciplina VARCHAR,
    nivel VARCHAR,
    tipo_clase VARCHAR,
    fecha DATE,
    hora_inicio TIME,
    hora_fin TIME,
    estado VARCHAR
)
LANGUAGE sql
AS $$
    SELECT
        c.id_clase,
        g.id_grupo,
        d.disciplina,
        g.nivel,
        tc.tipo,
        c.fecha,
        c.hora_inicio,
        c.hora_fin,
        c.estado

    FROM clase c

    INNER JOIN grupos g
        ON g.id_grupo = c.id_grupo

    INNER JOIN disciplinas d
        ON d.id_disciplina = g.id_disciplina

    INNER JOIN tipos_clase tc
        ON tc.id_tipo_clase = c.id_tipo_clase

    WHERE g.id_profesor = p_id_profesor
      AND (p_fecha IS NULL OR c.fecha = p_fecha)

    ORDER BY c.fecha, c.hora_inicio;
$$;