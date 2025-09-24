USE [master];
GO

-- No me dejo poner DROP eliminar base anterior 
ALTER DATABASE Climate_model SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
DROP DATABASE Climate_model;
GO

CREATE DATABASE [Climate_model]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'Mio', FILENAME = N'C:\SQLData\Mio.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'Mio_log', FILENAME = N'C:\SQLData\Mio_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT;
GO

ALTER DATABASE [Climate_model] SET COMPATIBILITY_LEVEL = 160;
GO

USE [Climate_model];
GO

--Eliminar antes de crear la tabla por que aparecen repetidas
DROP TABLE IF EXISTS dbo.pais;
DROP TABLE IF EXISTS dbo.fuente_datos;
DROP TABLE IF EXISTS dbo.registro_indicador;

------------------------------------------------------------
-- TABLA PAIS
------------------------------------------------------------
CREATE TABLE dbo.pais (
    id INT IDENTITY(1,1) PRIMARY KEY,
    pais_nombre VARCHAR(255) NOT NULL,
    iso3 VARCHAR(3) NOT NULL UNIQUE,
    poblacion BIGINT NULL,
    coord_UTM GEOMETRY NULL
);
GO

------------------------------------------------------------
-- TABLA FUENTE_DATOS
------------------------------------------------------------
CREATE TABLE dbo.fuente_datos (
    id INT IDENTITY(1,1) PRIMARY KEY,
    fuente_nombre VARCHAR(255) NULL,
    descripcion VARCHAR(255) NULL,
    tipo_fuente VARCHAR(255) NULL
);
GO

------------------------------------------------------------
-- TABLA EVENTO_EXTREMO
------------------------------------------------------------
CREATE TABLE dbo.evento_extremo (
    id INT IDENTITY(1,1) PRIMARY KEY,
    pais_id INT NOT NULL,
    ubicacion VARCHAR(255) NOT NULL,
    tipo_evento VARCHAR(255) NOT NULL,
    descripcion VARCHAR(800) NULL,
    valor INT NOT NULL,
    fecha DATETIME NOT NULL,
    coord_UTM GEOMETRY NULL, 
    impacto_estimado NVARCHAR(255) NULL,
    CONSTRAINT FK_evento_pais FOREIGN KEY (pais_id) REFERENCES dbo.pais(id)
);
GO

------------------------------------------------------------
-- TABLA INDICADOR
------------------------------------------------------------
CREATE TABLE dbo.indicador (
    id INT IDENTITY(1,1) PRIMARY KEY,
    pais_id INT NOT NULL,
    fuente_id INT NOT NULL,
    evento_extremo_id INT NOT NULL,
    indicador_nombre VARCHAR(255) NOT NULL,
    unidad_medida VARCHAR(50) NULL,
    categoria VARCHAR(255) NOT NULL,

    CONSTRAINT FK_indicador_pais FOREIGN KEY (pais_id) REFERENCES dbo.pais(id),
    CONSTRAINT FK_indicador_fuente FOREIGN KEY (fuente_id) REFERENCES dbo.fuente_datos(id),
    CONSTRAINT FK_indicador_evento_extremo FOREIGN KEY (evento_extremo_id) REFERENCES dbo.evento_extremo(id)
);
GO

------------------------------------------------------------
-- TABLA REGISTRO_INDICADOR
------------------------------------------------------------
CREATE TABLE dbo.registro_indicador (
    id INT IDENTITY(1,1) PRIMARY KEY,
    pais_id INT NOT NULL,
    fuente_id INT NOT NULL,
    fecha DATE NOT NULL,
    indicador_nombre VARCHAR(255) NOT NULL,
    valor DECIMAL(18,4) NULL,
    unidad VARCHAR(50) NULL,
    CONSTRAINT FK_registro_pais FOREIGN KEY (pais_id) REFERENCES dbo.pais(id),
    CONSTRAINT FK_registro_fuente FOREIGN KEY (fuente_id) REFERENCES dbo.fuente_datos(id)
);
GO

------------------------------------------------------------
-- TABLA DESVIACIONES_INDICADORES
------------------------------------------------------------
CREATE TABLE dbo.desviaciones_indicadores (
    id INT IDENTITY(1,1) PRIMARY KEY,
    registro_indicador_id INT NOT NULL,
    diferencia_absoluta DECIMAL(18,2) NULL,
    diferencia_porcentual DECIMAL(18,2) NULL,
    clasificacion_alertas VARCHAR(50) NULL,
    CONSTRAINT FK_desviaciones_registro FOREIGN KEY (registro_indicador_id) REFERENCES dbo.registro_indicador(id)
);
GO

------------------------------------------------------------
-- VISTAS (ejemplo: eventos extremos + país)
------------------------------------------------------------
CREATE VIEW dbo.vw_eventos_con_pais AS
SELECT 
    e.id,
    p.pais_nombre,
    e.tipo_evento,
    e.fecha,
    e.descripcion,
    e.impacto_estimado
FROM dbo.evento_extremo e
JOIN dbo.pais p ON e.pais_id = p.id;
GO