CREATE OR REPLACE FUNCTION proximas_clases_alumno (
    p_id_alumno INT
)
RETURNS TABLE (
    disciplina VARCHAR,
    nombre VARCHAR,
    apellido VARCHAR,
    tipo_clase VARCHAR,
    fecha_clase DATE,
    hora_inicio TIME,
    hora_fin TIME,
    estado_clase VARCHAR
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
        c.hora_fin,
        c.estado
    FROM reserva r
    JOIN alumnos al
        ON al.id_alumno = r.id_alumno
    JOIN users u
        ON u.id_usuario = al.id_usuario
    JOIN clase c
        ON c.id_clase = r.id_clase
    JOIN tipos_clase tc
        ON tc.id_tipo_clase = c.id_tipo_clase
    LEFT JOIN grupos g
        ON g.id_grupo = c.id_grupo
    LEFT JOIN disciplinas d
        ON d.id_disciplina = g.id_disciplina
    WHERE r.id_alumno = p_id_alumno
      AND c.fecha >= CURRENT_DATE
      AND r.estado IN ('Reservada', 'Confirmada')
    ORDER BY c.fecha ASC, c.hora_inicio ASC;

END;
$$;