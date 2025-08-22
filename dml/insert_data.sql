USE Climate_model;
GO

--Evento Extremo
SELECT*FROM evento_extremo;

INSERT INTO evento_extremo VALUES('tipo_evento_sequia_incend_inund','tipo_evento_sequia_incend_inund');

-- Lista todas las restricciones únicas
SELECT name, OBJECT_NAME(parent_object_id) AS tabla, type_desc
FROM sys.key_constraints
WHERE type_desc LIKE '%UNIQUE%';

-- Lista todas las claves foráneas
SELECT name, OBJECT_NAME(parent_object_id) AS tabla, type_desc
FROM sys.foreign_keys;

USE Climate_model;
GO

PRINT '============================';
PRINT ' 1. DETECTAR Y LIMPIAR HUÉRFANOS ';
PRINT '============================';

-- 1?? Mostrar datos huérfanos
PRINT '?? Detectando datos huérfanos...';

-- evento_extremo ? pais
SELECT 'evento_extremo ? pais' AS relacion, e.*
FROM evento_extremo e
LEFT JOIN pais p ON e.pais_id = p.id
WHERE p.id IS NULL;

-- registro_indicador ? pais
SELECT 'registro_indicador ? pais' AS relacion, r.*
FROM registro_indicador r
LEFT JOIN pais p ON r.pais_id = p.id
WHERE p.id IS NULL;

-- registro_indicador ? indicador
SELECT 'registro_indicador ? indicador' AS relacion, r.*
FROM registro_indicador r
LEFT JOIN indicador i ON r.indicador_id = i.id
WHERE i.id IS NULL;

-- registro_indicador ? fuente_datos
SELECT 'registro_indicador ? fuente_datos' AS relacion, r.*
FROM registro_indicador r
LEFT JOIN fuente_datos f ON r.fuente_id = f.id
WHERE f.id IS NULL;

-- indicador ? pais
SELECT 'indicador ? pais' AS relacion, i.*
FROM indicador i
LEFT JOIN pais p ON i.pais_id = p.id
WHERE p.id IS NULL;

-- indicador ? fuente_datos
SELECT 'indicador ? fuente_datos' AS relacion, i.*
FROM indicador i
LEFT JOIN fuente_datos f ON i.fuente_datos_id = f.id
WHERE f.id IS NULL;

-- indicador ? evento_extremo
SELECT 'indicador ? evento_extremo' AS relacion, i.*
FROM indicador i
LEFT JOIN evento_extremo e ON i.evento_extremo_id = e.id
WHERE e.id IS NULL;

-- desviaciones_indicadores ? registro_indicador
SELECT 'desviaciones_indicadores ? registro_indicador' AS relacion, d.*
FROM desviaciones_indicadores d
LEFT JOIN registro_indicador r ON d.registro_diario_indicador_id = r.id
WHERE r.id IS NULL;

PRINT '?? Limpiando datos huérfanos...';

-- 2?? Borrar huérfanos
DELETE FROM desviaciones_indicadores
WHERE registro_diario_indicador_id NOT IN (SELECT id FROM registro_indicador);

DELETE FROM indicador
WHERE evento_extremo_id NOT IN (SELECT id FROM evento_extremo)
   OR fuente_datos_id NOT IN (SELECT id FROM fuente_datos)
   OR pais_id NOT IN (SELECT id FROM pais);

DELETE FROM registro_indicador
WHERE indicador_id NOT IN (SELECT id FROM indicador)
   OR fuente_id NOT IN (SELECT id FROM fuente_datos)
   OR pais_id NOT IN (SELECT id FROM pais);

DELETE FROM evento_extremo
WHERE pais_id NOT IN (SELECT id FROM pais);

PRINT '? Datos huérfanos eliminados.';

--------------------------------------------------------------------------------
PRINT '============================';
PRINT ' 2. AJUSTE DE ESTRUCTURA Y FK ';
PRINT '============================';

-- 3?? Eliminar restricciones únicas conflictivas
ALTER TABLE pais DROP CONSTRAINT UQ__pais__1F360549357AC7E3;
ALTER TABLE registro_indicador DROP CONSTRAINT UQ__registro__77769B24105036D1;
ALTER TABLE indicador DROP CONSTRAINT UQ__Indicado__1179412F9E5D006A;

-- 4?? Modificar tipos de datos
ALTER TABLE pais ALTER COLUMN poblacion BIGINT NULL;
ALTER TABLE pais ALTER COLUMN region VARCHAR(50) NULL;
ALTER TABLE fuente_datos ALTER COLUMN web VARCHAR(500) NULL;
ALTER TABLE registro_indicador ALTER COLUMN valor DECIMAL(18,2) NULL;
ALTER TABLE registro_indicador ALTER COLUMN observaciones VARCHAR(500) NULL;
ALTER TABLE indicador ALTER COLUMN unid_medida VARCHAR(50) NULL;
ALTER TABLE desviaciones_indicadores ALTER COLUMN diferencia_absoluta DECIMAL(18,2) NULL;
ALTER TABLE desviaciones_indicadores ALTER COLUMN diferencia_porcentual DECIMAL(18,2) NULL;
ALTER TABLE desviaciones_indicadores ALTER COLUMN clasificacion_alertas VARCHAR(50) NULL;

-- 5?? Eliminar FKs viejas
ALTER TABLE evento_extremo DROP CONSTRAINT FK_pais_id;
ALTER TABLE registro_indicador DROP CONSTRAINT FK_registro__pais__5F9E293D;
ALTER TABLE indicador DROP CONSTRAINT Indicador_fk1;

-- 6?? Crear FKs nuevas
ALTER TABLE evento_extremo 
    ADD CONSTRAINT FK_evento_pais FOREIGN KEY (pais_id) REFERENCES pais(id);

ALTER TABLE registro_indicador 
    ADD CONSTRAINT FK_registro_pais FOREIGN KEY (pais_id) REFERENCES pais(id);

ALTER TABLE registro_indicador 
    ADD CONSTRAINT FK_registro_indicador FOREIGN KEY (indicador_id) REFERENCES indicador(id);

ALTER TABLE registro_indicador 
    ADD CONSTRAINT FK_registro_fuente FOREIGN KEY (fuente_id) REFERENCES fuente_datos(id);

ALTER TABLE indicador 
    ADD CONSTRAINT FK_indicador_pais FOREIGN KEY (pais_id) REFERENCES pais(id);

ALTER TABLE indicador 
    ADD CONSTRAINT FK_indicador_fuente FOREIGN KEY (fuente_datos_id) REFERENCES fuente_datos(id);

ALTER TABLE indicador 
    ADD CONSTRAINT FK_indicador_evento FOREIGN KEY (evento_extremo_id) REFERENCES evento_extremo(id);

ALTER TABLE desviaciones_indicadores 
    ADD CONSTRAINT FK_desviacion_registro FOREIGN KEY (registro_diario_indicador_id) REFERENCES registro_indicador(id);

PRINT '? Migración completada.';