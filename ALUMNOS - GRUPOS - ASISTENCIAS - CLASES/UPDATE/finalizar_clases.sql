CREATE OR REPLACE PROCEDURE finalizar_clases()
LANGUAGE plpgsql
AS $$
BEGIN

    UPDATE clase

    SET estado = 'Realizada'

    WHERE estado = 'Pendiente'

      AND (
            fecha < CURRENT_DATE

            OR (
                fecha = CURRENT_DATE
                AND hora_fin <= CURRENT_TIME
            )
      );

END;
$$;