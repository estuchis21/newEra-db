CREATE OR REPLACE FUNCTION obtenerDisciplinas()
RETURNS TABLE(
    id_disciplina INT,
    disciplina VARCHAR
)
LANGUAGE plpgsql
AS $$

BEGIN

    RETURN QUERY

    SELECT 
        d.id_disciplina,
        d.disciplina

    FROM disciplinas d

    ORDER BY d.id_disciplina;

END;

$$;