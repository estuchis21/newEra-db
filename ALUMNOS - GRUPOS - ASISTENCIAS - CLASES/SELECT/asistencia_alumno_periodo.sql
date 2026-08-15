CREATE OR REPLACE FUNCTION asistencia_alumno_periodo (
    p_fecha_inicio DATE,
    p_fecha_fin DATE,
    p_id_alumno INT
)
RETURNS TABLE (
    disciplina VARCHAR,
    nombre VARCHAR,
    apellido VARCHAR,
    tipo_clase VARCHAR,
    fecha_clase DATE,
    hora_inicio TIME,
    estado VARCHAR,
    observaciones TEXT
)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT
        d.disciplina,
        u.nombre,
        u.apellido,
        tc.tipo,
        c.fecha,
        c.hora_inicio,
        a.estado,
        a.observaciones
    FROM asistencia a
    JOIN alumnos al
        ON al.id_alumno = a.id_alumno
    JOIN users u
        ON u.id_usuario = al.id_usuario
    JOIN clase c
        ON c.id_clase = a.id_clase
    JOIN tipos_clase tc
        ON tc.id_tipo_clase = c.id_tipo_clase
    LEFT JOIN grupos g
        ON g.id_grupo = c.id_grupo
    LEFT JOIN disciplinas d
        ON d.id_disciplina = g.id_disciplina
    WHERE a.id_alumno = p_id_alumno
      AND c.fecha >= p_fecha_inicio
      AND c.fecha <= p_fecha_fin;
END;
$$;