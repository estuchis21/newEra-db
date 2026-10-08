CREATE UNIQUE INDEX uq_clase_grupo_fecha_hora
ON clase (id_grupo, fecha, hora_inicio);