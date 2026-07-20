CREATE OR REPLACE PROCEDURE RegistroAlumno (
	data_alumnos alumno_input
)

LANGUAGE plpgsql
AS $$
BEGIN
	INSERT INTO users(
        nombre,
        apellido,
        dni,
        email,
		contrasena,
        username,
        celular,
		id_rol
    )
    VALUES(
        data_alumno.nombre,
        p_al.apellido,
        p_alumno.dni,
        p_alumno.email,
        p_alumno.contrasena,
		p_alumno.username,
        p_alumno.celular
    );

END;
$$;