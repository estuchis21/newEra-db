CREATE OR REPLACE PROCEDURE public.registroalumno(
    data_alumnos alumno_input,
    p_alumnos_type alumnos_type DEFAULT NULL,
    p_profesores_type profesorestype DEFAULT NULL,
    p_id_usuario_creador integer DEFAULT NULL
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_id_usuario INT;
BEGIN
    -- 1. Registrar usuario en la tabla 'users'
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
        data_alumnos.nombre,
        data_alumnos.apellido,
        data_alumnos.dni,
        data_alumnos.email,
        data_alumnos.contrasena,
        data_alumnos.username,
        data_alumnos.celular,
        data_alumnos.id_rol
    )
    RETURNING id_usuario INTO v_id_usuario;

    -- 2. Evaluar el id_rol e insertar según corresponda
    IF data_alumnos.id_rol = 2 THEN
        -- Perfil Alumno
        INSERT INTO alumnos (id_usuario)
        VALUES (v_id_usuario)
        ON CONFLICT DO NOTHING;
        
    ELSIF data_alumnos.id_rol = 3 THEN
        -- Perfil Profesor
        INSERT INTO profesores (id_usuario)
        VALUES (v_id_usuario)
        ON CONFLICT DO NOTHING;
        
    END IF;

END;
$$;

-- 3. Asignar propiedad a academia_backend
ALTER PROCEDURE public.registroalumno(alumno_input, alumnos_type, profesorestype, integer) OWNER TO academia_backend;