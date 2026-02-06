CREATE DATABASE dw_climate_model;
GO
USE dw_climate_model;


--Dimensiones
CREATE TABLE dim_tiempo(
id INT IDENTITY(1,1) PRIMARY KEY,
fecha_registro DATE,
dia VARCHAR (40),
mes VARCHAR (40),
trimestre VARCHAR(20),
anio VARCHAR(40)
);

CREATE TABLE dim_pais(
id INT IDENTITY(1,1) PRIMARY KEY,
pais_id INT, 
pais_nombre VARCHAR(255),
iso3 VARCHAR(3),
poblacion BIGINT,
region VARCHAR(255) --Problemas con SISS
coord_UTM GEOMETRY --Problemas con SISS
);
ALTER TABLE dim_pais DROP COLUMN coord_utm;
ALTER TABLE dim_pais DROP COLUMN region;


sp_help dim_pais;
 


CREATE TABLE dim_fuente_datos(
id INT IDENTITY(1,1) PRIMARY KEY,
fuente_id INT,
fuente_nombre VARCHAR (255),
descripcion VARCHAR (255),
tipo_fuente VARCHAR (255),
url NVARCHAR (300),
);


CREATE TABLE dim_evento_extremo(
id INT IDENTITY(1,1) PRIMARY KEY,
evento_extremo_id INT,
tipo_evento VARCHAR (255),
descripcion VARCHAR (800),
ubicacion VARCHAR (255),
impacto_estimado NVARCHAR(255),
fuente_id INT,  
);


CREATE TABLE dim_indicador(
id INT IDENTITY(1,1) PRIMARY KEY,
indicador_id INT,
indicador_nombre VARCHAR (255),
unidad_medida VARCHAR (50),
categoria VARCHAR (255),
);


--Tabla de hechos (Fact)
CREATE TABLE hechos_registro_indicador(
id INT IDENTITY(1,1) PRIMARY KEY,
registro_id INT,
dim_tiempo_id INT,
dim_pais_id INT,
dim_fuente_datos_id INT,
dim_evento_extremo_id INT,
dim_indicador_id INT,
valor_registro_indicador DECIMAL(18,4),
valor_evento_extremo DECIMAL(18,4)NULL,
valor_calculado_desviacion DECIMAL (18,4)NULL,
clasificacion_alertas VARCHAR (50) NULL,
tipo_desviacion VARCHAR(50) NULL,
periodo VARCHAR(100),
unidad VARCHAR(50),
CONSTRAINT fk_dim_tiempo_id FOREIGN KEY (dim_tiempo_id) REFERENCES dim_tiempo(id),
CONSTRAINT fk_dim_pais_id FOREIGN KEY (dim_pais_id) REFERENCES dim_pais(id),
CONSTRAINT fk_dim_fuente_datos_id FOREIGN KEY (dim_fuente_datos_id) REFERENCES dim_fuente_datos(id),
CONSTRAINT fk_dim_evento_extremo_id FOREIGN KEY (dim_evento_extremo_id) REFERENCES dim_evento_extremo(id),
CONSTRAINT fk_dim_indicador_id FOREIGN KEY (dim_indicador_id) REFERENCES dim_indicador(id),
);



