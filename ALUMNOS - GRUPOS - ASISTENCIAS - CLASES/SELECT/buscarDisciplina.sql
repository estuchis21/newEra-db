CREATE OR REPLACE FUNCTION buscarDisciplina(
    p_id_disciplina INTEGER
)
RETURNS disciplinas
LANGUAGE plpgsql
AS $$

DECLARE
    v_disciplina disciplinas;

BEGIN

    SELECT *
    INTO v_disciplina
    FROM disciplinas
    WHERE id_disciplina = p_id_disciplina;


    RETURN v_disciplina;

END;

$$;