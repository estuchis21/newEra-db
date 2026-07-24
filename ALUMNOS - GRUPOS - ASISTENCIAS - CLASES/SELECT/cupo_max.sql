CREATE OR REPLACE FUNCTION cupo_max_grupos(
    p_idgrupo INTEGER
)
RETURNS INTEGER
LANGUAGE plpgsql
AS $$

DECLARE
    v_cupo_max INTEGER;

BEGIN

    SELECT cupo_max
    INTO v_cupo_max
    FROM grupos
    WHERE id_grupo = p_idgrupo;


    RETURN v_cupo_max;

END;

$$;
