CREATE OR REPLACE PROCEDURE generar_cuotas_mes()
LANGUAGE plpgsql
AS $$
DECLARE
    v_mes_anio VARCHAR(20);
    v_vencimiento DATE;
BEGIN

    v_mes_anio :=
        TO_CHAR(CURRENT_DATE, 'MM/YYYY');

    v_vencimiento :=
        make_date(
            EXTRACT(YEAR FROM CURRENT_DATE)::INTEGER,
            EXTRACT(MONTH FROM CURRENT_DATE)::INTEGER,
            10
        );

    INSERT INTO cuota (
        id_alumno,
        mes_anio,
        monto,
        saldo,
        vencimiento,
        estado
    )
    SELECT
        a.id_alumno,
        v_mes_anio,
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

    WHERE NOT EXISTS (
        SELECT 1
        FROM cuota c
        WHERE c.id_alumno = a.id_alumno
        AND c.mes_anio = v_mes_anio
    );

END;
$$;