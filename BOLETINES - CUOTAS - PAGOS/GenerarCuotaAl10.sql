CREATE OR REPLACE PROCEDURE generar_cuotas_mes()
LANGUAGE plpgsql
AS $$
DECLARE
    v_mes_anio VARCHAR(20);
    v_vencimiento DATE;
<<<<<<< HEAD
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
=======
BEGIN

    v_mes_anio :=
        TO_CHAR(CURRENT_DATE, 'MM/YYYY');

    v_vencimiento :=
        make_date(
            EXTRACT(YEAR FROM CURRENT_DATE)::INTEGER,
            EXTRACT(MONTH FROM CURRENT_DATE)::INTEGER,
            10
        );

>>>>>>> c5c3ed1a2415fd31eee53de24b34c94600502f42
    INSERT INTO cuota (
        id_alumno,
        mes_anio,
        monto,
<<<<<<< HEAD
=======
        saldo,
>>>>>>> c5c3ed1a2415fd31eee53de24b34c94600502f42
        vencimiento,
        estado
    )
    SELECT
        a.id_alumno,
        v_mes_anio,
<<<<<<< HEAD
        v_monto,
        v_vencimiento,
        'Pendiente'
    FROM alumnos a
=======
        COALESCE(
            (
                SELECT p.precio
                FROM paquetes_creditos p
                WHERE p.activo = TRUE
                ORDER BY p.id_paquete
                LIMIT 1
            ),
            0
        ),
        COALESCE(
            (
                SELECT p.precio
                FROM paquetes_creditos p
                WHERE p.activo = TRUE
                ORDER BY p.id_paquete
                LIMIT 1
            ),
            0
        ),
        v_vencimiento,
        'Pendiente'
    FROM alumnos a

>>>>>>> c5c3ed1a2415fd31eee53de24b34c94600502f42
    WHERE NOT EXISTS (
        SELECT 1
        FROM cuota c
        WHERE c.id_alumno = a.id_alumno
<<<<<<< HEAD
          AND c.mes_anio = v_mes_anio
=======
        AND c.mes_anio = v_mes_anio
>>>>>>> c5c3ed1a2415fd31eee53de24b34c94600502f42
    );

END;
$$;