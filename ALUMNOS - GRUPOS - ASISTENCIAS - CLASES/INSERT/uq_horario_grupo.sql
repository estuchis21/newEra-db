ALTER TABLE horario_grupo
ADD CONSTRAINT uq_horario_grupo
UNIQUE (id_grupo, dia_semana, hora_inicio, hora_fin);