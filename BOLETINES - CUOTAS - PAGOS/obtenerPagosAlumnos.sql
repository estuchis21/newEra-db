CREATE OR REPLACE FUNCTION obtener_pagos_alumno(
    p_id_alumno INTEGER
)
RETURNS TABLE (
    id_pago INTEGER,
    id_cuota INTEGER,
    monto NUMERIC(10,2),
    fecha_pago TIMESTAMP,
    estado VARCHAR(50),
    id_mercado_pago BIGINT,
    metodo_pago VARCHAR(50),
    detalle TEXT,
    mes_anio VARCHAR(20),
    vencimiento DATE
)
LANGUAGE plpgsql
AS $$
BEGIN

    RETURN QUERY

    SELECT
        p.id_pago,
        p.id_cuota,
        p.monto,
        p.fecha_pago,
        p.estado,
        p.id_mercado_pago,
        p.metodo_pago,
        p.detalle,

        c.mes_anio,
        c.vencimiento

    FROM pago p

    INNER JOIN cuota c
        ON c.id_cuota = p.id_cuota

    WHERE c.id_alumno = p_id_alumno

    ORDER BY p.fecha_pago DESC;

END;
$$;