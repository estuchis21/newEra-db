CREATE OR REPLACE PROCEDURE insertarDisciplina (
	disciplina disciplinas_type
)

LANGUAGE plpgsql
AS $$
BEGIN
	INSERT INTO disciplinas(
       	disciplina
    )
    VALUES(
        disciplina.disciplina
    );

END;
$$;