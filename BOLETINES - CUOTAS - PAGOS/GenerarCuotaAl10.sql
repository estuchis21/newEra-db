CREATE OR REPLACE PROCEDURE generar_cuotas_mes()
LANGUAGE plpgsql
AS $$
DECLARE
    v_mes_anio VARCHAR(20);
    v_vencimiento DATE;
    v_monto NUMERIC(10,2);
BEGIN

    -- Mes y año actual
    v_mes_anio := TO_CHAR(CURRENT_DATE, 'MM/YYYY');

    -- Vencimiento: día 10 del mes actual
    v_vencimiento := MAKE_DATE(
        EXTRACT(YEAR FROM CURRENT_DATE)::INTEGER,
        EXTRACT(MONTH FROM CURRENT_DATE)::INTEGER,
        10
    );

    -- Obtener el precio del paquete de créditos activo
    SELECT precio
    INTO v_monto
    FROM paquetes_creditos
    WHERE activo = TRUE
    ORDER BY id_paquete
    LIMIT 1;

    -- Verificar que exista un paquete activo
    IF v_monto IS NULL THEN
        RAISE EXCEPTION 'No existe ningún paquete de créditos activo';
    END IF;

    -- Generar una cuota para cada alumno
    INSERT INTO cuota (
        id_alumno,
        mes_anio,
        monto,
        vencimiento,
        estado
    )
    SELECT
        a.id_alumno,
        v_mes_anio,
        v_monto,
        v_vencimiento,
        'Pendiente'
    FROM alumnos a
    WHERE NOT EXISTS (
        SELECT 1
        FROM cuota c
        WHERE c.id_alumno = a.id_alumno
          AND c.mes_anio = v_mes_anio
    );

END;
$$;