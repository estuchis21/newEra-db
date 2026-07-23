CREATE OR REPLACE PROCEDURE crear_inscripcion (
    p_id_alumno INTEGER,
    p_id_grupo INTEGER,
    p_fecha_inscripcion DATE DEFAULT CURRENT_DATE,
    p_estado VARCHAR(50) DEFAULT 'Activo'
)
LANGUAGE plpgsql
AS $$
BEGIN

    INSERT INTO inscripcion (
        id_alumno,
        id_grupo,
        fecha_inscripcion,
        estado
    )
    VALUES (
        p_id_alumno,
        p_id_grupo,
        p_fecha_inscripcion,
        p_estado
    );

END;
$$;