CREATE OR REPLACE FUNCTION buscarUsuarioEmail(
    p_email VARCHAR
)
RETURNS TABLE(
    id_usuario INT,
    nombre VARCHAR,
    apellido VARCHAR,
    email VARCHAR,
    contrasena VARCHAR,
    id_rol INT
)

LANGUAGE plpgsql
AS $$

BEGIN

RETURN QUERY

SELECT
    u.id_usuario,
    u.nombre,
    u.apellido,
    u.email,
    u.contrasena,
    u.id_rol

FROM users u

WHERE u.email = p_email;


END;

$$;