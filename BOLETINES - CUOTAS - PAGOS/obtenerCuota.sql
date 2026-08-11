CREATE OR REPLACE FUNCTION obtener_cuota(
    p_id_cuota INTEGER
)
RETURNS TABLE (
    id_cuota INTEGER,
    id_alumno INTEGER,
    monto NUMERIC(10,2),
    mes_anio VARCHAR(20),
    vencimiento DATE,
    estado VARCHAR(50),
    email VARCHAR(200),
    nombre VARCHAR(100),
    apellido VARCHAR(100)
)
LANGUAGE plpgsql
AS $$
BEGIN

    RETURN QUERY

    SELECT
        c.id_cuota,
        c.id_alumno,
        c.monto,
        c.mes_anio,
        c.vencimiento,
        c.estado,

        u.email,
        u.nombre,
        u.apellido

    FROM cuota c

    INNER JOIN alumnos a
        ON a.id_alumno = c.id_alumno

    INNER JOIN users u
        ON u.id_usuario = a.id_usuario

    WHERE c.id_cuota = p_id_cuota;

END;
$$;