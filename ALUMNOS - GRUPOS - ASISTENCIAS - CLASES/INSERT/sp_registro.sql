CREATE OR REPLACE PROCEDURE registroalumno(
    IN p_alumno alumno_input,
    IN p_alumnos alumnos_type,
    IN p_profesor profesorestype,
    INOUT p_id_usuario INTEGER
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_id_usuario INTEGER;
BEGIN

    INSERT INTO users (
        nombre,
        apellido,
        dni,
        email,
        contrasena,
        username,
        celular,
        id_rol
    )
    VALUES (
        p_alumno.nombre,
        p_alumno.apellido,
        p_alumno.dni,
        p_alumno.email,
        p_alumno.contrasena,
        p_alumno.username,
        p_alumno.celular,
        p_alumno.id_rol
    )
    RETURNING id_usuario
    INTO v_id_usuario;


    -- =====================================
    -- ALUMNO
    -- =====================================

    IF p_alumno.id_rol = 2 THEN

        INSERT INTO alumnos (
            id_usuario,
            es_menor
        )
        VALUES (
            v_id_usuario,
            COALESCE(
                p_alumnos.es_menor,
                FALSE
            )
        );

    END IF;


    -- =====================================
    -- PROFESOR
    -- =====================================

    IF p_alumno.id_rol = 3 THEN

        INSERT INTO profesores (
            id_usuario
        )
        VALUES (
            v_id_usuario
        );

    END IF;


    -- =====================================
    -- DEVOLVER ID
    -- =====================================

    p_id_usuario := v_id_usuario;

END;
$$;