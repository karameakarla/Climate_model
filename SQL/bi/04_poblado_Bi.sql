USE Climate_model;
GO



--Dim Tiempo
--SELECT*FROM registro_indicador;
SELECT
DISTINCT
	fecha,
	DAY(fecha)AS 'dia',
	MONTH(fecha) AS 'mes',
	DATEPART (QUARTER, fecha) AS 'trimestre',
	YEAR(fecha) AS 'anio'

FROM registro_indicador;


--Dim Pais
--SELECT*FROM pais;
SELECT
	p.id AS pais_id,
	pais_nombre,
	p.iso3,
	p.poblacion
	--p.coord_UTM.ToString() AS coord_UTM_texto  -- ← Conversión a texto

FROM pais p;



--Dim Fuente_datos
--SELECT*FROM fuente_datos;
SELECT
DISTINCT
	f.id AS fuente_datos_id,
	f.fuente_nombre,
	f.descripcion,
	f.tipo_fuente,
	f.url

FROM fuente_datos f;


--Dim Evento_extremo
--SELECT*FROM evento_extremo;
SELECT
DISTINCT
	ee.id AS evento_extremo_id,
	ee.tipo_evento,
	ee.descripcion,
	ee.ubicacion,
	ee.impacto_estimado,
	ee.fuente_id
	
FROM evento_extremo ee;


--Dim Indicador
--SELECT*FROM indicador;
SELECT
DISTINCT
	id AS indicador_id,
	indicador_nombre,
	unidad_medida,
	categoria	

FROM indicador;


--Hechos_registro_indicador
--SELECT*FROM registro_indicador;
SELECT
DISTINCT*

FROM registro_indicador;
SELECT
DISTINCT
	rid.id,
	rid.fecha,
	rid.pais_id,
	rid.fuente_id,
	rid.evento_extremo_id,
	rid.indicador_nombre,
	rid.valor AS valor_registro_indicador,
	ee.valor AS valor_evento_extremo,
	di_dev.valor_calculado AS valor_calculado_desviacion,
	rid.periodo,
	rid.unidad,

	--Normalizacion
	CASE 
        -- LÓGICA MIN-MAX: Terremotos e Inundaciones (0 a 1)
        WHEN ee.tipo_evento IN ('Terremoto', 'Inundacion') THEN
            (rid.valor - MIN(rid.valor) OVER(PARTITION BY ee.tipo_evento)) / 
            NULLIF(MAX(rid.valor) OVER(PARTITION BY ee.tipo_evento) - MIN(rid.valor) OVER(PARTITION BY ee.tipo_evento), 0)

        -- LÓGICA Z-SCORE: Sequías (Desviación del promedio)
        WHEN tipo_evento = 'Sequia' THEN
            (rid.valor - AVG(rid.valor) OVER(PARTITION BY ee.tipo_evento)) / 
            NULLIF(STDEV(rid.valor) OVER(PARTITION BY ee.tipo_evento), 0)
            
        ELSE rid.valor -- Por si hay otros eventos sin regla definida
    END AS valor_normalizado,
    

    -- Columna informativa para saber qué método se aplicó
    CASE 
        WHEN ee.tipo_evento IN ('Terremoto', 'Inundacion') THEN 'Min-Max (Escala 0-1)'
        WHEN ee.tipo_evento = 'Sequia' THEN 'Z-Score (Anomalía)'
        ELSE 'Sin normalizar'
    END AS metodo_aplicado


FROM registro_indicador rid
--LEFT JOIN dim_tiempo t ON t.fecha_registro = rid.fecha
--LEFT JOIN dim_pais dp ON dp.pais_id = rid.pais_id
--LEFT JOIN dim_fuente_datos dfd ON dfd.fuente_id = rid.fuente_datos_id
--LEFT JOIN dim_indicador di ON di.indicador_id = rid.indicador_id
LEFT JOIN desviaciones_indicadores di_dev ON di_dev.registro_indicador_id = rid.id
LEFT JOIN evento_extremo ee ON ee.id = rid.evento_extremo_id;  -- para acceder a evento_extremo 
	

SELECT*FROM desviaciones_indicadores;

--
USE dw_climate_model;

SELECT*FROM dim_tiempo;
SELECT*FROM dim_pais;
SELECT*FROM dim_fuente_datos;
SELECT*FROM dim_evento_extremo;
SELECT*FROM dim_indicador;
SELECT*FROM hechos_registro_indicador;



DELETE FROM hechos_registro_indicador;
DBCC CHECKIDENT('hechos_registro_indicador', RESEED, 1);
DELETE FROM dim_tiempo;
DBCC CHECKIDENT('dim_tiempo', RESEED, 1);
DELETE FROM dim_pais;
DBCC CHECKIDENT('dim_pais', RESEED, 1);
DELETE FROM dim_fuente_datos;
DBCC CHECKIDENT('dim_fuente_datos', RESEED, 1);
DELETE FROM dim_evento_extremo;
DBCC CHECKIDENT('dim_evento_extremo', RESEED, 1);
DELETE FROM	dim_indicador;	
DBCC CHECKIDENT('dim_indicador', RESEED, 1);


--SELECT 
    --id AS pais_id, 
    --pais_nombre, 
    --iso3, 
    --poblacion, 
    --CAST(coord_UTM.STAsText() AS NVARCHAR(MAX)) AS coord_WKT
--FROM pais;

--script para ode destination_pais	
--INSERT INTO dim_pais (pais_id, pais_nombre, iso3, poblacion, coord_utm)
--VALUES (?, ?, ?, ?, geometry::STGeomFromText(?, 4326))

--TRUNCATE TABLE [hechos_registro_indicador];
--SELECT * FROM [hechos_registro_indicador];
SELECT name FROM sys.tables WHERE name LIKE '%hechos%';


SELECT
DISTINCT
	rid.id,
	rid.fecha,
	rid.pais_id,
	rid.fuente_id,
	rid.evento_extremo_id,
	rid.indicador_nombre,
    
    -- Aplicamos TRY_CAST para asegurar compatibilidad con DECIMAL(18,4)
	TRY_CAST(rid.valor AS DECIMAL(18,4)) AS valor_registro_indicador,
	TRY_CAST(ee.valor AS DECIMAL(18,4)) AS valor_evento_extremo,
	TRY_CAST(di_dev.valor_calculado AS DECIMAL(18,4)) AS valor_calculado_desviacion,
    
	rid.periodo,
	rid.unidad,

	--Normalizacion (Se mantiene igual pero usando los valores ya limpios)
	CASE 
        WHEN ee.tipo_evento IN ('Terremoto', 'Inundacion') THEN
            (rid.valor - MIN(rid.valor) OVER(PARTITION BY ee.tipo_evento)) / 
            NULLIF(MAX(rid.valor) OVER(PARTITION BY ee.tipo_evento) - MIN(rid.valor) OVER(PARTITION BY ee.tipo_evento), 0)

        WHEN ee.tipo_evento = 'Sequia' THEN
            (rid.valor - AVG(rid.valor) OVER(PARTITION BY ee.tipo_evento)) / 
            NULLIF(STDEV(rid.valor) OVER(PARTITION BY ee.tipo_evento), 0)
            
        ELSE rid.valor 
    END AS valor_normalizado,

    CASE 
        WHEN ee.tipo_evento IN ('Terremoto', 'Inundacion') THEN 'Min-Max (Escala 0-1)'
        WHEN ee.tipo_evento = 'Sequia' THEN 'Z-Score (Anomalía)'
        ELSE 'Sin normalizar'
    END AS metodo_aplicado

FROM registro_indicador rid
LEFT JOIN desviaciones_indicadores di_dev ON di_dev.registro_indicador_id = rid.id
LEFT JOIN evento_extremo ee ON ee.id = rid.evento_extremo_id;


SELECT column_name, is_nullable, data_type 
FROM information_schema.columns 
WHERE table_name = 'hechos_registro_indicador';