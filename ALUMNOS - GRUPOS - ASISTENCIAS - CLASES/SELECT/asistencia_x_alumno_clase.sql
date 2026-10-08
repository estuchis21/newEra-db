CREATE OR REPLACE FUNCTION asistencia_x_alumno_clase (
    p_id_alumno INT,
    p_id_clase INT
)
RETURNS TABLE (
    disciplina VARCHAR,
    nombre_alumno VARCHAR,
    estado VARCHAR,
    observaciones TEXT
)
LANGUAGE SQL
AS $$
    SELECT
        d.disciplina,
        u.nombre,
        a.estado,
        a.observaciones
    FROM asistencia a
    JOIN alumnos al
        ON al.id_alumno = a.id_alumno
    JOIN users u
        ON u.id_usuario = al.id_usuario
    JOIN clase c
        ON c.id_clase = a.id_clase
    LEFT JOIN grupos g
        ON c.id_grupo = g.id_grupo
    LEFT JOIN disciplinas d
        ON d.id_disciplina = g.id_disciplina
    WHERE a.id_alumno = p_id_alumno
      AND a.id_clase = p_id_clase;
$$;