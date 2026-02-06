/***********************************************************************
CLIMATE_MODEL — SCRIPT DE CREACIÓN DE BASE DE DATOS
Proyecto académico
Propósito: Creación completa del modelo relacional para análisis climático

✔ Entorno recomendado: local / desarrollo
⛔ NO ejecutar en producción sin revisión

Este script:
- Elimina la base si existe
- Crea la base desde cero
- Define tablas, relaciones y una vista
************************************************************************/

USE master;
GO

------------------------------------------------------------
-- ELIMINAR BASE SI EXISTE
------------------------------------------------------------
IF DB_ID('Climate_model') IS NOT NULL
BEGIN
    ALTER DATABASE Climate_model 
    SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE Climate_model;
END
GO

------------------------------------------------------------
-- CREAR BASE DE DATOS
------------------------------------------------------------
CREATE DATABASE Climate_model;
GO

ALTER DATABASE Climate_model 
SET COMPATIBILITY_LEVEL = 160;
GO

USE Climate_model;
GO

------------------------------------------------------------
-- TABLA: PAIS
------------------------------------------------------------
CREATE TABLE dbo.pais (
    id INT IDENTITY(1,1) PRIMARY KEY,
    pais_nombre VARCHAR(255) NOT NULL,
    iso3 CHAR(3) NOT NULL UNIQUE,
    poblacion BIGINT NULL,
    coord_UTM GEOMETRY NULL
);
GO

------------------------------------------------------------
-- TABLA: FUENTE_DATOS
------------------------------------------------------------
CREATE TABLE dbo.fuente_datos (
    id INT IDENTITY(1,1) PRIMARY KEY,
    fuente_nombre VARCHAR(255) NOT NULL,
    descripcion VARCHAR(255) NULL,
    tipo_fuente VARCHAR(100) NULL
);
GO

------------------------------------------------------------
-- TABLA: EVENTO_EXTREMO
------------------------------------------------------------
CREATE TABLE dbo.evento_extremo (
    id INT IDENTITY(1,1) PRIMARY KEY,
    pais_id INT NOT NULL,
    tipo_evento VARCHAR(255) NOT NULL,
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE NULL,
    descripcion VARCHAR(800) NULL,
    impacto_estimado NVARCHAR(255) NULL,
    coord_UTM GEOMETRY NULL,

    CONSTRAINT FK_evento_pais
        FOREIGN KEY (pais_id) REFERENCES dbo.pais(id)
);
GO

------------------------------------------------------------
-- TABLA: INDICADOR
------------------------------------------------------------
CREATE TABLE dbo.indicador (
    id INT IDENTITY(1,1) PRIMARY KEY,
    pais_id INT NOT NULL,
    fuente_id INT NOT NULL,
    indicador_nombre VARCHAR(255) NOT NULL,
    unidad_medida VARCHAR(50) NULL,
    categoria VARCHAR(100) NOT NULL,
    evento_extremo_id INT NULL,

    CONSTRAINT FK_indicador_pais
        FOREIGN KEY (pais_id) REFERENCES dbo.pais(id),

    CONSTRAINT FK_indicador_fuente
        FOREIGN KEY (fuente_id) REFERENCES dbo.fuente_datos(id),

    CONSTRAINT FK_indicador_evento
        FOREIGN KEY (evento_extremo_id) REFERENCES dbo.evento_extremo(id),

    CONSTRAINT UQ_indicador_pais_nombre
        UNIQUE (pais_id, indicador_nombre)
);
GO

------------------------------------------------------------
-- TABLA: REGISTRO_INDICADOR
------------------------------------------------------------
CREATE TABLE dbo.registro_indicador (
    id INT IDENTITY(1,1) PRIMARY KEY,
    indicador_id INT NOT NULL,
    fecha DATE NOT NULL,
    valor DECIMAL(18,4) NULL,
    observaciones VARCHAR(255) NULL,

    CONSTRAINT FK_registro_indicador
        FOREIGN KEY (indicador_id) REFERENCES dbo.indicador(id)
);
GO

------------------------------------------------------------
-- TABLA: DESVIACIONES_INDICADORES
------------------------------------------------------------
CREATE TABLE dbo.desviaciones_indicadores (
    id INT IDENTITY(1,1) PRIMARY KEY,
    registro_indicador_id INT NOT NULL,
    diferencia_absoluta DECIMAL(18,4) NULL,
    diferencia_porcentual DECIMAL(18,4) NULL,
    clasificacion_alerta VARCHAR(50) NULL,

    CONSTRAINT FK_desviaciones_registro
        FOREIGN KEY (registro_indicador_id) 
        REFERENCES dbo.registro_indicador(id)
);
GO

------------------------------------------------------------
-- VISTA: EVENTOS EXTREMOS CON PAÍS
------------------------------------------------------------
CREATE VIEW dbo.vw_eventos_extremos_pais AS
SELECT
    e.id AS evento_id,
    p.pais_nombre,
    e.tipo_evento,
    e.fecha_inicio,
    e.fecha_fin,
    e.descripcion,
    e.impacto_estimado
FROM dbo.evento_extremo e
JOIN dbo.pais p
    ON e.pais_id = p.id;
GO

------------------------------------------------------------
-- FIN DEL SCRIPT
------------------------------------------------------------