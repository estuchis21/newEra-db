CREATE OR REPLACE FUNCTION liquidaciones_por_profesor (
    p_id_profesor INTEGER
)
RETURNS TABLE (
    id_liquidacion INTEGER,
    id_reserva INTEGER,
    monto_base NUMERIC(10,2),
    porcentaje NUMERIC(5,2),
    monto_profesor NUMERIC(10,2),
    monto_academia NUMERIC(10,2),
    fecha_generacion TIMESTAMP,
    estado VARCHAR
)
LANGUAGE sql
AS $$
    SELECT
        lp.id_liquidacion,
        lp.id_reserva,
        lp.monto_base,
        lp.porcentaje,
        lp.monto_profesor,
        lp.monto_academia,
        lp.fecha_generacion,
        lp.estado
 
    FROM liquidacion_profesor lp
 
    WHERE lp.id_profesor = p_id_profesor
 
    ORDER BY lp.fecha_generacion DESC;
$$;