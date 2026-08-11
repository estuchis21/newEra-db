CREATE OR REPLACE FUNCTION obtener_pago_mercado_pago(
    p_id_mercado_pago BIGINT
)
RETURNS TABLE (
    id_pago INTEGER,
    id_cuota INTEGER,
    monto NUMERIC(10,2),
    fecha_pago TIMESTAMP,
    estado VARCHAR(50),
    id_mercado_pago BIGINT,
    metodo_pago VARCHAR(50),
    detalle TEXT
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
        p.detalle

    FROM pago p

    WHERE p.id_mercado_pago = p_id_mercado_pago;

END;
$$;