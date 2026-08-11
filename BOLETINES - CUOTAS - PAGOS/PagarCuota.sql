CREATE OR REPLACE PROCEDURE registrar_pago_cuota(
    p_id_cuota INTEGER,
    p_monto NUMERIC(10,2),
    p_id_mercado_pago BIGINT,
    p_metodo_pago VARCHAR(50)
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_saldo NUMERIC(10,2);
    v_nuevo_saldo NUMERIC(10,2);
    v_estado VARCHAR(50);
BEGIN

    IF p_monto <= 0 THEN
        RAISE EXCEPTION
            'El monto debe ser mayor a 0';
    END IF;


    /*
     * Bloqueamos la cuota para evitar que dos pagos
     * simultáneos modifiquen el mismo saldo incorrectamente.
     */

    SELECT saldo
    INTO v_saldo
    FROM cuota
    WHERE id_cuota = p_id_cuota
    FOR UPDATE;


    IF NOT FOUND THEN
        RAISE EXCEPTION
            'La cuota % no existe',
            p_id_cuota;
    END IF;


    IF v_saldo <= 0 THEN
        RAISE EXCEPTION
            'La cuota % ya está pagada',
            p_id_cuota;
    END IF;


    IF p_monto > v_saldo THEN
        RAISE EXCEPTION
            'El monto % supera el saldo restante %',
            p_monto,
            v_saldo;
    END IF;


    /*
     * Evitar registrar dos veces el mismo pago
     * de Mercado Pago.
     */

    IF EXISTS (
        SELECT 1
        FROM pago
        WHERE id_mercado_pago = p_id_mercado_pago
    ) THEN

        RETURN;

    END IF;


    v_nuevo_saldo :=
        v_saldo - p_monto;


    IF v_nuevo_saldo = 0 THEN
        v_estado := 'Pagada';
    ELSE
        v_estado := 'Parcial';
    END IF;


    /*
     * Registrar el pago.
     */

    INSERT INTO pago (
        id_cuota,
        monto,
        fecha_pago,
        estado,
        id_mercado_pago,
        metodo_pago,
        detalle
    )
    VALUES (
        p_id_cuota,
        p_monto,
        CURRENT_TIMESTAMP,
        'Aprobado',
        p_id_mercado_pago,
        p_metodo_pago,
        'Pago procesado mediante Mercado Pago'
    );


    /*
     * Actualizar saldo.
     */

    UPDATE cuota
    SET
        saldo = v_nuevo_saldo,
        estado = v_estado
    WHERE id_cuota = p_id_cuota;

END;
$$;