﻿USE Climate_model;
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
--sp_help fuente_datos;
--sp_help evento_extremo;
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
 --Crear tabla de Alias ---OOOOOOOOOOOJO CONFLICTO
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

----OJOOOOOOOO PROBLEMA
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

--sp_help desviaciones_indicadores;


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


--2️⃣ Verificar que las desviaciones calculadas coinciden con los indicadores originales
SELECT d.tipo_desviacion, d.valor_calculado, ri.valor AS valor_original
FROM desviaciones_indicadores d
JOIN registro_indicador ri
  ON d.registro_indicador_id = ri.id
WHERE d.tipo_desviacion = 'Promedio'
  AND (d.valor_calculado IS NULL OR ri.valor IS NULL);


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