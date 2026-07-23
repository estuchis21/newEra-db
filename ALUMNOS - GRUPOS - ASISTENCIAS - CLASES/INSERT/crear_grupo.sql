CREATE OR REPLACE PROCEDURE crearGrupoYClase(
    p_id_disciplina INTEGER,
    p_id_profesor INTEGER,
    p_nivel VARCHAR(50),
    p_cupo_max INTEGER,
    p_fecha DATE,
    p_hora_inicio TIME,
    p_hora_fin TIME
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_id_grupo INTEGER;
BEGIN

    INSERT INTO grupos(
        id_disciplina,
        id_profesor,
        nivel,
        cupo_max
    )
    VALUES(
        p_id_disciplina,
        p_id_profesor,
        p_nivel,
        p_cupo_max
    )
    RETURNING id_grupo INTO v_id_grupo;

    INSERT INTO clase(
        id_grupo,
        fecha,
        hora_inicio,
        hora_fin
    )
    VALUES(
        v_id_grupo,
        p_fecha,
        p_hora_inicio,
        p_hora_fin
    );

END;
$$;