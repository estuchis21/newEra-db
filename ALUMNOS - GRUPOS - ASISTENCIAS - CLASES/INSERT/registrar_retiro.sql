-- ============================================================
-- PROCEDURE:
-- REGISTRAR RETIRO DE MENOR
-- ============================================================
 
CREATE OR REPLACE PROCEDURE registrar_retiro (
    p_id_alumno INTEGER,
    p_id_autorizada INTEGER,
    p_id_profesor INTEGER
)
LANGUAGE plpgsql
AS $$
BEGIN
 
    -- ========================================================
    -- Verificar alumno
    -- ========================================================
 
    IF NOT EXISTS (
        SELECT 1
        FROM alumnos
        WHERE id_alumno = p_id_alumno
    ) THEN
 
        RAISE EXCEPTION
            'El alumno % no existe',
            p_id_alumno;
 
    END IF;
 
 
    -- ========================================================
    -- Verificar que la persona autorizada corresponda al alumno
    -- ========================================================
 
    IF NOT EXISTS (
        SELECT 1
        FROM persona_autorizada
        WHERE id_autorizada = p_id_autorizada
          AND id_alumno = p_id_alumno
    ) THEN
 
        RAISE EXCEPTION
            'La persona autorizada % no corresponde a este alumno',
            p_id_autorizada;
 
    END IF;
 
 
    -- ========================================================
    -- Verificar profesor
    -- ========================================================
 
    IF NOT EXISTS (
        SELECT 1
        FROM profesores
        WHERE id_profesor = p_id_profesor
    ) THEN
 
        RAISE EXCEPTION
            'El profesor % no existe',
            p_id_profesor;
 
    END IF;
 
 
    -- ========================================================
    -- Registrar retiro
    -- ========================================================
 
    INSERT INTO retiro_menor (
        id_alumno,
        id_autorizada,
        id_profesor
    )
    VALUES (
        p_id_alumno,
        p_id_autorizada,
        p_id_profesor
    );
 
END;
$$;