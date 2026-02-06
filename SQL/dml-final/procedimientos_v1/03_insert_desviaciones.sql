/***********************************************************************
⚠️ ADVERTENCIA IMPORTANTE — SCRIPT DE DESARROLLO

Este archivo contiene instrucciones que pueden:
- Forzar una base a SINGLE_USER
- Eliminar una base existente (DROP DATABASE)
- Recrear bases desde cero

⛔ NO ejecutar en producción.
⛔ NO usar en servidores con datos reales.

✔ Uso recomendado: entornos locales o de pruebas.
✔ Asegúrese de entender el contenido antes de ejecutarlo.

Este repositorio es de propósito educativo y de apoyo técnico.
************************************************************************/




USE Climate_model;
GO


-- ========================
-- SEED DATA:Pais
-- ========================
INSERT INTO pais(pais_nombre, iso3) 
VALUES

('Argentina', 'ARG'),
('Bolivia', 'BOL'),
('Brazil', 'BRA'),
('Chile', 'CHL'),
('Colombia', 'COL'),
('Ecuador', 'ECU'),
('Guyana', 'GUY'),
('Paraguay', 'PRY'),
('Peru', 'PER'),
('Suriname', 'SUR'),
('Uruguay', 'URY'),
('Venezuela', 'VEN');


-- Fuente_datos
-- ========================
-- Insertar campo url
ALTER TABLE fuente_datos
ADD url NVARCHAR(300);

-- ========================
-- SEED DATA:Fuente_datos
-- ========================

INSERT INTO fuente_datos (fuente_nombre, descripcion, tipo_fuente, url) VALUES
('Banco Mundial Data', 'Indicadores de emisiones CO₂ históricas (2010-2023) para Sudamérica', 'Base de datos internacional', 'https://data.worldbank.org/'),
('USGS-US', 'Sismo de 7,8 grados, frente a la costa oeste del norte del Ecuador', 'U.S. Department of the Interior','https://earthquake.usgs.gov/earthquakes/eventpage/us20005j32/executive#shakemap'),
('WMO Climate Data', 'Eventos extremos reportados por la Organización Meteorológica Mundial', 'Base de datos global', 'https://public.wmo.int/'),
('SENASA-Argentina', 'Servicio Nacional de Calidad y Sanidad Vegetal y de Semillas (Argentina)', 'Agencia nacional', 'https://www.argentina.gob.ar/senasa/micrositios/langostas'),
('SMN-Argentina', 'Servicio Meteorológico Nacional de Argentina', 'Agencia nacional', 'https://www.argentina.gob.ar/smn'),
('INUMET', 'Inundaciones', 'Instituto Uruguayo de Meteorologia', 'https://www.gub.uy/sistema-nacional-emergencias/sites/sistema-nacional-emergencias/files/documentos/publicaciones/Informe%20Inundaciones%20Enero%202019%20-%20Sinae.pdf'), 
('SciELO', 'Deslizamiento-Lluvias torrenciales en Vargas, Venezuela', 'Boletin Tecnico','https://ve.scielo.org/scielo.php?script=sci_arttext&pid=S0376-723X2003000200004'),
('SISSA', 'Sistema de Información sobre Sequías para el sur de Sudamérica (Bolivia)', 'Base de datos regional', 'https://sissa.crc-sas.org/'),
('WWF', 'World Wide Fund for Nature – Reportes de incendios en la Amazonía', 'ONG / Investigación', 'https://www.worldwildlife.org/descubre-wwf/historias/la-amazonia-registro-mas-de-50-000-focos-de-incendios-en-2024');




-- Evento_extremo
-- ========================
-- Ampliar el campo valor para soportar texto
ALTER TABLE evento_extremo
ALTER COLUMN valor NVARCHAR(100);

-- Agregar fuente_id como clave foránea
ALTER TABLE evento_extremo
ADD fuente_id INT NULL,
    CONSTRAINT FK_evento_fuente FOREIGN KEY (fuente_id) REFERENCES dbo.fuente_datos(id);


-- ========================
-- SEED DATA: Evento_extremo
-- ========================

-- 1. Longest dry period (Arica, Chile 1903-1918)
INSERT INTO evento_extremo 
    (pais_id, ubicacion, tipo_evento, descripcion, valor, fecha,
     coord_UTM, impacto_estimado, fuente_id)
VALUES
(
 (SELECT id FROM pais WHERE pais_nombre = 'Chile'),
 'Arica, Chile', 
 'Aridity', 
 'Longest dry period', 
 '172', 
 '1903-10-01', -- fecha aproximada de inicio
 geometry::STPointFromText('POINT(343900 7921800)', 32719), 
 '172 meses sin lluvias significativas (18°48''S, 70°30''W):UTM Zone 19S',
 NULL
);


-- 2. Ciclón Tropical Catarina (Brazil, 2004)
INSERT INTO evento_extremo 
    (pais_id, ubicacion, tipo_evento, descripcion, valor, fecha,
     coord_UTM, impacto_estimado, fuente_id)
VALUES
(
 (SELECT id FROM pais WHERE pais_nombre = 'Brazil'),
 'Santa Catarina, Brazil', 
 'Tropical cyclone', 
 'First identified South Atlantic hurricane', 
 NULL, 
 '2004-03-01', -- mes aproximado del huracán Catarina
 geometry::STPointFromText('POINT(500000 7006000)', 32722), 
 'Fenómeno meteorológico de fuerte intensidad en zonas tropicales (27°S, 48°W)',
 NULL
);


-- 3.  Highest temperature (Rivadavia, Argentina 1905)
INSERT INTO evento_extremo 
    (pais_id, ubicacion, tipo_evento, descripcion, valor, fecha,
     coord_UTM, impacto_estimado, fuente_id)
VALUES (
 (SELECT id FROM pais WHERE pais_nombre = 'Argentina'),
 'Rivadavia, Argentina', 
 'Continental weather and climate extremes', 
 'Highest temperature', 
 '48.9 °C', 
 '1905-12-11',
 geometry::STPointFromText('POINT(326900 7322900)', 32720), 
 'Temperatura extrema con impacto en salud y agricultura (24°10''S, 62°54''W)',
 NULL
);



-- 4. Lowest temperature (Sarmiento, Argentina 1907)
INSERT INTO evento_extremo 
    (pais_id, ubicacion, tipo_evento, descripcion, valor, fecha,
     coord_UTM, impacto_estimado, fuente_id)
VALUES (
 (SELECT id FROM pais WHERE pais_nombre = 'Argentina'),
 'Sarmiento, Argentina', 
 'Continental weather and climate extremes', 
 'Lowest temperature', 
 '-32.8 °C', 
 '1907-06-01',
 geometry::STPointFromText('POINT(266400 3975400)', 32719), 
 'Evento de bajas temperaturas con impacto local (54°21''S, 68°11''W)',
 NULL
);


-- 5. Greatest precipitation (Quibdó, Colombia 1978)
INSERT INTO evento_extremo 
    (pais_id, ubicacion, tipo_evento, descripcion, valor, fecha,
     coord_UTM, impacto_estimado, fuente_id)
VALUES (
 (SELECT id FROM pais WHERE pais_nombre = 'Colombia'),
 'Quibdo, Colombia', 
 'Continental weather and climate extremes', 
 'Greatest precipitation (average annual)', 
 '8.99 m', 
 '1978-01-01',
 geometry::STPointFromText('POINT(203100 632500)', 32618), 
 'Promedio anual de 354 in., el más alto registrado (5°41''N, 76°40''W)',
 NULL
);


-- 6.  Least precipitation (Arica, Chile 1971)
INSERT INTO evento_extremo 
    (pais_id, ubicacion, tipo_evento, descripcion, valor, fecha,
     coord_UTM, impacto_estimado, fuente_id)
VALUES(
 (SELECT id FROM pais WHERE pais_nombre = 'Chile'), 
 'Arica, Chile', 
 'Continental weather and climate extremes', 
 'Least precipitation (average annual)', 
 '0.76 mm', 
 '1971-01-01',
 geometry::STPointFromText('POINT(365600 7956800)', 32719), 
 'Arica, Chile (18°29''S, 70°18''W)',
 NULL
);


 -- 7. Terremoto Pedernales (Ecuador, zona UTM 17S)
INSERT INTO evento_extremo 
    (pais_id, ubicacion, tipo_evento, descripcion, valor, fecha,
     coord_UTM, impacto_estimado, fuente_id)
VALUES(
 (SELECT id FROM pais WHERE pais_nombre = 'Ecuador'),
 'Pedernales, Manabí (epicentro)',
 'Terremoto',
 'Subducción de las placas de Nazca y Sudamericana',
 '7.8 Mw (Magnitud Richter)',
 '2016-04-16',
 geometry::STPointFromText('POINT(594000 9958000)', 32717), -- UTM 17S
 'Consecuencias devastadoras: fallecidos, heridos y daños estructurales. Impacto económico > USD 3 mil millones',
 NULL
);


-- 8. Fenómeno El Niño (Pacífico central/oriental, UTM 15S aproximada)
INSERT INTO evento_extremo 
    (pais_id, ubicacion, tipo_evento, descripcion, valor, fecha,
     coord_UTM, impacto_estimado, fuente_id)
VALUES(
 (SELECT id FROM pais WHERE pais_nombre = 'Ecuador'),
 'Pacífico ecuatorial oriental y central',
 'Fenómeno climático global',
 'Fenómeno El Niño originado por el calentamiento de las aguas del océano Pacífico',
 NULL,
 '1997-05-01',
 geometry::STPointFromText('POINT(500000 9800000)', 32715), -- coordenada aproximada UTM zona 15S
 'Impactos a gran escala: inundaciones, sequías y alteraciones climáticas en Sudamérica',
 NULL
);


-- 9. Sequía en Chile (zona central-2019)
INSERT INTO evento_extremo 
    (pais_id, ubicacion, tipo_evento, descripcion, valor, fecha,
     coord_UTM, impacto_estimado, fuente_id)
VALUES(
 (SELECT id FROM pais WHERE pais_nombre = 'Chile'),
 'Zona central de Chile',
 'Sequía',
 'Sequía prolongada que afectó a la zona central de Chile',
 NULL,
 '2019-01-01',
 NULL,
 'Impacto en disponibilidad hídrica y producción agrícola',
 NULL
);


 -- 10. Ola de calor (Argentina, 2023)
INSERT INTO evento_extremo 
    (pais_id, ubicacion, tipo_evento, descripcion, valor, fecha,
     coord_UTM, impacto_estimado, fuente_id)
VALUES(
 (SELECT id FROM pais WHERE pais_nombre = 'Argentina'),
 'Zona central y norte de Argentina',
 'Ola de calor',
 'Temperaturas récord con impacto en salud y agricultura',
 '43 °C',
 '2023-01-01',
 NULL,
 'Afectación a la salud pública, agricultura y consumo energético',
 NULL
);


-- 11. Sequía (Bolivia, 2022)
INSERT INTO evento_extremo 
    (pais_id, ubicacion, tipo_evento, descripcion, valor, fecha,
     coord_UTM, impacto_estimado, fuente_id)
VALUES(
 (SELECT id FROM pais WHERE pais_nombre = 'Bolivia'),
 'Altiplano y valles agrícolas',
 'Sequía',
 'Sequía severa en Bolivia afectando producción agrícola',
 NULL,
 '2022-12-01',
 NULL,
 'Pérdida de cosechas y afectación a comunidades rurales',
 NULL
);


-- 12. Incendios forestales (Brazil, 2020)
INSERT INTO evento_extremo 
    (pais_id, ubicacion, tipo_evento, descripcion, valor, fecha,
     coord_UTM, impacto_estimado, fuente_id)
VALUES(
 (SELECT id FROM pais WHERE pais_nombre = 'Brazil'),
 'Amazonía brasileña',
 'Incendios forestales',
 'Incendios de gran escala en la Amazonía brasileña',
 NULL,
 '2020-09-01',
 NULL,
 'Deforestación, pérdida de biodiversidad y afectación a comunidades indígenas',
 NULL
);


-- 13. Precipitaciones extremas (Chile, 2023)
INSERT INTO evento_extremo 
    (pais_id, ubicacion, tipo_evento, descripcion, valor, fecha,
     coord_UTM, impacto_estimado, fuente_id)
VALUES(
 (SELECT id FROM pais WHERE pais_nombre = 'Chile'),
 'Norte de Chile (zonas urbanas)',
 'Precipitaciones extremas',
 'Inundaciones en zonas urbanas del norte de Chile',
 NULL,
 '2023-02-15',
 NULL,
 'Daños en infraestructura urbana y viviendas',
 NULL
);


-- 14. Plaga de langosta (Argentina, 2020)
INSERT INTO evento_extremo 
    (pais_id, ubicacion, tipo_evento, descripcion, valor, fecha,
     coord_UTM, impacto_estimado, fuente_id)
VALUES(
 (SELECT id FROM pais WHERE pais_nombre ='Argentina'),
 'Paraguay – noreste de Argentina',
 'Peligro biologico',
 'Plaga de langosta (Locust plague) ingresó desde Paraguay y avanzó por el noreste de Argentina',
 'N/A',
 '2020-06-01',
 NULL,
 'Afectó cultivos de maíz y trigo',
 NULL
);




-- ========================
-- SEED DATA: Indicadores
-- ========================

ALTER TABLE indicador
ALTER COLUMN evento_extremo_id INT NULL;


--Indicadores CO₂ (2010–2023)
INSERT INTO indicador (pais_id, fuente_id, evento_extremo_id, indicador_nombre, unidad_medida, categoria)
VALUES (
 (SELECT id FROM pais WHERE pais_nombre = 'Paraguay'),
 (SELECT id FROM fuente_datos WHERE fuente_nombre = 'Banco Mundial Data'),
 NULL,
 'CO₂ emissions', 'kt', 'Emisiones de CO₂ históricas (2010-2023)');

INSERT INTO indicador (pais_id, fuente_id, evento_extremo_id, indicador_nombre, unidad_medida, categoria)
VALUES (
 (SELECT id FROM pais WHERE pais_nombre = 'Bolivia'),
 (SELECT id FROM fuente_datos WHERE fuente_nombre = 'Banco Mundial Data'),
 NULL,
 'CO₂ emissions', 'kt', 'Emisiones de CO₂ históricas (2010-2023)');

INSERT INTO indicador (pais_id, fuente_id, evento_extremo_id, indicador_nombre, unidad_medida, categoria)
VALUES (
 (SELECT id FROM pais WHERE pais_nombre = 'Guyana'),
 (SELECT id FROM fuente_datos WHERE fuente_nombre = 'Banco Mundial Data'),
 NULL,
 'CO₂ emissions', 'kt', 'Emisiones de CO₂ históricas (2010-2023)');

INSERT INTO indicador (pais_id, fuente_id, evento_extremo_id, indicador_nombre, unidad_medida, categoria)
VALUES (
 (SELECT id FROM pais WHERE pais_nombre = 'Peru'),
 (SELECT id FROM fuente_datos WHERE fuente_nombre = 'Banco Mundial Data'),
 NULL,
 'CO₂ emissions', 'kt', 'Emisiones históricas (2010-2023)');


INSERT INTO indicador (pais_id, fuente_id, evento_extremo_id, indicador_nombre, unidad_medida, categoria)
VALUES (
 (SELECT id FROM pais WHERE pais_nombre = 'Ecuador'),
 (SELECT id FROM fuente_datos WHERE fuente_nombre = 'Banco Mundial Data'),
 NULL,
 'CO₂ emissions', 'kt', 'Emisiones históricas (2010-2023)');


INSERT INTO indicador (pais_id, fuente_id, evento_extremo_id, indicador_nombre, unidad_medida, categoria)
VALUES (
 (SELECT id FROM pais WHERE pais_nombre = 'Chile'),
 (SELECT id FROM fuente_datos WHERE fuente_nombre = 'Banco Mundial Data'),
 NULL,
 'CO₂ emissions', 'kt', 'Emisiones históricas (2010-2023)');

INSERT INTO indicador (pais_id, fuente_id, evento_extremo_id, indicador_nombre, unidad_medida, categoria)
VALUES (
 (SELECT id FROM pais WHERE pais_nombre = 'Uruguay'),
 (SELECT id FROM fuente_datos WHERE fuente_nombre = 'Banco Mundial Data'),
 NULL,
 'CO₂ emissions', 'kt', 'Emisiones históricas (2010-2023)');

INSERT INTO indicador (pais_id, fuente_id, evento_extremo_id, indicador_nombre, unidad_medida, categoria)
VALUES (
 (SELECT id FROM pais WHERE pais_nombre = 'Brazil'),
 (SELECT id FROM fuente_datos WHERE fuente_nombre = 'Banco Mundial Data'),
 NULL,
 'CO₂ emissions', 'kt', 'Emisiones históricas (2010-2023)');

INSERT INTO indicador (pais_id, fuente_id, evento_extremo_id, indicador_nombre, unidad_medida, categoria)
VALUES (
 (SELECT id FROM pais WHERE pais_nombre = 'Colombia'),
 (SELECT id FROM fuente_datos WHERE fuente_nombre = 'Banco Mundial Data'),
 NULL,
 'CO₂ emissions', 'kt', 'Emisiones históricas (2010-2023)');

INSERT INTO indicador (pais_id, fuente_id, evento_extremo_id, indicador_nombre, unidad_medida, categoria)
VALUES (
 (SELECT id FROM pais WHERE pais_nombre = 'Venezuela'),
 (SELECT id FROM fuente_datos WHERE fuente_nombre = 'Banco Mundial Data'),
 NULL,
 'CO₂ emissions', 'kt', 'Emisiones históricas (2010-2023)');

INSERT INTO indicador (pais_id, fuente_id, evento_extremo_id, indicador_nombre, unidad_medida, categoria)
VALUES (
 (SELECT id FROM pais WHERE pais_nombre = 'Argentina'),
 (SELECT id FROM fuente_datos WHERE fuente_nombre = 'Banco Mundial Data'),
 NULL,
 'CO₂ emissions', 'kt', 'Emisiones históricas (2010-2023)');

INSERT INTO indicador (pais_id, fuente_id, evento_extremo_id, indicador_nombre, unidad_medida, categoria)
VALUES (
 (SELECT id FROM pais WHERE pais_nombre = 'Suriname'),
 (SELECT id FROM fuente_datos WHERE fuente_nombre = 'Banco Mundial Data'),
 NULL,
 'CO₂ emissions', 'kt', 'Emisiones históricas (2010-2023)');

 
--Indicadores vinculados a Eventos extremos
-- 1. Terremoto Pedernales (Ecuador, 2016)
INSERT INTO indicador (pais_id, fuente_id, evento_extremo_id, indicador_nombre, unidad_medida, categoria)
VALUES (
 (SELECT id FROM pais WHERE pais_nombre = 'Ecuador'),
 (SELECT id FROM fuente_datos WHERE fuente_nombre = 'USGS-US'),
 (SELECT id FROM evento_extremo WHERE tipo_evento = 'Terremoto' AND fecha = '2016-04-16'),
 'Terremoto Pedernales', 'Mw', 'Subducción de las placas de Nazca y Sudamericana');

--PRUEBA
--SELECT id, pais_id, ubicacion, tipo_evento, fecha
--FROM evento_extremo
--WHERE tipo_evento = 'Tropical cyclone' 
--AND fecha = '2004-03-01';



-- 2. Ciclón Tropical Catarina (Brazil, 2004)
INSERT INTO indicador (pais_id, fuente_id, evento_extremo_id, indicador_nombre, unidad_medida, categoria)
SELECT 
  p.id,
  f.id,
  ee.id,
  'Ciclón Catarina',
  'Viento (km/h)',
  'Primer huracán en Atlántico Sur'
FROM evento_extremo ee
JOIN pais p ON p.pais_nombre = 'Brazil'
JOIN fuente_datos f ON f.fuente_nombre = 'WMO Climate Data'
WHERE ee.tipo_evento = 'Tropical cyclone'
AND ee.fecha = '2004-03-01';


--SELECT TOP 5 * FROM fuente_datos;
SELECT DB_NAME() AS base_actual;



-- 3. Sequía extrema en Arica (Chile, 1903–1918)
INSERT INTO indicador (pais_id, fuente_id, evento_extremo_id, indicador_nombre, unidad_medida, categoria)
VALUES (
 (SELECT id FROM pais WHERE pais_nombre = 'Chile'),
 (SELECT id FROM fuente_datos WHERE fuente_nombre = 'WMO Climate Data'),
 (SELECT id FROM evento_extremo WHERE tipo_evento = 'Aridity' AND fecha = '1903-10-01'),
 'Sequía extrema de Arica', 'P/T', 'Periodo sin lluvias (172 meses)');

-- 4. Incendios Amazónicos (Brazil, 2024)
INSERT INTO indicador (pais_id, fuente_id, evento_extremo_id, indicador_nombre, unidad_medida, categoria)
VALUES (
 (SELECT id FROM pais WHERE pais_nombre = 'Brazil'),
 (SELECT id FROM fuente_datos WHERE fuente_nombre = 'WWF'),
 (SELECT id FROM evento_extremo WHERE tipo_evento = 'Incendio forestal' AND fecha = '2024-08-01'),
 'Incendios amazónicos', 'kW m−1', 'Más de 50.000 incendios registrados');


-- 5. Sequía prolongada (Bolivia, 2016–2017)
INSERT INTO indicador (pais_id, fuente_id, evento_extremo_id, indicador_nombre, unidad_medida, categoria)
VALUES (
 (SELECT id FROM pais WHERE pais_nombre = 'Bolivia'),
 (SELECT id FROM fuente_datos WHERE fuente_nombre = 'SISSA'),
 (SELECT id FROM evento_extremo WHERE tipo_evento = 'Sequía' AND fecha = '2016-01-01'),
 'Sequía prolongada', 'P/T', 'Evento severo reportado por SISSA');



-- 6. Inundaciones en Uruguay (2019)
INSERT INTO indicador (pais_id, fuente_id, evento_extremo_id, indicador_nombre, unidad_medida, categoria)
VALUES (
 (SELECT id FROM pais WHERE pais_nombre = 'Uruguay'),
 (SELECT id FROM fuente_datos WHERE fuente_nombre = 'INUMET'),
 (SELECT id FROM evento_extremo WHERE tipo_evento = 'Inundaciones' AND fecha = '2019-04-15'),
 'Inundaciones litoral', 'mm lluvia acumulada', 'Inundaciones severas reportadas por INUMET');

 ---CORRECION A INUMET
 ---SELECT * FROM fuente_datos WHERE fuente_nombre = 'SMN';
 ---SELECT id FROM pais WHERE pais_nombre = 'Uruguay';
 ---SELECT id FROM evento_extremo WHERE tipo_evento = 'Inundación' AND fecha = '2019-04-15';


-- 7. Plaga de langostas (Argentina, 2020)
INSERT INTO indicador (pais_id, fuente_id, evento_extremo_id, indicador_nombre, unidad_medida, categoria)
VALUES (
 (SELECT id FROM pais WHERE pais_nombre = 'Argentina'),
 (SELECT id FROM fuente_datos WHERE fuente_nombre = 'Senasa-Argentina'),
 (SELECT id FROM evento_extremo WHERE tipo_evento = 'Peligro biologico' AND fecha = '2020-06-01'),
 'Plaga de langostas', 'ha', 'Impacto agrícola significativo');


-- 8. Inundaciones Colombia (2010–2011)
INSERT INTO indicador (pais_id, fuente_id, evento_extremo_id, indicador_nombre, unidad_medida, categoria)
VALUES (
 (SELECT id FROM pais WHERE pais_nombre = 'Colombia'),
 (SELECT id FROM fuente_datos WHERE fuente_nombre = 'WMO Climate Data'),
 (SELECT id FROM evento_extremo WHERE tipo_evento = 'Inundación' AND fecha = '2010-12-01'),
 'Inundaciones La Niña', 'Personas afectadas', 'Evento La Niña 2010-2011');


-- 9. Inundaciones Paraguay (2014)
INSERT INTO indicador (pais_id, fuente_id, evento_extremo_id, indicador_nombre, unidad_medida, categoria)
VALUES (
 (SELECT id FROM pais WHERE pais_nombre = 'Paraguay'),
 (SELECT id FROM fuente_datos WHERE fuente_nombre = 'WMO Climate Data'),
 (SELECT id FROM evento_extremo WHERE tipo_evento = 'Inundación' AND fecha = '2014-06-01'),
 'Inundaciones Asunción', 'Personas desplazadas', 'Crecida del río Paraguay');

-- 10. Deslizamiento de tierras (Peru, 2017)
INSERT INTO indicador (pais_id, fuente_id, evento_extremo_id, indicador_nombre, unidad_medida, categoria)
VALUES (
 (SELECT id FROM pais WHERE pais_nombre = 'Peru'),
 (SELECT id FROM fuente_datos WHERE fuente_nombre = 'WMO Climate Data'),
 (SELECT id FROM evento_extremo WHERE tipo_evento = 'Deslizamiento' AND fecha = '2017-03-15'),
 'Deslizamiento Huaycoloro', 'Viviendas afectadas', 'Fenómeno El Niño Costero');


-- 11. Inundaciones Guyana (2005)
INSERT INTO indicador (pais_id, fuente_id, evento_extremo_id, indicador_nombre, unidad_medida, categoria)
VALUES (
 (SELECT id FROM pais WHERE pais_nombre = 'Guyana'),
 (SELECT id FROM fuente_datos WHERE fuente_nombre = 'WMO Climate Data'),
 (SELECT id FROM evento_extremo WHERE tipo_evento = 'Inundación' AND fecha = '2005-01-15'),
 'Inundaciones Georgetown', 'Personas afectadas', 'Impacto económico grave');



-- 12. Deslizamientos Venezuela (1999)
INSERT INTO indicador (pais_id, fuente_id, evento_extremo_id, indicador_nombre, unidad_medida, categoria)
VALUES (
 (SELECT id FROM pais WHERE pais_nombre = 'Venezuela'),
 (SELECT id FROM fuente_datos WHERE fuente_nombre = 'SciELO'),
 (SELECT id FROM evento_extremo WHERE tipo_evento = 'Deslizamiento-Lluvia' AND fecha = '1999-12-15'),
 'Tragedia de Vargas', 'Personas fallecidas', 'Lluvias torrenciales 1999');


-- 13. Inundaciones Suriname (2006)
INSERT INTO indicador (pais_id, fuente_id, evento_extremo_id, indicador_nombre, unidad_medida, categoria)
VALUES (
 (SELECT id FROM pais WHERE pais_nombre = 'Suriname'),
 (SELECT id FROM fuente_datos WHERE fuente_nombre = 'WMO Climate Data'),
 (SELECT id FROM evento_extremo WHERE tipo_evento = 'Inundación' AND fecha = '2006-05-01'),
 'Inundaciones Suriname', 'Comunidades afectadas', 'Gran impacto en selva surinamesa');


--SELECT id, fuente_nombre 
--FROM fuente_datos
--WHERE fuente_nombre = 'WMO Climate Data';

DELETE FROM fuente_datos
WHERE fuente_nombre = 'WMO Climate Data'
AND id NOT IN (
    SELECT MIN(id) 
    FROM fuente_datos
    WHERE fuente_nombre = 'WMO Climate Data'
);

SELECT id, pais_nombre 
FROM pais
WHERE pais_nombre = 'Suriname';


-- 14. Sequía agrícola (Paraguay, 2020)
INSERT INTO indicador (pais_id, fuente_id, evento_extremo_id, indicador_nombre, unidad_medida, categoria)
VALUES (
 (SELECT id FROM pais WHERE pais_nombre = 'Paraguay'),
 (SELECT id FROM fuente_datos WHERE fuente_nombre = 'SISSA'),
 (SELECT id FROM evento_extremo WHERE tipo_evento = 'Sequía' AND fecha = '2020-08-01'),
 'Sequía agrícola', 'Millones USD', 'Impacto en cultivos y producción agrícola');


SELECT id, fuente_nombre 
FROM fuente_datos
WHERE fuente_nombre = 'SISSA';


DELETE FROM fuente_datos
WHERE fuente_nombre = 'SISSA'
AND id NOT IN (
    SELECT MIN(id) 
    FROM fuente_datos
    WHERE fuente_nombre = 'SISSA'
);

SELECT id, pais_nombre 
FROM pais
WHERE pais_nombre = 'Paraguay';


 ---EXTRA PARA EVITAR CONFLICTOS 
 --Crear tabla de Alias ---
 CREATE TABLE pais_alias (
    id INT IDENTITY(1,1) PRIMARY KEY,
    pais_id INT NOT NULL,
    alias_nombre VARCHAR(150) NOT NULL,
    FOREIGN KEY (pais_id) REFERENCES pais(id)
);


 -- 1. Venezuela
DECLARE @venezuela_id INT;
SELECT @venezuela_id = id FROM pais WHERE pais_nombre = 'Venezuela';

INSERT INTO pais_alias (pais_id, alias_nombre)
VALUES (@venezuela_id, 'Venezuela, RB'),
       (@venezuela_id, 'Bolivarian Republic of Venezuela');

-- 2. Uruguay
DECLARE @uruguay_id INT;
SELECT @uruguay_id = id FROM pais WHERE pais_nombre = 'Uruguay';

INSERT INTO pais_alias (pais_id, alias_nombre)
VALUES (@uruguay_id, 'Uruguay Oriental'),
       (@uruguay_id, 'República Oriental del Uruguay');

-- 3. Ecuador
DECLARE @ecuador_id INT;
SELECT @ecuador_id = id FROM pais WHERE pais_nombre = 'Ecuador';

INSERT INTO pais_alias (pais_id, alias_nombre)
VALUES (@ecuador_id, 'República del Ecuador');

-- 4. Colombia
DECLARE @colombia_id INT;
SELECT @colombia_id = id FROM pais WHERE pais_nombre = 'Colombia';

INSERT INTO pais_alias (pais_id, alias_nombre)
VALUES (@colombia_id, 'República de Colombia');

-- 5. Chile
DECLARE @chile_id INT;
SELECT @chile_id = id FROM pais WHERE pais_nombre = 'Chile';

INSERT INTO pais_alias (pais_id, alias_nombre)
VALUES (@chile_id, 'República de Chile');

-- 6. Argentina
DECLARE @argentina_id INT;
SELECT @argentina_id = id FROM pais WHERE pais_nombre = 'Argentina';

INSERT INTO pais_alias (pais_id, alias_nombre)
VALUES (@argentina_id, 'República Argentina');

-- 7. Brazil
DECLARE @brazil_id INT;
SELECT @brazil_id = id FROM pais WHERE pais_nombre = 'Brazil';

INSERT INTO pais_alias (pais_id, alias_nombre)
VALUES (@brazil_id, 'República Federativa del Brazil'),
       (@brazil_id, 'Brasil');


-- 8. Bolivia
DECLARE @bolivia_id INT;
SELECT @bolivia_id = id FROM pais WHERE pais_nombre = 'Bolivia';

INSERT INTO pais_alias (pais_id, alias_nombre)
VALUES (@bolivia_id, 'Estado Plurinacional de Bolivia');


-- 9. Peru
DECLARE @peru_id INT;
SELECT @peru_id = id FROM pais WHERE pais_nombre = 'Peru';

INSERT INTO pais_alias (pais_id, alias_nombre)
VALUES (@peru_id, 'Perú');


-- 10. Paraguay
DECLARE @paraguay_id INT;
SELECT @paraguay_id = id FROM pais WHERE pais_nombre = 'Paraguay';

INSERT INTO pais_alias (pais_id, alias_nombre)
VALUES (@paraguay_id, 'República del Paraguay');



-- 11. Guyana
DECLARE @guyana_id INT;
SELECT @guyana_id = id FROM pais WHERE pais_nombre = 'Guyana';

INSERT INTO pais_alias (pais_id, alias_nombre)
VALUES (@guyana_id, 'Co-operative Republic of Guyana'),
       (@guyana_id, 'Republica Cooperativa dde Guyana');

-- 12. Suriname
DECLARE @suriname_id INT;
SELECT @suriname_id = id FROM pais WHERE pais_nombre = 'Suriname';

INSERT INTO pais_alias (pais_id, alias_nombre)
VALUES (@suriname_id, 'Republic of Suriname'), 
       (@suriname_id,'República de Surinam');




--Registro indicador 
--Insertar campo periodo
ALTER TABLE registro_indicador
ADD periodo VARCHAR(20) NULL;

ALTER TABLE registro_indicador
ALTER COLUMN fecha DATE NULL;

-- ========================
-- SEED DATA: Registro indicador
-- ========================
--Indicadores historicos

INSERT INTO registro_indicador (pais_id, fuente_id, fecha, indicador_nombre, valor, unidad, periodo)
VALUES(
 (SELECT id FROM pais WHERE pais_nombre = 'Paraguay'),
 (SELECT id FROM fuente_datos WHERE fuente_nombre = 'Banco Mundial Data'),
 NULL,  -- sin fecha puntual
 'Emisiones de CO₂ históricas',
 NULL,  -- aún no hay valor numérico
 'kt', '2010-2023');



--SELECT id, pais_nombre FROM pais WHERE pais_nombre = 'Paraguay';
SELECT id, fuente_nombre FROM fuente_datos WHERE fuente_nombre = 'Banco Mundial Data';


SELECT id, pais_nombre 
FROM pais
WHERE pais_nombre = 'Paraguay';

DELETE FROM fuente_datos
WHERE fuente_nombre = 'Banco Mundial Data'
AND id NOT IN (
   SELECT MIN(id) 
   FROM fuente_datos
   WHERE fuente_nombre = 'Banco Mundial Data'
);


INSERT INTO registro_indicador (pais_id, fuente_id, fecha, indicador_nombre, valor, unidad, periodo)
VALUES(
 (SELECT id FROM pais WHERE pais_nombre = 'Bolivia'),
 (SELECT id FROM fuente_datos WHERE fuente_nombre = 'Banco Mundial Data'),
 NULL, 'Emisiones de CO₂ históricas', NULL, 'kt', '2010-2023');



INSERT INTO registro_indicador (pais_id, fuente_id, fecha, indicador_nombre, valor, unidad, periodo)
VALUES(
 (SELECT id FROM pais WHERE pais_nombre = 'Guyana'),
 (SELECT id FROM fuente_datos WHERE fuente_nombre = 'Banco Mundial Data'),
 NULL, 'Emisiones de CO₂ históricas', NULL, 'kt', '2010-2023');



INSERT INTO registro_indicador (pais_id, fuente_id, fecha, indicador_nombre, valor, unidad, periodo)
VALUES(
 (SELECT id FROM pais WHERE pais_nombre = 'Peru'),
 (SELECT id FROM fuente_datos WHERE fuente_nombre = 'Banco Mundial Data'),
 NULL, 'Emisiones de CO₂ históricas', NULL, 'kt', '2010-2023');



INSERT INTO registro_indicador (pais_id, fuente_id, fecha, indicador_nombre, valor, unidad, periodo)
VALUES(
 (SELECT id FROM pais WHERE pais_nombre = 'Ecuador'),
 (SELECT id FROM fuente_datos WHERE fuente_nombre = 'Banco Mundial Data'),
 NULL, 'Emisiones de CO₂ históricas', NULL, 'kt', '2010-2023');



INSERT INTO registro_indicador (pais_id, fuente_id, fecha, indicador_nombre, valor, unidad, periodo)
VALUES(
 (SELECT id FROM pais WHERE pais_nombre = 'Chile'),
 (SELECT id FROM fuente_datos WHERE fuente_nombre = 'Banco Mundial Data'),
 NULL, 'Emisiones de CO₂ históricas', NULL, 'kt', '2010-2023');



INSERT INTO registro_indicador (pais_id, fuente_id, fecha, indicador_nombre, valor, unidad, periodo)
VALUES(
 (SELECT id FROM pais WHERE pais_nombre = 'Uruguay'),
 (SELECT id FROM fuente_datos WHERE fuente_nombre = 'Banco Mundial Data'),
 NULL, 'Emisiones de CO₂ históricas', NULL, 'kt', '2010-2023');



INSERT INTO registro_indicador (pais_id, fuente_id, fecha, indicador_nombre, valor, unidad, periodo)
VALUES(
 (SELECT id FROM pais WHERE pais_nombre = 'Brazil'),
 (SELECT id FROM fuente_datos WHERE fuente_nombre = 'Banco Mundial Data'),
 NULL, 'Emisiones de CO₂ históricas', NULL, 'kt', '2010-2023');



INSERT INTO registro_indicador (pais_id, fuente_id, fecha, indicador_nombre, valor, unidad, periodo)
VALUES(
 (SELECT id FROM pais WHERE pais_nombre = 'Colombia'),
 (SELECT id FROM fuente_datos WHERE fuente_nombre = 'Banco Mundial Data'),
 NULL, 'Emisiones de CO₂ históricas', NULL, 'kt', '2010-2023');



INSERT INTO registro_indicador (pais_id, fuente_id, fecha, indicador_nombre, valor, unidad, periodo)
VALUES(
 (SELECT id FROM pais WHERE pais_nombre = 'Venezuela'),
 (SELECT id FROM fuente_datos WHERE fuente_nombre = 'Banco Mundial Data'),
 NULL, 'Emisiones de CO₂ históricas', NULL, 'kt', '2010-2023');



INSERT INTO registro_indicador (pais_id, fuente_id, fecha, indicador_nombre, valor, unidad, periodo)
VALUES(
 (SELECT id FROM pais WHERE pais_nombre = 'Argentina'),
 (SELECT id FROM fuente_datos WHERE fuente_nombre = 'Banco Mundial Data'),
 NULL, 'Emisiones de CO₂ históricas', NULL, 'kt', '2010-2023');



INSERT INTO registro_indicador (pais_id, fuente_id, fecha, indicador_nombre, valor, unidad, periodo)
VALUES(
 (SELECT id FROM pais WHERE pais_nombre = 'Suriname'),
 (SELECT id FROM fuente_datos WHERE fuente_nombre = 'Banco Mundial Data'),
 NULL, 'Emisiones de CO₂ históricas', NULL, 'kt', '2010-2023');


  --Registro indicador-Eventos extremos--
 -- Ecuador - Terremoto Pedernales (2016)
INSERT INTO registro_indicador (pais_id, fuente_id, fecha, indicador_nombre, valor, unidad, periodo)
VALUES (
 (SELECT id FROM pais WHERE pais_nombre = 'Ecuador'),
 (SELECT id FROM fuente_datos WHERE fuente_nombre = 'USGS-US'),
 '2016-04-16', 'Terremoto Pedernales', NULL, 'Mw', NULL
);

SELECT id, pais_nombre 
FROM pais
WHERE pais_nombre = 'Ecuador';

DELETE FROM fuente_datos
WHERE fuente_nombre = 'USGS-US'
AND id NOT IN (
   SELECT MIN(id) 
   FROM fuente_datos
   WHERE fuente_nombre = 'USGS-US'
);


-- Brazil - Ciclón Tropical Catarina (2004)
INSERT INTO registro_indicador (pais_id, fuente_id, fecha, indicador_nombre, valor, unidad, periodo)
VALUES (
 (SELECT id FROM pais WHERE pais_nombre = 'Brazil'),
 (SELECT id FROM fuente_datos WHERE fuente_nombre = 'WMO Climate Data'),
 '2004-03-01', 'Ciclón Catarina', NULL, 'Viento (km/h)', NULL
);


-- Chile - Sequía extrema de Arica (1903–1918)
INSERT INTO registro_indicador (pais_id, fuente_id, fecha, indicador_nombre, valor, unidad, periodo)
VALUES (
 (SELECT id FROM pais WHERE pais_nombre = 'Chile'),
 (SELECT id FROM fuente_datos WHERE fuente_nombre = 'WMO Climate Data'),
 '1903-10-01', 'Sequía extrema de Arica', NULL, 'P/T', '1903-1918'
);


-- Brazil - Incendios amazónicos (2024)
INSERT INTO registro_indicador (pais_id, fuente_id, fecha, indicador_nombre, valor, unidad, periodo)
VALUES (
 (SELECT id FROM pais WHERE pais_nombre = 'Brazil'),
 (SELECT id FROM fuente_datos WHERE fuente_nombre = 'WWF'),
 '2024-08-01', 'Incendios amazónicos', NULL, 'kW m−1', NULL
);

SELECT id, pais_nombre 
FROM pais
WHERE pais_nombre = 'Brazil';

DELETE FROM fuente_datos
WHERE fuente_nombre = 'WWF'
AND id NOT IN (
   SELECT MIN(id) 
   FROM fuente_datos
   WHERE fuente_nombre = 'WWF'
);


-- Bolivia - Sequía prolongada (2016–2017)
INSERT INTO registro_indicador (pais_id, fuente_id, fecha, indicador_nombre, valor, unidad, periodo)
VALUES (
 (SELECT id FROM pais WHERE pais_nombre = 'Bolivia'),
 (SELECT id FROM fuente_datos WHERE fuente_nombre = 'SISSA'),
 '2016-01-01', 'Sequía prolongada', NULL, 'P/T', '2016-2017'
);


-- Uruguay - Inundaciones litoral (2019)
INSERT INTO registro_indicador (pais_id, fuente_id, fecha, indicador_nombre, valor, unidad, periodo)
VALUES (
 (SELECT id FROM pais WHERE pais_nombre = 'Uruguay'),
 (SELECT id FROM fuente_datos WHERE fuente_nombre = 'INUMET'),
 '2019-04-15', 'Inundaciones litoral uruguayo', NULL, 'mm lluvia acumulada', NULL
);

SELECT id, pais_nombre 
FROM pais
WHERE pais_nombre = 'Uruguay';

DELETE FROM fuente_datos
WHERE fuente_nombre = 'INUMET'
AND id NOT IN (
   SELECT MIN(id) 
   FROM fuente_datos
   WHERE fuente_nombre = 'INUMET'
);


-- Argentina - Plaga de langostas (2020)
INSERT INTO registro_indicador (pais_id, fuente_id, fecha, indicador_nombre, valor, unidad, periodo)
VALUES (
 (SELECT id FROM pais WHERE pais_nombre = 'Argentina'),
 (SELECT id FROM fuente_datos WHERE fuente_nombre = 'Senasa-Argentina'),
 '2020-06-01', 'Plaga de langostas', NULL, 'ha', NULL
);

SELECT id, pais_nombre 
FROM pais
WHERE pais_nombre = 'Argentina';

DELETE FROM fuente_datos
WHERE fuente_nombre = 'Senasa-Argentina'
AND id NOT IN (
   SELECT MIN(id) 
   FROM fuente_datos
   WHERE fuente_nombre = 'Senasa-Argentina'
);


-- Colombia - Inundaciones La Niña (2010–2011)
INSERT INTO registro_indicador (pais_id, fuente_id, fecha, indicador_nombre, valor, unidad, periodo)
VALUES (
 (SELECT id FROM pais WHERE pais_nombre = 'Colombia'),
 (SELECT id FROM fuente_datos WHERE fuente_nombre = 'WMO Climate Data'),
 '2010-12-01', 'Inundaciones La Niña', NULL, 'Personas afectadas', '2010-2011'
);

-- Paraguay - Inundaciones por crecida (2014)
INSERT INTO registro_indicador (pais_id, fuente_id, fecha, indicador_nombre, valor, unidad, periodo)
VALUES (
 (SELECT id FROM pais WHERE pais_nombre = 'Paraguay'),
 (SELECT id FROM fuente_datos WHERE fuente_nombre = 'WMO Climate Data'),
 '2014-06-01', 'Inundaciones por crecida del río Paraguay', NULL, 'Personas desplazadas', NULL
);

-- Peru - Deslizamiento Huaycoloro (2017)
INSERT INTO registro_indicador (pais_id, fuente_id, fecha, indicador_nombre, valor, unidad, periodo)
VALUES (
 (SELECT id FROM pais WHERE pais_nombre = 'Peru'),
 (SELECT id FROM fuente_datos WHERE fuente_nombre = 'WMO Climate Data'),
 '2017-03-15', 'Deslizamiento Huaycoloro', NULL, 'Viviendas afectadas', NULL
);

-- Guyana - Inundaciones Georgetown (2005)
INSERT INTO registro_indicador (pais_id, fuente_id, fecha, indicador_nombre, valor, unidad, periodo)
VALUES (
 (SELECT id FROM pais WHERE pais_nombre = 'Guyana'),
 (SELECT id FROM fuente_datos WHERE fuente_nombre = 'WMO Climate Data'),
 '2005-01-15', 'Inundaciones en Georgetown', NULL, 'Personas afectadas', NULL
);

-- Venezuela - Tragedia de Vargas (1999)
INSERT INTO registro_indicador (pais_id, fuente_id, fecha, indicador_nombre, valor, unidad, periodo)
VALUES (
 (SELECT id FROM pais WHERE pais_nombre = 'Venezuela'),
 (SELECT id FROM fuente_datos WHERE fuente_nombre = 'WMO Climate Data'),
 '1999-12-15', 'Tragedia de Vargas', NULL, 'Personas fallecidas', NULL
);

-- Suriname - Inundaciones (2006)
INSERT INTO registro_indicador (pais_id, fuente_id, fecha, indicador_nombre, valor, unidad, periodo)
VALUES (
 (SELECT id FROM pais WHERE pais_nombre = 'Suriname'),
 (SELECT id FROM fuente_datos WHERE fuente_nombre = 'WMO Climate Data'),
 '2006-05-01', 'Inundaciones Suriname', NULL, 'Comunidades afectadas', NULL
);

-- Paraguay -Sequia agrícola (2020)
INSERT INTO registro_indicador (pais_id, fuente_id, fecha, indicador_nombre, valor, unidad, periodo) VALUES 
((SELECT id FROM pais WHERE pais_nombre = 'Paraguay'),
  (SELECT id FROM fuente_datos WHERE fuente_nombre = 'SISSA'),
  '2020-08-01',
  'Sequía agrícola',
  NULL,
  'Millones USD',
  NULL  -- sin rango
);


---Desviaciones indicadores---
-- Eliminamos columnas poco flexibles
ALTER TABLE desviaciones_indicadores
DROP COLUMN diferencia_absoluta;

ALTER TABLE desviaciones_indicadores
DROP COLUMN diferencia_porcentual;


-- Agregamos columnas más generales
ALTER TABLE desviaciones_indicadores
ADD evento_extremo_id INT NULL,             -- opcional: vincula a evento extremo
    tipo_desviacion VARCHAR(50) NOT NULL,
    valor_calculado DECIMAL(20,5) NOT NULL,
    unidad_resultado VARCHAR(50) NULL,      -- ejemplo: %, Mw, mm, kt
    metodologia VARCHAR(50) NULL;
   
--clasificacion_alertas                             -- ejemplo: 'Baja', 'Media', 'Alta', 'Crítica'



-- ========================
-- SEED DATA: Desviaciones indicadores
-- ========================

--1.  Promedio de CO₂ (2010–2023) por país
INSERT INTO desviaciones_indicadores (registro_indicador_id, evento_extremo_id, tipo_desviacion,
    valor_calculado, unidad_resultado, metodologia, clasificacion_alertas)
SELECT ri.id,
       NULL,-- no hay evento asociado
       'Promedio',
       AVG(ri.valor) OVER (PARTITION BY ri.pais_id),
       'kt',
       'Promedio simple sobre serie 2010–2023',
       'Referencia'
FROM registro_indicador ri
JOIN pais p ON ri.pais_id = p.id
WHERE ri.indicador_nombre = 'Emisiones de CO₂ históricas'
  AND ri.periodo = '2010-2023'
  AND ri.valor IS NOT NULL;   -- evita valores nulos;


--2.  Desviación estándar de CO₂ (2010–2023) por país
INSERT INTO desviaciones_indicadores (registro_indicador_id, evento_extremo_id, tipo_desviacion,
    valor_calculado, unidad_resultado, metodologia, clasificacion_alertas)
SELECT ri.id,
       NULL, 
       'Desviación estándar',
       STDEV(ri.valor) OVER (PARTITION BY ri.pais_id),
       'kt',
       'STDEV sobre serie 2010–2023',
       'Referencia'
FROM registro_indicador ri
JOIN pais p ON ri.pais_id = p.id
WHERE ri.indicador_nombre = 'Emisiones de CO₂ históricas'
  AND ri.periodo = '2010-2023'
  AND ri.valor IS NOT NULL;


--3.  Terremoto: anomalía sísmica
INSERT INTO desviaciones_indicadores (registro_indicador_id, evento_extremo_id, tipo_desviacion, 
    valor_calculado, unidad_resultado, metodologia, clasificacion_alertas)
SELECT ri.id, 
       ee.id,
       'Anomalía sísmica, Magnitud Momento (Mw)', -- 🔑 enlazamos con evento_extremo
       ri.valor, -- AVG(ri.valor) OVER (PARTITION BY ri.pais_id),
       'Mw',
       'USGS - Escala de magnitud momento',--Diferencia respecto al promedio histórico de sismos en Ecuador',
       CASE 
          WHEN ri.valor >= 8   THEN 'Gran terremoto'
          WHEN ri.valor >= 7   THEN 'Mayor'
          WHEN ri.valor >= 6   THEN 'Fuerte'
          WHEN ri.valor >= 5   THEN 'Moderado'
          ELSE 'Leve'
       END
FROM registro_indicador ri
JOIN evento_extremo ee 
     ON ri.pais_id = ee.pais_id
    AND ri.fecha   = ee.fecha
WHERE ee.tipo_evento = 'Terremoto'
AND ri.valor IS NOT NULL;



--4.  Inundaciones Uruguay (2019): variación de precipitaciones
INSERT INTO desviaciones_indicadores (registro_indicador_id, evento_extremo_id, tipo_desviacion,
    valor_calculado, unidad_resultado, metodologia, clasificacion_alertas)
SELECT ri.id,
       ee.id,
       'Variación porcentual',
       ((ri.valor - hist.promedio) / hist.promedio) * 100 AS valor_calculado,
       '%',
       'Var al promedio histórico de precipitaciones',
       CASE 
          WHEN ((ri.valor - hist.promedio) / hist.promedio) * 100 >= 50 THEN 'Alta'
          ELSE 'Moderada'
       END
FROM registro_indicador ri
JOIN evento_extremo ee 
     ON ri.pais_id = ee.pais_id
     AND ri.fecha   = ee.fecha
JOIN(
    SELECT pais_id, AVG(valor) AS promedio
    FROM registro_indicador
    WHERE indicador_nombre = 'Precipitaciones'
    GROUP BY pais_id
) hist ON ri.pais_id = hist.pais_id
WHERE ri.indicador_nombre = 'Precipitaciones'
  AND ee.tipo_evento = 'Inundación';




--5. Plaga de langostas en Argentina 2020 (impacto social)
INSERT INTO desviaciones_indicadores (registro_indicador_id, evento_extremo_id, tipo_desviacion,
    valor_calculado, unidad_resultado, metodologia, clasificacion_alertas)
SELECT 
    ri.id, 
    ee.id, 
    'Impacto agrícola',
    ri.valor,
    'ha', 
    'Registro directo de área afectada',
    CASE
       WHEN ri.valor >= 100000 THEN 'Crítica'
       WHEN ri.valor >= 50000  THEN 'Alta'
       ELSE 'Moderada'
    END
FROM registro_indicador ri
JOIN evento_extremo ee
     ON ri.pais_id = ee.pais_id
    AND ri.fecha   = ee.fecha
WHERE ri.indicador_nombre = 'Plaga de langostas'
  AND ee.tipo_evento = 'Plaga';



--6. Incendios forestales (Brazil, 2020)
INSERT INTO desviaciones_indicadores (registro_indicador_id, evento_extremo_id, tipo_desviacion,
    valor_calculado, unidad_resultado, metodologia, clasificacion_alertas)
SELECT 
    ri.id,
    ee.id,
    'Intensidad de incendio',
    ri.valor,
    'kW/m',
    'Clasificación por intensidad directa',
    CASE
       WHEN ri.valor >= 10000 THEN 'Crítica'
       WHEN ri.valor >= 5000  THEN 'Alta'
       WHEN ri.valor >= 1000  THEN 'Moderada'
       ELSE 'Baja'
    END
FROM registro_indicador ri
JOIN evento_extremo ee
     ON ri.pais_id = ee.pais_id
    AND ri.fecha   = ee.fecha
WHERE ri.indicador_nombre = 'Incendios amazónicos'
  AND ee.tipo_evento = 'Incendio forestal';



--7. Ciclón Tropical Catarina (Brazil, 2004)
INSERT INTO desviaciones_indicadores (registro_indicador_id, evento_extremo_id, tipo_desviacion,
    valor_calculado, unidad_resultado, metodologia, clasificacion_alertas)
SELECT 
    ri.id,
    ee.id,
    'Categoría ciclón',
    ri.valor,
    'km/h',
    'Escala Saffir-Simpson',
    CASE
       WHEN ri.valor >= 252 THEN 'Categoría 5'
       WHEN ri.valor >= 209 THEN 'Categoría 4'
       WHEN ri.valor >= 178 THEN 'Categoría 3'
       WHEN ri.valor >= 154 THEN 'Categoría 2'
       WHEN ri.valor >= 119 THEN 'Categoría 1'
       ELSE 'Tormenta tropical'
    END
FROM registro_indicador ri
JOIN evento_extremo ee
     ON ri.pais_id = ee.pais_id
    AND ri.fecha   = ee.fecha
WHERE ri.indicador_nombre = 'Ciclón Catarina'
  AND ee.tipo_evento = 'Ciclón';


--8. Sequias -- ✅ SPI ya en desviaciones estándar
INSERT INTO desviaciones_indicadores (registro_indicador_id, evento_extremo_id, tipo_desviacion,
    valor_calculado, unidad_resultado, metodologia, clasificacion_alertas)
SELECT 
    ri.id,
    ee.id,
    'Índice de sequía (SPI)',
    ri.valor,
    'Desviación estándar',
    'SPI - Standardized Precipitation Index',
    CASE
       WHEN ri.valor <= -2   THEN 'Sequía extrema'
       WHEN ri.valor <= -1.5 THEN 'Sequía severa'
       WHEN ri.valor <= -1   THEN 'Sequía moderada'
       ELSE 'Normal'
    END
FROM registro_indicador ri
JOIN evento_extremo ee
     ON ri.pais_id = ee.pais_id
    AND ri.fecha   = ee.fecha
WHERE ee.tipo_evento = 'Sequía';


---EJERCIOS DE VALIACION ---HAY 1 REPETIDa
--1️⃣ Verificar que todos los indicadores de CO₂ tienen valor y periodo correcto (2010–2023)
SELECT pais_id, indicador_nombre, valor, periodo
FROM registro_indicador
WHERE indicador_nombre = 'Emisiones de CO₂ históricas'
AND (valor IS NULL OR periodo <> '2010-2023');

SELECT*FROM CO2;

EXEC sp_rename 'CO2.column1', 'Pais', 'COLUMN';
EXEC sp_rename 'CO2.column2', 'ISO3', 'COLUMN';
EXEC sp_rename 'CO2.column3', '2010', 'COLUMN';
EXEC sp_rename 'CO2.column4', '2011', 'COLUMN';
EXEC sp_rename 'CO2.column5', '2012', 'COLUMN';
EXEC sp_rename 'CO2.column6', '2013', 'COLUMN';
EXEC sp_rename 'CO2.column7', '2014', 'COLUMN';
EXEC sp_rename 'CO2.column8', '2015', 'COLUMN';
EXEC sp_rename 'CO2.column9', '2016', 'COLUMN';
EXEC sp_rename 'CO2.column10', '2017', 'COLUMN';
EXEC sp_rename 'CO2.column11', '2018', 'COLUMN';
EXEC sp_rename 'CO2.column12', '2019', 'COLUMN';
EXEC sp_rename 'CO2.column13', '2020', 'COLUMN';
EXEC sp_rename 'CO2.column14', '2021', 'COLUMN';
EXEC sp_rename 'CO2.column15', '2022', 'COLUMN';
EXEC sp_rename 'CO2.column16', '2023', 'COLUMN';



SELECT DB_NAME() AS BaseActual;
SELECT name 
FROM sys.databases;

SELECT TOP 10 *
FROM dbo.CO2;


--Paso 1: Eliminar la fila de encabezados (ya lo ejecute)
DELETE FROM Climate_model.dbo.CO2
WHERE Pais = 'Pais';


-- 2) Crear la tabla staging (para UNPIVOT):
CREATE TABLE Climate_model.dbo.CO2_staging (
    Pais NVARCHAR(200),
    ISO3 CHAR(3),
    Año INT,
    Valor DECIMAL(20,5)
);

TRUNCATE TABLE Climate_model.dbo.CO2_staging;


----desde AQUI PROBLEMA OJOOOOOOOOOOOOOOOO

USE Climate_model;
GO
SELECT TABLE_SCHEMA, TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE';


-- 1) Ver los nombres exactos de las columnas de la tabla original
SELECT COLUMN_NAME, ORDINAL_POSITION
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'dbo' AND TABLE_NAME = 'CO2'
ORDER BY ORDINAL_POSITION;

-- 2) Ver primeras filas (para confirmar si quedó la fila cabecera "Pais")
SELECT TOP 10 * FROM dbo.CO2;

-- sólo si aún no existen los backups
IF OBJECT_ID('dbo.CO2_backup','U') IS NULL
    SELECT * INTO dbo.CO2_backup FROM dbo.CO2;

IF OBJECT_ID('dbo.CO2_staging_backup','U') IS NULL
    SELECT * INTO dbo.CO2_staging_backup FROM dbo.CO2_staging;

---10-10-2025 
USE Climate_model;
GO

-- 1) Elimina staging si existe
IF OBJECT_ID('dbo.CO2_staging','U') IS NOT NULL
    DROP TABLE dbo.CO2_staging;
GO

-- 2) Crea la tabla staging con las columnas correctas
CREATE TABLE dbo.CO2_staging (
    Pais NVARCHAR(200),
    ISO3 NVARCHAR(10),
    Anio INT,
    Valor DECIMAL(20,5)
);
GO


-- 3️⃣  Generar el CROSS APPLY dinámico
---------------------------------------------------
-- a. Declaramos las variables
DECLARE @cols NVARCHAR(MAX);
DECLARE @sql  NVARCHAR(MAX);

-- b. Detectamos automáticamente las columnas que son años
;WITH YearCols AS (
    SELECT COLUMN_NAME
    FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_SCHEMA = 'dbo'
      AND TABLE_NAME = 'CO2'
      AND TRY_CAST(COLUMN_NAME AS INT) IS NOT NULL   -- detecta columnas de año
)
-- 3️⃣ Construimos la lista dinámica de columnas para UNPIVOT
SELECT @cols = STRING_AGG(
    CONCAT('(''', COLUMN_NAME, ''', TRY_CAST(c.[', COLUMN_NAME, '] AS DECIMAL(20,5)))'),
    ','
)
FROM YearCols;

-- 4️⃣ Verificamos que haya columnas válidas
IF @cols IS NULL OR LTRIM(RTRIM(@cols)) = ''
BEGIN
    RAISERROR('❌ No se encontraron columnas de año en dbo.CO2. Revisa los nombres.',16,1);
    RETURN;
END;

-- 5️⃣ Armamos el SQL dinámico que hace el UNPIVOT
SET @sql = N'
INSERT INTO dbo.CO2_staging (Pais, ISO3, Anio, Valor)
SELECT c.Pais, c.ISO3, v.Anio, v.Valor
FROM dbo.CO2 AS c
CROSS APPLY (VALUES
    ' + @cols + '
) AS v(Anio, Valor)
WHERE TRY_CAST(v.Valor AS DECIMAL(20,5)) IS NOT NULL;';

-- 6️⃣ (Opcional) Muestra lo que se va a ejecutar
PRINT @sql;

-- 7️⃣ Ejecutamos el SQL dinámico
EXEC sp_executesql @sql;

-- 8️⃣ Verificamos resultados
SELECT TOP (20) * FROM dbo.CO2_staging;


--🧩 PASO 1 — Verificar tablas existentes
SELECT TABLE_SCHEMA, TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_NAME IN ('CO2', 'CO2_staging');

EXEC sp_help 'dbo.CO2';
EXEC sp_help 'dbo.CO2_staging';

--🧩 PASO 3 — Verificar cantidad de filas
SELECT 
    (SELECT COUNT(*) FROM dbo.CO2) AS Total_CO2,
    (SELECT COUNT(*) FROM dbo.CO2_staging) AS Total_CO2_staging;

--🔍 Consultas básicas sobre tus datos
-- Valor de CO₂ para un país y año específicos

SELECT 
    Pais,
    ISO3,
    Anio,
    Valor AS kilotones_CO2
FROM dbo.CO2_staging
WHERE Pais = 'Colombia'
  AND Anio = 2018;

--Ver el promedio de CO₂ por país
SELECT 
    Pais,
    ISO3,
    AVG(Valor) AS Promedio_CO2
FROM dbo.CO2_staging
GROUP BY Pais, ISO3
ORDER BY Promedio_CO2 DESC;

--Comparar un año entre países (por ejemplo 2018)
SELECT 
    Pais,
    ISO3,
    Valor AS kilotones_CO2
FROM dbo.CO2_staging
WHERE Anio = 2021
ORDER BY Valor DESC;

--Ver tendencia de un país (crecimiento o reducción)
SELECT 
    Pais,
    MIN(Valor) AS Min_CO2,
    MAX(Valor) AS Max_CO2,
    (MAX(Valor) - MIN(Valor)) AS Diferencia,
    ((MAX(Valor) - MIN(Valor)) / MIN(Valor)) * 100 AS Porcentaje_Cambio
FROM dbo.CO2_staging
WHERE Pais = 'Colombia'
GROUP BY Pais;

--Top 5 países con mayor CO₂ en el año más reciente (por ejemplo 2023)
SELECT TOP 5
    Pais,
    ISO3,
    Valor AS CO2_2023
FROM dbo.CO2_staging
WHERE Anio = 2023
ORDER BY Valor DESC;

--Consulta: Matriz comparativa de emisiones por país y año
SELECT 
    Pais,
    ISO3,
    [2010], [2011], [2012], [2013], [2014],
    [2015], [2016], [2017], [2018], [2019],
    [2020], [2021], [2022], [2023]
FROM dbo.CO2_staging
PIVOT (
    AVG(Valor)
    FOR Anio IN (
        [2010], [2011], [2012], [2013], [2014],
        [2015], [2016], [2017], [2018], [2019],
        [2020], [2021], [2022], [2023]
    )
) AS pvt
ORDER BY Pais;

-- Compara valores entre CO2 original y reconstruido desde staging
SELECT 
    a.Pais,
    a.ISO3,
    a.[2018] AS Valor_Original,
    b.[2018] AS Valor_Staging_Reconstruido,
    CASE 
        WHEN a.[2018] = b.[2018] THEN 'OK'
        ELSE '⚠️ Diferente'
    END AS Comparacion
FROM dbo.CO2 a
LEFT JOIN (
    SELECT 
        Pais, ISO3, [2018]
    FROM dbo.CO2_staging
    PIVOT (
        AVG(Valor)
        FOR Anio IN ([2018])
    ) AS pvt
) b ON a.ISO3 = b.ISO3;



--1️⃣ Insertar datos de emisiones de CO₂ al registro_indicador
-- ================================================
INSERT INTO registro_indicador (
    pais_id,
    fuente_id,
    fecha,
    indicador_nombre,
    valor,
    unidad, 
    periodo  
)
SELECT 
    p.id AS pais_id,
    f.id AS fuente_id,
    DATEFROMPARTS(s.Anio, 1,1) AS fecha,
    'Emisiones de CO₂ históricas' AS indicador_nombre,
    s.Valor AS valor,
    'kt' AS unidad,
    s.Anio AS periodo
FROM dbo.CO2_staging s
JOIN dbo.pais p
    ON p.iso3 = s.ISO3
JOIN dbo.fuente_datos f
    ON f.fuente_nombre = 'Banco Mundial Data';
   
--Parta consultar lo que existe en la tabla--
sp_help evento_extremo;

 
 --SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'fuente_datos';

--para confirmar que column existen y su nombre
SELECT COLUMN_NAME, ORDINAL_POSITION, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'registro_indicador'
ORDER BY ORDINAL_POSITION;


---ojo aquiiiiiiii
INSERT INTO registro_indicador (
    pais_id,
    fuente_id,
    fecha,
    indicador_nombre,
    valor,
    unidad,
    periodo
)
SELECT
    e.pais_id,
    e.fuente_id,
    e.fecha,
    CONCAT('Evento extremo: ', e.tipo_evento, ' en ', e.ubicacion) AS indicador_nombre,
    e.valor,
    'casos' AS unidad,               -- ajusta si tus valores son en USD, personas, etc.
    YEAR(e.fecha) AS periodo
FROM dbo.evento_extremo e;


SELECT id, tipo_evento, ubicacion, fecha, fuente_id
FROM dbo.evento_extremo
WHERE fuente_id IS NULL;



SELECT DISTINCT tipo_evento
FROM evento_extremo
WHERE fuente_id IS NULL;


--Actualizar fuente _id para los registro  not null
-- 1️⃣ Aridez → WMO Climate Data
UPDATE evento_extremo
SET fuente_id = (SELECT id FROM fuente_datos WHERE fuente_nombre = 'WMO Climate Data')
WHERE tipo_evento LIKE '%Aridity%';

-- 2️⃣ Continental weather and climate extremes → WMO Climate Data
UPDATE evento_extremo
SET fuente_id = (SELECT id FROM fuente_datos WHERE fuente_nombre = 'WMO Climate Data')
WHERE tipo_evento LIKE '%Continental weather%';

-- 3️⃣ Fenómeno climático global → WMO Climate Data
UPDATE evento_extremo
SET fuente_id = (SELECT id FROM fuente_datos WHERE fuente_nombre = 'WMO Climate Data')
WHERE tipo_evento LIKE '%Fenómeno climático global%';

-- 4️⃣ Incendios forestales → WWF
UPDATE evento_extremo
SET fuente_id = (SELECT id FROM fuente_datos WHERE fuente_nombre = 'WWF')
WHERE tipo_evento LIKE '%Incendio%';

-- 5️⃣ Ola de calor → SMN-Argentina
UPDATE evento_extremo
SET fuente_id = (SELECT id FROM fuente_datos WHERE fuente_nombre = 'SMN-Argentina')
WHERE tipo_evento LIKE '%Ola de calor%';

-- 6️⃣ Peligro biológico → SENASA-Argentina
UPDATE evento_extremo
SET fuente_id = (SELECT id FROM fuente_datos WHERE fuente_nombre = 'SENASA-Argentina')
WHERE tipo_evento LIKE '%Peligro biologico%';

-- 7️⃣ Precipitaciones extremas → SMN-Argentina
UPDATE evento_extremo
SET fuente_id = (SELECT id FROM fuente_datos WHERE fuente_nombre = 'SMN-Argentina')
WHERE tipo_evento LIKE '%Precipitaciones extremas%';

-- 8️⃣ Sequía → SISSA
UPDATE evento_extremo
SET fuente_id = (SELECT id FROM fuente_datos WHERE fuente_nombre = 'SISSA')
WHERE tipo_evento LIKE '%Sequía%';

-- 9️⃣ Terremoto → USGS-US
UPDATE evento_extremo
SET fuente_id = (SELECT id FROM fuente_datos WHERE fuente_nombre = 'USGS-US')
WHERE tipo_evento LIKE '%Terremoto%';

-- 🔟 Tropical cyclone → WMO Climate Data
UPDATE evento_extremo
SET fuente_id = (SELECT id FROM fuente_datos WHERE fuente_nombre = 'WMO Climate Data')
WHERE tipo_evento LIKE '%Tropical cyclone%';


-- Cuántos siguen sin fuente
SELECT COUNT(*) AS sin_fuente
FROM evento_extremo
WHERE fuente_id IS NULL;

-- Confirmar asignaciones
SELECT tipo_evento, fuente_id
FROM evento_extremo
ORDER BY tipo_evento;



--Script seguro para completar los NULL sin borrar nada
-- 1 Asigna fuente a "Ola de calor"
UPDATE evento_extremo
SET fuente_id = (
    SELECT TOP 1 id
    FROM fuente_datos
    WHERE fuente_nombre = 'SMN-Argentina'  -- la fuente nacional de meteorología
    ORDER BY id
)
WHERE tipo_evento = 'Ola de calor';

-- 2️ Precipitaciones extremas → WMO Climate Data
UPDATE evento_extremo
SET fuente_id = (
    SELECT TOP 1 id
    FROM fuente_datos
    WHERE fuente_nombre = 'WMO Climate Data'
)
WHERE tipo_evento = 'Precipitaciones extremas';


-- 🔎 Verificación final
SELECT tipo_evento, fuente_id
FROM evento_extremo
ORDER BY tipo_evento;


------------------EJERCICIOS DE DATOS CRUZADOS----------------------------
--Ver qué indicadores (CO₂, precipitaciones, etc.) tiene un país.
SELECT 
    p.pais_nombre,
    ri.indicador_nombre,
    ri.periodo,
    ri.valor,
    ri.unidad
FROM registro_indicador ri
JOIN pais p ON ri.pais_id = p.id
WHERE p.pais_nombre = 'Peru'
ORDER BY ri.periodo;

SELECT 'registro_indicador' AS tabla, *
FROM registro_indicador
WHERE indicador_nombre LIKE '%Huaycoloro%'



--Eventos extremos con su fuente y lugar
SELECT 
    ee.tipo_evento,
    ee.ubicacion,
    ee.fecha,
    f.fuente_nombre,
    f.url
FROM evento_extremo ee
LEFT JOIN fuente_datos f ON ee.fuente_id = f.id
ORDER BY ee.fecha DESC;

--OTRABUSQUEDA
SELECT 
    ee.id,
    p.pais_nombre,
    ee.tipo_evento,
    ee.ubicacion,
    ee.fecha,
    ee.impacto_estimado,
    f.fuente_nombre
FROM evento_extremo ee
LEFT JOIN pais p ON p.id = ee.pais_id
LEFT JOIN fuente_datos f ON f.id = ee.fuente_id
ORDER BY ee.fecha DESC;


sp_help registro_indicador
sp_help evento_extremo
sp_help desviaciones_indicadores


--Crear la relación entre evento_extremo y registro_indicador
ALTER TABLE evento_extremo 
ADD registro_id INT NULL;

--Establecer la relación con una llave foránea (opcional, pero recomendable)
--ALTER TABLE evento_extremo
--ADD CONSTRAINT FK_evento_registro
--FOREIGN KEY (registro_id)
--REFERENCES registro_indicador(id);
--no lo hago por ahora pero es una referencia

--Asignar registros (relacionar eventos con indicadores)
UPDATE ee
SET ee.registro_id = ri.id
FROM evento_extremo ee
JOIN registro_indicador ri
    ON ee.pais_id = ri.pais_id
   AND YEAR(ee.fecha) = YEAR(ri.fecha);


--Consultar todos los datos combinados
SELECT 
    p.pais_nombre,
    ee.tipo_evento,
    ee.ubicacion,
    ee.fecha,
    ee.impacto_estimado,
    ri.indicador_nombre,
    ri.valor AS valor_indicador,
    ri.unidad,
    di.tipo_desviacion,
    di.clasificacion_alertas
FROM evento_extremo ee
LEFT JOIN pais p 
    ON p.id = ee.pais_id
LEFT JOIN registro_indicador ri 
    ON ri.id = ee.registro_id
LEFT JOIN desviaciones_indicadores di 
    ON di.registro_indicador_id = ri.id
ORDER BY ee.fecha DESC;


SELECT 
    ee.id,
    p.pais_nombre,
    ee.tipo_evento,
    ee.ubicacion,
    ee.fecha,
    ee.impacto_estimado,
    r.indicador_nombre
FROM evento_extremo ee
LEFT JOIN pais p ON p.id = ee.pais_id
LEFT JOIN registro_indicador r ON r.id = ee.registro_id
ORDER BY ee.fecha DESC;



--SALIO NO BIEN
SELECT DISTINCT indicador_nombre
FROM registro_indicador
ORDER BY indicador_nombre;

SELECT DISTINCT tipo_evento
FROM evento_extremo
ORDER BY tipo_evento;

sp_help indicador;
SELECT TOP 80 * FROM indicador;
sp_help evento_extremo;
SELECT TOP 80 * FROM evento_extremo;


SELECT * INTO indicador_backup FROM indicador;
--Guardar copia d seguridad de INDICADOR
SELECT *
INTO indicador_backup_20251021
FROM indicador;


--verificar estructura actual



--consolidar el modelo de datos (sin duplicaciones) con una vista unificada
CREATE OR ALTER VIEW vw_EventosIndicadores AS
SELECT 
    p.pais_nombre,
    ee.id AS evento_id,
    ee.tipo_evento,
    ee.ubicacion,
    ee.fecha,
    ee.impacto_estimado,
    i.indicador_nombre,
    i.unidad_medida,
    i.categoria,
    f.fuente_nombre,
    f.url,
    d.tipo_desviacion,
    d.valor_calculado,
    d.clasificacion_alertas,
    d.unidad_resultado,
    d.metodologia
FROM evento_extremo ee
LEFT JOIN pais p ON p.id = ee.pais_id
LEFT JOIN indicador i ON ee.id = i.evento_extremo_id
LEFT JOIN fuente_datos f ON i.fuente_id = f.id
LEFT JOIN desviaciones_indicadores d ON ee.id = d.evento_extremo_id;


--consultar
SELECT * FROM vw_EventosIndicadores
ORDER BY pais_nombre, fecha DESC;






--vista consolidada
--CREATE VIEW vw_eventos_indicadores AS se elimino




--consultas
SELECT *
FROM vw_eventos_indicadores
WHERE pais_nombre = 'Venezuela'
ORDER BY fecha DESC;




--🧩 PLAN DE CORRECCIÓN


--DESDE AQUI OJOOOOOOOO

-- 7️⃣ Mostramos el SQL generado para revisión
PRINT ''=================================== SQL GENERADO ===================================='';
PRINT @sql;
PRINT ''====================================================================================='';


PRINT '✅ Ejecutando INSERT dinámico...';
EXEC sp_executesql @sql;

---------------------------------------------------
-- 5️⃣  Validar los resultados
---------------------------------------------------
PRINT '✅ Verificación de datos cargados:';
SELECT TOP 20 * 
FROM dbo.CO2_staging
ORDER BY ISO3, Anio;

SELECT 
    COUNT(*) AS TotalFilas,
    COUNT(DISTINCT ISO3) AS TotalPaises,
    COUNT(DISTINCT Anio) AS TotalAnios
FROM dbo.CO2_staging;


SELECT 'CO2' AS tabla, COUNT(*) AS filas FROM dbo.CO2;
SELECT 'CO2_staging' AS tabla, COUNT(*) AS filas FROM dbo.CO2_staging;


INSERT INTO Climate_model.dbo.CO2_staging (Pais, ISO3, Anio, Valor)
SELECT Pais, ISO3, Anio, Valor
FROM Unpivoted;


    [2010] DECIMAL(20,5),
    [2011] DECIMAL(20,5),
    [2012] DECIMAL(20,5),
    [2013] DECIMAL(20,5),
    [2014] DECIMAL(20,5),
    [2015] DECIMAL(20,5),
    [2016] DECIMAL(20,5),
    [2017] DECIMAL(20,5),
    [2018] DECIMAL(20,5),
    [2019] DECIMAL(20,5),
    [2020] DECIMAL(20,5),
    [2021] DECIMAL(20,5),
    [2022] DECIMAL(20,5),
    [2023] DECIMAL(20,5)
);

SELECT * FROM sys.tables WHERE name = 'CO2_staging';
sp_help 'dbo.CO2';

-- 3) Poblar la tabla staging desde la tabla importada (dbo.CO2)
INSERT INTO dbo.CO2_staging (
    Pais, ISO3, [2010], [2011], [2012], [2013], [2014],
    [2015], [2016], [2017], [2018], [2019], [2020], [2021],
    [2022], [2023]
)
SELECT
    column1 AS Pais,
    column2 AS ISO3,
    TRY_CAST(column3  AS DECIMAL(20,5)) AS [2010],
    TRY_CAST(column4  AS DECIMAL(20,5)) AS [2011],
    TRY_CAST(column5  AS DECIMAL(20,5)) AS [2012],
    TRY_CAST(column6  AS DECIMAL(20,5)) AS [2013],
    TRY_CAST(column7  AS DECIMAL(20,5)) AS [2014],
    TRY_CAST(column8  AS DECIMAL(20,5)) AS [2015],
    TRY_CAST(column9  AS DECIMAL(20,5)) AS [2016],
    TRY_CAST(column10 AS DECIMAL(20,5)) AS [2017],
    TRY_CAST(column11 AS DECIMAL(20,5)) AS [2018],
    TRY_CAST(column12 AS DECIMAL(20,5)) AS [2019],
    TRY_CAST(column13 AS DECIMAL(20,5)) AS [2020],
    TRY_CAST(column14 AS DECIMAL(20,5)) AS [2021],
    TRY_CAST(column13 AS DECIMAL(20,5)) AS [2022],
    TRY_CAST(column14 AS DECIMAL(20,5)) AS [2023]

FROM dbo.CO2_staging
WHERE ISNULL(column1,'') <> 'Pais';  -- evita fila cabecera si quedó
GO


sp_help desviaciones_indicadores;


--2️⃣ Verificar que las desviaciones calculadas coinciden con los indicadores originales
SELECT d.tipo_desviacion, d.valor_calculado, ri.valor AS valor_original
FROM desviaciones_indicadores d
JOIN registro_indicador ri
  ON d.registro_indicador_id = ri.id
WHERE d.tipo_desviacion = 'Promedio' 
  AND (d.valor_calculado IS NULL OR ri.valor IS NULL);

  --WHERE p.pais_nombre = 'Peru'

--3️⃣ Verificar anomalías de terremotos
SELECT ri.pais_id, ri.fecha, ri.valor, d.clasificacion_alertas
FROM registro_indicador ri
JOIN desviaciones_indicadores d
  ON ri.id = d.registro_indicador_id
WHERE d.tipo_desviacion LIKE '%sísmica%'
ORDER BY ri.fecha DESC;


--4️⃣ Verificar variaciones de precipitaciones para eventos de inundación
SELECT ri.pais_id, ri.fecha, ri.valor AS valor_actual, hist.promedio, d.valor_calculado, d.clasificacion_alertas
FROM registro_indicador ri
JOIN desviaciones_indicadores d
  ON ri.id = d.registro_indicador_id
JOIN (
    SELECT pais_id, AVG(valor) AS promedio
    FROM registro_indicador
    WHERE indicador_nombre = 'Precipitaciones'
    GROUP BY pais_id
) hist ON ri.pais_id = hist.pais_id
JOIN evento_extremo ee
  ON ri.pais_id = ee.pais_id
  AND ri.fecha = ee.fecha
WHERE ee.tipo_evento = 'Inundación';


--5️⃣ Verificar que los alias de países están completos y correctos
SELECT p.pais_nombre, a.alias_nombre
FROM pais p
LEFT JOIN pais_alias a
  ON p.id = a.pais_id
ORDER BY p.pais_nombre;