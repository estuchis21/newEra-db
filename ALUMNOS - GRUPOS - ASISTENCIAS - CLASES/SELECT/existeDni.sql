CREATE OR REPLACE FUNCTION findByDni(
    p_dni VARCHAR
)
RETURNS BOOLEAN

LANGUAGE plpgsql

AS $$

BEGIN

    RETURN EXISTS(
        SELECT 1
        FROM users
        WHERE users.dni = p_dni
    );

END;

$$;