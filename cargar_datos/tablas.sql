CREATE DATABASE publicidad;

USE publicidad;

CREATE TABLE campanias(
    id INT NOT NULL PRIMARY KEY,
    nombre VARCHAR(50) ,
    lanzamiento VARCHAR(50),
    final VARCHAR(50),
    duracion INT,
    presupuesto_total FLOAT
);
CREATE TABLE users(
    id VARCHAR(50) NOT NULL PRIMARY KEY,
    genero VARCHAR(50) ,
    edad INT,
    grupo_edad VARCHAR(50),
    pais VARCHAR(50),
    ciudad VARCHAR(50),
    interes TEXT
);
CREATE TABLE ads(
    id INT NOT NULL PRIMARY KEY,
    camp_id INT NOT NULL,
    plataforma VARCHAR(50),
    tipo VARCHAR(50),
    genero_target VARCHAR(50),
    edad_target VARCHAR(50),
    interes_target TEXT,
    FOREIGN KEY(camp_id) REFERENCES campanias(id)
);
CREATE TABLE interaccion_ads(
    interac_id INT NOT NULL PRIMARY KEY,
    ad_id INT NOT NULL,
    user_id VARCHAR(50) NOT NULL,
    fecha DATETIME,
    dia VARCHAR(20),
    horario VARCHAR(20),
    tipo_interac VARCHAR(50),
    FOREIGN KEY(ad_id) REFERENCES ads(id),
    FOREIGN KEY(user_id) REFERENCES users(id)
);
