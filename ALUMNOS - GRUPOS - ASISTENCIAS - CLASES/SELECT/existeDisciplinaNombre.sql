CREATE OR REPLACE FUNCTION existeDisciplinaNombre(
    p_disciplina VARCHAR
)
RETURNS BOOLEAN
LANGUAGE plpgsql
AS $$

BEGIN

    RETURN EXISTS(
        SELECT 1
        FROM disciplinas
        WHERE LOWER(disciplina) = LOWER(p_disciplina)
    );

END;

$$;