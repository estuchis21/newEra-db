CREATE OR REPLACE FUNCTION buscar_clase_por_id(
    p_id_clase INTEGER
)
RETURNS clase
LANGUAGE plpgsql
AS $$
DECLARE
    v_clase clase;
BEGIN

    SELECT *
    INTO v_clase
    FROM clase
    WHERE id_clase = p_id_clase;

    RETURN v_clase;

END;
$$;