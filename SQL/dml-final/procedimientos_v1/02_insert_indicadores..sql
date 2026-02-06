USE Climate_model;
GO


-- ========================
-- SEED DATA:Pais
-- ========================

INSERT INTO pais(id, nombre, iso3) VALUES
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



-- ========================
-- SEED DATA:Fuente_datos
-- ========================

INSERT INTO fuente_datos (id, nombre, descripcion,tipo_fuente) VALUES
(1, 'Banco Mundial Data', 'Indicadores de emisiones CO₂ históricas (2010-2023) para Sudamérica', 'Base de datos internacional'),
(2, 'WMO Climate Data','Eventos extremos reportados por la Organizacion Meteorologica Mundial','Base de datos global'),
(3, 'Senasa-Argentina','Servicio Nacional de Calidad y Sanidad Vegetal y de Semillas (Senave-Paraguay)','https://www.argentina.gob.ar/senasa/micrositios/langostas')
(4, 'SMN','Servicio Meteorológico Nacional-Argentina','https://www.argentina.gob.ar/smn'),
(5, 'SISSA','Sistema de Información sobre Sequías para el sur de Sudamérica-Bolivia','https://sissa.crc-sas.org/'),
(6, 'WWF', 'Worldwildlife','https://www.worldwildlife.org/descubre-wwf/historias/la-amazonia-registro-mas-de-50-000-focos-de-incendios-en-2024');


--(1, 'WMO Climate Data', 'Datos oficiales de la Organización Meteorológica Mundial', 'Base de datos global'),
--(2, 'Global Atmosphere Watch (GAW)', 'Monitoreo de gases de efecto invernadero y ozono', 'Observatorio');




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

INSERT INTO evento_extremo (pais_id, ubicacion, tipo_evento, descripcion, valor, fecha, coord_UTM, impacto_estimado)
VALUES
-- 1. Longest dry period (Arica, Chile 1903-1918)
((SELECT id FROM pais WHERE nombre = 'Chile'),
 'Arica, Chile', 
 'Aridity', 
 'Longest dry period', 
 '172 months', 
 '1903-10-01', -- fecha aproximada de inicio
 geometry::STPointFromText('POINT(343900 7921800)', 32719), 
 '172 meses sin lluvias significativas (18°48''S, 70°30''W):UTM Zone 19S'),
 --2);CREOOOOOO

-- 2. Tropical Cyclone Catarina (Brazil, 2004)
((SELECT id FROM pais WHERE nombre = 'Brazil'),
 'Santa Catarina, Brazil', 
 'Tropical cyclone', 
 'First identified South Atlantic hurricane', 
 NULL, 
 '2004-03-01', -- mes aproximado del huracán Catarina
 geometry::STPointFromText('POINT(500000 7006000)', 32722), 
 'Fenómeno meteorológico de fuerte intensidad en zonas tropicales (27°S, 48°W)'),  


-- 3.  Highest temperature (Rivadavia, Argentina 1905)
((SELECT id FROM pais WHERE nombre = 'Argentina'),
 'Rivadavia, Argentina', 
 'Continental weather and climate extremes', 
 'Highest temperature', 
 '48.9 °C', 
 '1905-12-11',
 geometry::STPointFromText('POINT(326900 7322900)', 32720), 
 'Temperatura extrema con impacto en salud y agricultura (24°10''S, 62°54''W)'),


-- 4. Lowest temperature (Sarmiento, Argentina 1907)
((SELECT id FROM pais WHERE nombre = 'Argentina'), 
 'Sarmiento, Argentina', 
 'Continental weather and climate extremes', 
 'Lowest temperature', 
 '-32.8 °C', 
 '1907-06-01',
 geometry::STPointFromText('POINT(266400 3975400)', 32719), 
 'Evento de bajas temperaturas con impacto local (54°21''S, 68°11''W)'),


-- 5. Greatest precipitation (Quibdó, Colombia 1978)
((SELECT id FROM pais WHERE nombre = 'Colombia'),
 'Quibdo, Colombia', 
 'Continental weather and climate extremes', 
 'Greatest precipitation (average annual)', 
 '8.99 m', 
 '1978-01-01',
 geometry::STPointFromText('POINT(203100 632500)', 32618), 
 'Promedio anual de 354 in., el más alto registrado (5°41''N, 76°40''W)'),


-- 6.  Least precipitation (Arica, Chile 1971)
((SELECT id FROM pais WHERE nombre = 'Chile'), 
 'Arica, Chile', 
 'Continental weather and climate extremes', 
 'Least precipitation (average annual)', 
 '0.76 mm', 
 '1971-01-01',
 geometry::STPointFromText('POINT(365600 7956800)', 32719), 
 'Arica, Chile (18°29''S, 70°18''W)'),


 -- 7. Terremoto Pedernales (Ecuador, zona UTM 17S)
((SELECT id FROM pais WHERE nombre = 'Ecuador'),
 'Pedernales, Manabí (epicentro)',
 'Terremoto',
 'Subducción de las placas de Nazca y Sudamericana',
 '7.8 Mw (Magnitud Richter)',
 '2016-04-16',
 geometry::STPointFromText('POINT(594000 9958000)', 32717), -- UTM 17S
 'Consecuencias devastadoras: fallecidos, heridos y daños estructurales. Impacto económico > USD 3 mil millones'),


-- 8. Fenómeno El Niño (Pacífico central/oriental, UTM 15S aproximada)
((SELECT id FROM pais WHERE nombre = 'Ecuador'),
 'Pacífico ecuatorial oriental y central',
 'Fenómeno climático global',
 'Fenómeno El Niño originado por el calentamiento de las aguas del océano Pacífico',
 NULL,
 '1997-05-01',
 geometry::STPointFromText('POINT(500000 9800000)', 32715), -- coordenada aproximada UTM zona 15S
 'Impactos a gran escala: inundaciones, sequías y alteraciones climáticas en Sudamérica'),


-- 9. Sequía en Chile (zona central-2019)
((SELECT id FROM pais WHERE nombre = 'Chile'),
 'Zona central de Chile',
 'Sequía',
 'Sequía prolongada que afectó a la zona central de Chile',
 NULL,
 '2019-01-01',
 NULL,
 'Impacto en disponibilidad hídrica y producción agrícola'),


 -- 10. Ola de calor (Argentina, 2023)
((SELECT id FROM pais WHERE nombre = 'Argentina'),
 'Zona central y norte de Argentina',
 'Ola de calor',
 'Temperaturas récord con impacto en salud y agricultura',
 '43 °C',
 '2023-01-01',
 NULL,
 'Afectación a la salud pública, agricultura y consumo energético'),

-- 11. Sequía (Bolivia, 2022)
((SELECT id FROM pais WHERE nombre = 'Bolivia'),
 'Altiplano y valles agrícolas',
 'Sequía',
 'Sequía severa en Bolivia afectando producción agrícola',
 NULL,
 '2022-12-01',
 NULL,
 'Pérdida de cosechas y afectación a comunidades rurales'),

-- 12. Incendios forestales (Brasil, 2020)
((SELECT id FROM pais WHERE nombre = 'Brazil'),
 'Amazonía brasileña',
 'Incendios forestales',
 'Incendios de gran escala en la Amazonía brasileña',
 NULL,
 '2020-09-01',
 NULL,
 'Deforestación, pérdida de biodiversidad y afectación a comunidades indígenas'),

-- 13. Precipitaciones extremas (Chile, 2023)
((SELECT id FROM pais WHERE nombre = 'Chile'),
 'Norte de Chile (zonas urbanas)',
 'Precipitaciones extremas',
 'Inundaciones en zonas urbanas del norte de Chile',
 NULL,
 '2023-02-15',
 NULL,
 'Daños en infraestructura urbana y viviendas'),

-- 14. Plaga de langosta (Argentina, 2020)
((SELECT id FROM pais WHERE nombre = 'Argentina'),
 'Paraguay – noreste de Argentina',
 'Biological hazard',
 'Plaga de langosta (Locust plague) ingresó desde Paraguay y avanzó por el noreste de Argentina',
 'N/A',
 '2020-06-01',
 NULL,
 'Afectó cultivos de maíz y trigo'),



-- ========================
-- SEED DATA: Indicador
-- ========================


--INSERT INTO evento_extremo (id, nombre, descripcion, categoria)
--VALUES
(1, 'Ola de Calor', 'Periodo prolongado de temperaturas extremadamente altas', 'Climático'),
(2, 'Sequía', 'Deficiencia prolongada de precipitaciones', 'Hidrológico'),
(3, 'Inundación', 'Exceso de agua causando desbordamientos', 'Hidrológico'),
(4, 'Ciclón Tropical', 'Fenómeno meteorológico de fuerte intensidad en zonas tropicales', 'Meteorológico');


--Indicador
--INSERT INTO indicador (id, pais_id, fuente_id, evento_extremo_id, indicador_nombre, unidad_medida, categoria)
 VALUES
(1, 'PIB', 'Producto Interno Bruto (USD constantes 2015)', 'Millones USD'),
(2, 'CO2 emissions (kt)', 'Emisiones de CO₂ históricas por país (2010-2023), fuente World Bank',
 'kt', 'Cambio climático'),
(3, 'Eventos Extremos Reportados', 'Número de eventos extremos registrados en un año', 'conteo');

-- ========================
-- SEED DATA: Indicadores
-- ========================
--INSERT INTO indicador (id, nombre, descripcion, unidad_medida)
--VALUES
(1, 'Temperatura Media Anual', 'Promedio de la temperatura anual reportada por la WMO', '°C'),
(2, 'Precipitación Total Anual', 'Suma de la precipitación total acumulada en el año', 'mm'),
(3, 'Eventos Extremos Reportados', 'Número de eventos extremos registrados en un año', 'conteo');



--Registro indicador (ejemplo con datos reales simplificados)
--INSERT INTO registro_indicador (id, pais_id, indicador_id, fuente_id, fecha, valor) VALUES
-- PIB
(1, 1, 1, 1, '2020-12-31', '98187'),  -- Ecuador PIB en millones USD
(2, 2, 1, 1, '2020-12-31', '202014'), -- Perú
(3, 3, 1, 1, '2020-12-31', '282318'), -- Chile
-- Inflación
(4, 1, 2, 2, '2020-12-31', '2.5'),
(5, 2, 2, 1, '2020-12-31', '1.8'),
(6, 3, 2, 1, '2020-12-31', '3.0'),
-- Temperatura promedio
(7, 1, 3, 3, '2020-12-31', '24.1'),
(8, 2, 3, 3, '2020-12-31', '22.7'),
(9, 3, 3, 3, '2020-12-31', '16.5');