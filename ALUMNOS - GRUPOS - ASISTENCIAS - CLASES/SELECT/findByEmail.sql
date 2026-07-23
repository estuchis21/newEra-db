CREATE OR REPLACE FUNCTION findByEmail(
    p_email VARCHAR
)
RETURNS BOOLEAN

LANGUAGE plpgsql

AS $$

BEGIN

    RETURN EXISTS(
        SELECT 1
        FROM users
        WHERE users.email = p_email
    );

END;

$$;