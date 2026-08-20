CREATE OR REPLACE FUNCTION inscripciones_por_alumno(
    p_id_alumno INTEGER
)
RETURNS TABLE(
    id_inscripcion INTEGER,
    id_grupo INTEGER,
    disciplina VARCHAR(100),
    nivel VARCHAR(50),
    id_profesor INTEGER,
    nombre_profesor VARCHAR(100),
    apellido_profesor VARCHAR(100),
    fecha_inscripcion DATE,
    estado VARCHAR(50)
)
LANGUAGE sql
AS $$
    SELECT
        i.id_inscripcion,
        g.id_grupo,
        d.disciplina,
        g.nivel,
        p.id_profesor,
        u.nombre,
        u.apellido,
        i.fecha_inscripcion,
        i.estado
    FROM inscripcion i
    INNER JOIN grupos g
        ON i.id_grupo = g.id_grupo
    INNER JOIN disciplinas d
        ON g.id_disciplina = d.id_disciplina
    INNER JOIN profesores p
        ON g.id_profesor = p.id_profesor
    INNER JOIN users u
        ON p.id_usuario = u.id_usuario
    WHERE i.id_alumno = p_id_alumno
      AND i.estado = 'Activo'
    ORDER BY i.fecha_inscripcion DESC;
$$;