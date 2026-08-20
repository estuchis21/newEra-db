CREATE OR REPLACE PROCEDURE agregar_horario_grupo(
    p_id_grupo INTEGER,
    p_dia_semana VARCHAR(20),
    p_hora_inicio TIME,
    p_hora_fin TIME
)
LANGUAGE plpgsql
AS $$
BEGIN

    IF p_hora_fin <= p_hora_inicio THEN
        RAISE EXCEPTION
            'La hora de finalización debe ser posterior a la hora de inicio';
    END IF;

    INSERT INTO horario_grupo (
        id_grupo,
        dia_semana,
        hora_inicio,
        hora_fin
    )
    VALUES (
        p_id_grupo,
        p_dia_semana,
        p_hora_inicio,
        p_hora_fin
    );

END;
$$;