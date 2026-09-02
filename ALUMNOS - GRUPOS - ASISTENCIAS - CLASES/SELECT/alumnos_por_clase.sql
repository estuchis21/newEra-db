-- ============================================================
-- FUNCIÓN:
-- ALUMNOS POR CLASE
-- (cubre clases de grupo vía inscripción y clases libres vía reserva)
-- ============================================================

CREATE OR REPLACE FUNCTION alumnos_por_clase (
    p_id_clase INTEGER
)
RETURNS TABLE (
    id_alumno INTEGER,
    id_usuario INTEGER,
    nombre VARCHAR,
    apellido VARCHAR,
    dni VARCHAR
)
LANGUAGE sql
AS $$
    SELECT DISTINCT
        a.id_alumno,
        u.id_usuario,
        u.nombre,
        u.apellido,
        u.dni

    FROM clase c

    LEFT JOIN inscripcion i
        ON i.id_grupo = c.id_grupo
       AND i.estado = 'Activo'

    LEFT JOIN reserva r
        ON r.id_clase = c.id_clase
       AND r.estado <> 'Cancelada'

    INNER JOIN alumnos a
        ON a.id_alumno = COALESCE(i.id_alumno, r.id_alumno)

    INNER JOIN users u
        ON u.id_usuario = a.id_usuario

    WHERE c.id_clase = p_id_clase

    ORDER BY apellido, nombre;
$$;