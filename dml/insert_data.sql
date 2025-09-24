USE Climate_model;
GO

--Fuente datos 
SELECT*FROM fuente_datos;

INSERT INTO fuente_datos (id, nombre, descripcion,tipo_fuente) VALUES
(1, 'Banco Mundial', 'Datos macroeconómicos y sociales globales', 'Organismo Internacional'),
(2, 'INEC Ecuador', 'Instituto Nacional de Estadística y Censos de Ecuador', 'Instituto Nacional'),
(3, 'NOAA', 'Administración Nacional Oceánica y Atmosférica (EE.UU.)', 'Clima y medio ambiente');

--País
SELECT*FROM pais;

INSERT INTO pais (id, nombre, region, codigo_iso) VALUES
(1, 'Ecuador', 'América del Sur', 'EC'),
(2, 'Perú', 'América del Sur', 'PE'),
(3, 'Chile', 'América del Sur', 'CL');

--Indicador
SELECT*FROM indicador;

INSERT INTO indicador (id, nombre, descripcion, unidad_medida) VALUES
(1, 'PIB', 'Producto Interno Bruto (USD constantes 2015)', 'Millones USD'),
(2, 'Inflación', 'Índice de precios al consumidor (variación anual %)', 'Porcentaje'),
(3, 'Temperatura promedio', 'Temperatura promedio anual registrada', 'Grados Celsius');

--Evento Extremo
SELECT*FROM evento_extremo;

INSERT INTO evento_extremo (id,pais_id, tipo_evento, fecha_inicio, fecha_fin, descripcion, impacto_estimado) VALUES
(1, 


