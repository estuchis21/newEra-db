CREATE OR REPLACE PROCEDURE crear_grupo(
    p_id_disciplina INTEGER,
    p_id_profesor INTEGER,
    p_nivel VARCHAR(50),
    p_cupo_max INTEGER
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_id_grupo INTEGER;

BEGIN

    INSERT INTO grupos (
        id_disciplina,
        id_profesor,
        nivel,
        cupo_max
    )
    VALUES (
        p_id_disciplina,
        p_id_profesor,
        p_nivel,
        p_cupo_max
    )
    RETURNING id_grupo INTO v_id_grupo;

    RAISE NOTICE 'Grupo creado correctamente. ID: %', v_id_grupo;

EXCEPTION
    WHEN OTHERS THEN
        RAISE;
END;
$$;