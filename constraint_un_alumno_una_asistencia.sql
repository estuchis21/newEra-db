ALTER TABLE inscripcion
ADD CONSTRAINT alumno_no_repetido_grupo
UNIQUE(id_alumno, id_grupo);