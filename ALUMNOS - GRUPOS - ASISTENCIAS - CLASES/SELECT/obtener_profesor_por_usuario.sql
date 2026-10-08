CREATE OR REPLACE FUNCTION public.obtener_profesor_por_usuario(
    p_id_usuario INTEGER
)
RETURNS TABLE (
    id_profesor INTEGER,
    id_usuario INTEGER
)
LANGUAGE sql
AS $$
    SELECT
        p.id_profesor,
        p.id_usuario
    FROM profesores p
    WHERE p.id_usuario = p_id_usuario;
$$;