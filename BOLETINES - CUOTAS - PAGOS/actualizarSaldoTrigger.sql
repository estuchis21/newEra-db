CREATE OR REPLACE FUNCTION actualizar_saldo_cuota()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN

    UPDATE cuota
    SET
        saldo = saldo - NEW.monto,
        estado = CASE
            WHEN saldo - NEW.monto <= 0
                THEN 'Pagada'
            ELSE 'Pendiente'
        END
    WHERE id_cuota = NEW.id_cuota;

    RETURN NEW;

END;
$$;