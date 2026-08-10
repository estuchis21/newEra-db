CREATE OR REPLACE FUNCTION todas_las_clases()
RETURNS SETOF clase
LANGUAGE plpgsql
AS $$
BEGIN

    RETURN QUERY
    SELECT *
    FROM clase;

END;
$$;