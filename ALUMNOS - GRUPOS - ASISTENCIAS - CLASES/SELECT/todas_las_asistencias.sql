CREATE OR REPLACE FUNCTION todas_las_asistencias()
RETURNS SETOF asistencia
LANGUAGE sql
AS $$
    SELECT *
    FROM asistencia;
$$;