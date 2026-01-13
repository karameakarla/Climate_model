# Climate_model
🗂️ Caso Propuesto: Sistema de Gestión de Indicadores del Cambio Climático en América del Sur

🎯 Contexto y Objetivo General
MONDO (Organización ambiental sin fines de lucro) desea desarrollar un sistema para gestionar, monitorear y analizar indicadores relacionados con el cambio climático en los países de América del Sur. 

**Objetivos del sistema**
Recopilar datos confiables que permitan evaluar tendencias, 
Generar alertas tempranas, 
Diseñar políticas públicas y 
Fomentar la cooperación internacional.
________________________________________
🌎 Escenario
Cada país de América del Sur tiene agencias ambientales que registran datos periódicos relacionados con diversos indicadores climáticos y ambientales, tales como:

•	Temperatura promedio
•	Nivel de precipitaciones
•	Deforestación anual
•	Emisiones de CO₂
•	Incendios forestales
•	Nivel del mar
•	Eventos extremos (sequías, inundaciones, olas de calor)

Estos datos deben almacenarse y estar vinculados a la ubicación geográfica, el tiempo, la fuente de información, y el tipo de indicador. Además, deben poder compararse entre países, regiones y años.
________________________________________
🧱 Elementos clave del modelo de base de datos
🔹 Entidades posibles:
1.	País
o	id_país
o	nombre
o	superficie_km2
o	población
o	región (Andina, Cono Sur, Amazónica, etc.)
2.	Indicador
o	id_indicador
o	nombre (Temperatura, CO₂, etc.)
o	unidad_medida (°C, ppm, mm, hectáreas, etc.)
o	categoría (Climático, Ambiental, Social)
3.	Registro_Indicador
o	id_registro
o	id_indicador (FK)
o	id_pais (FK)
o	fecha
o	valor
o	fuente_datos (FK)
o	observaciones
4.	Fuente_Datos
o	id_fuente
o	nombre
o	tipo (Gobierno, ONG, Satélite, Estación Meteorológica)
o	enlace_web
5.	Evento_Extremo (opcional)
o	id_evento
o	tipo_evento (sequía, incendio, inundación, etc.)
o	fecha_inicio
o	fecha_fin
o	id_pais (FK)
o	descripcion
o	impacto_estimado (económico, social)
________________________________________
📊 Consultas que permitiría el sistema
•	Comparar las emisiones de CO₂ de Brasil y Argentina en los últimos 10 años.
•	Ver la evolución del nivel del mar en las costas de Perú.
•	Identificar los países con más eventos extremos en la región andina.
•	Generar reportes por país e indicador con sus fuentes de datos.
________________________________________
🧩 Desafíos para modelar
•	Normalización de unidades de medida.
•	Registro de datos periódicos (series temporales).
•	Calidad y confiabilidad de las fuentes de información.
•	Posible expansión a subniveles geográficos (estados, provincias).
•	Integración futura con APIs de datos abiertos (ej. Copernicus, NOAA, etc.).

MAPA CONCEPTUAL -Entidad DER
![Dis_Conceptual Climate_model](https://github.com/user-attachments/assets/ac8b319f-8739-4d79-b4a0-fa0c67e8a657)

DISENO LOGICO
<img width="1119" height="751" alt="image" src="https://github.com/user-attachments/assets/24979355-06ec-47b0-8433-2ea33c614463" />

<img width="920" height="739" alt="image" src="https://github.com/user-attachments/assets/0e14d728-cd14-4da4-9934-f051948e49c6" />


MODELO DIMENSIONAL
<img width="950" height="843" alt="image" src="https://github.com/user-attachments/assets/5f63dbe0-83cd-4e6e-94fd-8ad528a99f0f" />





