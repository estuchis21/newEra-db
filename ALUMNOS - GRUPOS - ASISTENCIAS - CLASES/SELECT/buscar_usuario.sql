CREATE OR REPLACE FUNCTION buscar_usuario(
    p_email VARCHAR(200)
)
RETURNS users
LANGUAGE plpgsql
AS $$
DECLARE
    v_usuario users;
BEGIN

    SELECT *
    INTO v_usuario
    FROM users
    WHERE email = p_email;

    RETURN v_usuario;

END;
$$;