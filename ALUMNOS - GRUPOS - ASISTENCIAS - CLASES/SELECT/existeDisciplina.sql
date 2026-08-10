CREATE OR REPLACE FUNCTION existeDisciplina(
    p_id_disciplina INTEGER
)
RETURNS BOOLEAN
LANGUAGE plpgsql
AS $$

BEGIN

    RETURN EXISTS (
        SELECT 1
        FROM disciplinas
        WHERE id_disciplina = p_id_disciplina
    );

END;

$$;