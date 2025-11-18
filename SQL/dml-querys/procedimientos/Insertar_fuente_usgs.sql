
-- Ejecuta esta sentencia en tu base de datos 'Climate_model'
ALTER TABLE registro_indicador
ALTER COLUMN pais_id INT NULL; 
-- El tipo de dato (INT) puede variar, usa el tipo que definiste para pais_id.


--insertar_fuente_usgs.sql lo ejecute porque es informacion mas global

-- ESTA SENTENCIA DEBE EJECUTARSE EN SQL SERVER MANAGEMENT STUDIO (SSMS) 
-- EN LA BASE DE DATOS 'Climate_model' UNA SOLA VEZ.

INSERT INTO fuente_datos (fuente_nombre, descripcion, tipo_fuente, url)
VALUES (
    'USGS-Sismos', 
    'Datos de sismos recientes (última semana, magnitud > 4.5) del U.S. Geological Survey (USGS).', 
    'API/GeoJSON', 
    'https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/4.5_week.geojson'
);


-- solo se centra en ECuador pero usa webcrapping, no salio OJOOOOO
-- ESTA SENTENCIA DEBE EJECUTARSE EN SQL SERVER MANAGEMENT STUDIO (SSMS) 
-- EN LA BASE DE DATOS 'Climate_model' UNA SOLA VEZ.

--INSERT INTO fuente_datos (fuente_nombre, descripcion, tipo_fuente, url)
--VALUES (
    --'IGEPN-Sismos', 
    --'Informes de últimos sismos del Instituto Geofísico de Ecuador (Web Scraping).', 
    --'WebScraping', 
    --'https://www.igepn.edu.ec/portal/eventos/informes-ultimos-sismos.html'
);
-- Después de ejecutar este INSERT, vuelve a correr el script de Python.


--2025/11/12
-- Ejecuta esta sentencia en SQL Server Management Studio (SSMS)
ALTER TABLE Climate_model.dbo.registro_indicador
ALTER COLUMN periodo VARCHAR(100); -- Aumentar a un tamaño suficiente


-- a. Insertar la fuente de NASA FIRMS (Focos de Calor/Incendios)
-- Fuente robusta para reemplazar el reporte estático de WWF.
INSERT INTO fuente_datos (fuente_nombre, descripcion, tipo_fuente, url)
VALUES (
    'NASA-FIRMS-Incendios', 
    'Focos de calor y detección de incendios activos por satélite (Regional - Amazonía).', 
    'CSV/API', 
    'https://firms.modaps.eosdis.nasa.gov/api/'
);


-- b. Insertar la fuente de SISSA (Sequías)--AUN NOOOOOOOOOOOOEJECUTAR
INSERT INTO fuente_datos (fuente_nombre, descripcion, tipo_fuente, url)
VALUES (
    'SISSA-Sequias', 
    'Sistema de Información sobre Sequías para el Sur de Sudamérica (Regional). **(Requiere URL de datos)**', 
    'WebScraping/API', 
    'https://sissa.crc-sas.org/'
);



-- NOTA: El script de Python necesitará una lógica personalizada para cada una de estas fuentes.

SELECT COLUMN_NAME, DATA_TYPE, CHARACTER_MAXIMUM_LENGTH
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'registro_indicador';

sp_help registro_indicador;



--Para verificar script de Python (actualizador_datos.py) insertó los sismos
SELECT TOP 20 *
FROM registro_indicador
ORDER BY fecha DESC; -- Ordenar por fecha descendente para ver los más recientes



--2025/11/13
-- Ejecuta esta sentencia en SQL Server Management Studio (SSMS)

INSERT INTO dbo.pais (pais_nombre, iso3, poblacion, coord_UTM)
VALUES ('Región - Sudamérica', 'SAM', 0, NULL);

--verificar ingreso
SELECT * FROM dbo.pais WHERE pais_nombre = 'Región - Sudamérica';



-- Paso 2: Obtener el ID del país por defecto ('Región - Sudamérica')
--DECLARE @DefaultPaisID INT;
-- NOTA: Asume que el script 'insertar_pais_default_auto.sql' ya se ejecutó 
-- y que el país 'Región - Sudamérica' existe en la tabla dbo.pais.


-- Obtener el ID del país por defecto ('Región - Sudamérica')
DECLARE @DefaultPaisID INT;

-- NOTA: Asume que el script 'insertar_pais_default_auto.sql' ya se ejecutó 
-- y que el país 'Región - Sudamérica' existe en la tabla dbo.pais.

SELECT @DefaultPaisID = id 
FROM dbo.pais 
WHERE pais_nombre = 'Región - Sudamérica';

IF @DefaultPaisID IS NOT NULL
BEGIN
    -- Paso 2: Insertar un registro de evento por defecto para satisfacer la FK 'evento_extremo_id' 
    -- en la tabla registro_indicador, usando el ID del país.
    INSERT INTO Climate_model.dbo.evento_extremo 
    (pais_id, ubicacion, tipo_evento, descripcion, valor, fecha, coord_UTM, impacto_estimado, fuente_id, registro_id)
    VALUES 
    (@DefaultPaisID, -- <--- Valor OBLIGATORIO corregido
     'Región Sudamericana', 
     'Indicador', 
     'Registro de un sismo/foco de calor, no clasificado como evento extremo por ahora.', 
     NULL, 
     GETDATE(), 
     NULL, 
     NULL, 
     NULL, 
     NULL);
    
    PRINT '? Evento Extremo por defecto insertado exitosamente, usando pais_id: ' + CONVERT(VARCHAR, @DefaultPaisID);
END
ELSE
BEGIN
    PRINT '? CRÍTICO: No se encontró el país "Región - Sudamérica". Ejecute el Paso 1 (insertar_pais_default_auto.sql) primero.';
END


-- siguiente paso en otra query archivo TIFF
-- Paso 4: Insertar la nueva fuente de datos para Precipitación (CHIRPS)
-- Este dataset es fundamental para el componente de climatología del modelo.

