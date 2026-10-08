CREATE OR REPLACE FUNCTION public.buscar_usuario(p_email VARCHAR)
RETURNS TABLE (
    id_usuario INT,
    email VARCHAR,
    password VARCHAR,
    id_rol INT
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        u.id_usuario,
        u.email,
        u.contrasena AS password,
        u.id_rol
    FROM users u
    WHERE u.email = p_email;
END;
$$ LANGUAGE plpgsql;

ALTER FUNCTION public.buscar_usuario(VARCHAR) OWNER TO academia_backend;