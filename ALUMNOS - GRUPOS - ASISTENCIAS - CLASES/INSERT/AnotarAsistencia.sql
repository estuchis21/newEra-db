CREATE OR REPLACE PROCEDURE AnotarAsistencia (
	p_id_alumno int, 
	p_id_clase int, 
	p_estado varchar,
	p_observaciones text
)
language plpgsql
as $$
BEGIN

	INSERT INTO asistencia (
		id_alumno,
		id_clase,
		estado,
		observaciones
	)
	VALUES(
		p_id_alumno,
		p_id_clase,
		p_estado,
		p_observaciones
	);
end;
$$;
	
