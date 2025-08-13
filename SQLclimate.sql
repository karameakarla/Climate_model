--Creacion base de datos
USE Climate_model
--Creacion de Tablas

--Evento Extremo

CREATE TABLE evento_extremo (
id INT IDENTITY(1,1) PRIMARY KEY,
pais_id INT NOT NULL,
tipo_evento VARCHAR(255) NOT NULL,
fecha_inicio DATETIME NOT NULL,
fecha_fin DATETIME NOT NULL,
descripcion VARCHAR(800) NULL,
impacto_estimado NVARCHAR(255) NULL
);

--EXEC sp_help evento_extremo;


--Pais

CREATE TABLE pais (
id INT IDENTITY(1,1) PRIMARY KEY,
codigo_olc VARCHAR(20) UNIQUE,
pais_nombre VARCHAR(100),
superficie INT NOT NULL,
poblacion VARCHAR,
region VARCHAR,
coord_UTM GEOMETRY
);

--Fuente Datos

CREATE TABLE fuente_datos (
id INT IDENTITY(1,1) PRIMARY KEY,
id_nombre VARCHAR(255),
fuente_nombre VARCHAR(255),
tipo_fuente VARCHAR (255),
web VARCHAR,
);

--Registro Indicador

CREATE TABLE registro_indicador(
id INT IDENTITY(1,1) PRIMARY KEY,
pais_id INT FOREIGN KEY REFERENCES pais_id_evento_extremo(id),
indicador_id INT FOREIGN KEY REFERENCES indicador(id),
fuente_id INT,
tipo_evento_id INT,
fecha_reporte DATE,
valor VARCHAR(255),
created_at DATETIME DEFAULT GETDATE(),
updated_at DATETIME,
deleted_at DATETIME,
create_by INT,
update_by INT,
deleted_by INT,
observaciones VARCHAR,
);



--Desviaciones Indicadores

CREATE TABLE desviaciones_indicadores (
id INT IDENTITY(1,1) PRIMARY KEY,
registro_diario_indicador_id INT FOREIGN KEY REFERENCES registro_indicador(id),
diferencia_absoluta DECIMAL,
diferencia_porcentual DECIMAL,
clasificacion_alertas VARCHAR,
);

--Indicador
CREATE TABLE indicador (
id INT IDENTITY(1,1) PRIMARY KEY,
pais_id INT FOREIGN KEY REFERENCES registro_indicador(id),
fuente_datos_id INT FOREIGN KEY REFERENCES fuente_datos(id),
id_nombre VARCHAR (200),
unid_medida INT,
categoria VARCHAR UNIQUE,
evento_extremo_id INT FOREIGN KEY REFERENCES evento_extremo(id),
);
