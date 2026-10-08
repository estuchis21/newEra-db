CREATE OR REPLACE FUNCTION existe_pago_mercado_pago(
    p_id_mercado_pago BIGINT
)
RETURNS BOOLEAN
LANGUAGE plpgsql
AS $$
DECLARE
    existe BOOLEAN;
BEGIN

    SELECT EXISTS (
        SELECT 1
        FROM pago
        WHERE id_mercado_pago = p_id_mercado_pago
    )
    INTO existe;

    RETURN existe;

END;
$$; 