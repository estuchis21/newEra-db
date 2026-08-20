CREATE OR REPLACE PROCEDURE generar_clases_del_dia()
LANGUAGE plpgsql
AS $$
DECLARE
    v_dia_semana VARCHAR(20);
    v_id_tipo_clase INTEGER;

BEGIN

    v_dia_semana :=
        CASE EXTRACT(ISODOW FROM CURRENT_DATE)
            WHEN 1 THEN 'Lunes'
            WHEN 2 THEN 'Martes'
            WHEN 3 THEN 'Miércoles'
            WHEN 4 THEN 'Jueves'
            WHEN 5 THEN 'Viernes'
            WHEN 6 THEN 'Sábado'
            WHEN 7 THEN 'Domingo'
        END;


    -- No generar clases los domingos
    IF v_dia_semana = 'Domingo' THEN
        RETURN;
    END IF;


    -- Obtener el tipo de clase Grupo
    SELECT id_tipo_clase
    INTO v_id_tipo_clase
    FROM tipos_clase
    WHERE tipo = 'Grupo';


    IF v_id_tipo_clase IS NULL THEN
        RAISE EXCEPTION
            'No existe el tipo de clase Grupo';
    END IF;


    -- Generar las clases correspondientes al día
    INSERT INTO clase (
        id_grupo,
        id_tipo_clase,
        fecha,
        hora_inicio,
        hora_fin,
        estado
    )

    SELECT
        hg.id_grupo,
        v_id_tipo_clase,
        CURRENT_DATE,
        hg.hora_inicio,
        hg.hora_fin,
        'Pendiente'

    FROM horario_grupo hg

    JOIN grupos g
        ON g.id_grupo = hg.id_grupo

    WHERE hg.dia_semana = v_dia_semana
      AND g.activo = TRUE

    ON CONFLICT (
        id_grupo,
        fecha,
        hora_inicio
    )
    DO NOTHING;

END;
$$;