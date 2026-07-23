ALTER TABLE asistencia
ADD CONSTRAINT un_alumno_una_asistencia
UNIQUE(id_alumno, id_clase);