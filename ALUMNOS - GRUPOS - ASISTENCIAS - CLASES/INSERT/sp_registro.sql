CREATE OR REPLACE PROCEDURE RegistroAlumno (
    data_usuarios alumno_input,
    alumnos alumnos_type,
    profesores profesorestype,
    OUT id_usuario_creado INT
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
        data_usuarios.nombre,
        data_usuarios.apellido,
        data_usuarios.dni,
        data_usuarios.email,
        data_usuarios.contrasena,
        data_usuarios.username,
        data_usuarios.celular,
        data_usuarios.id_rol
    )
    RETURNING id_usuario
    INTO id_usuario_creado;



    IF data_usuarios.id_rol = 1 THEN

        INSERT INTO alumnos (
            id_usuario,
            es_menor
        )
        VALUES (
            id_usuario_creado,
            alumnos.es_menor
        );

    END IF;



    IF data_usuarios.id_rol = 2 THEN

        INSERT INTO profesores (
            id_usuario
        )
        VALUES (
            id_usuario_creado
        );

    END IF;



EXCEPTION

    WHEN OTHERS THEN

        RAISE;

END;
$$;