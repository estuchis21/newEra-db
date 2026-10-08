CREATE TABLE tokens_recuperacion_password (
    id_token SERIAL PRIMARY KEY,

    id_usuario INTEGER NOT NULL,

    token TEXT NOT NULL UNIQUE,

    fecha_expiracion TIMESTAMP NOT NULL,

    utilizado BOOLEAN NOT NULL DEFAULT FALSE,

    CONSTRAINT fk_token_usuario
        FOREIGN KEY (id_usuario)
        REFERENCES users(id_usuario)
        ON DELETE CASCADE
);