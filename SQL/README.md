__Climate Model — Data Pipeline & SQL Architecture__
1. Contexto del proyecto

Este repositorio documenta el desarrollo progresivo de un modelo de datos orientado al análisis climático, construido como parte de un proceso formativo académico y de experimentación práctica con datos reales.
El proyecto nace desde cero, evolucionando desde scripts básicos en SQL hasta la estructuración de un flujo de datos que integra:
modelado relacional

ETL en Visual Studio (SSIS)
carga de datos reales
preparación para BI y análisis multidimensional
El enfoque prioriza aprendizaje aplicado y construcción de una base escalable para futuros desarrollos analíticos y de negocio.

2. Objetivo
Diseñar e implementar una arquitectura de datos que permita:
almacenar información climática estructurada
integrar múltiples fuentes de datos
analizar indicadores ambientales y eventos extremos
preparar la base para BI, cubos y análisis predictivo

3. Arquitectura general del sistema
El proyecto se basa en un modelo relacional central (SQL Server) que organiza información climática mediante entidades principales:
países
indicadores ambientales
fuentes de datos
eventos extremos
registros históricos
desviaciones y métricas analíticas
Este modelo sirve como capa de persistencia para procesos ETL y herramientas de análisis.

4. Pipeline de datos (ETL)
Extract
Fuentes utilizadas:
datasets climáticos abiertos
archivos CSV
información web explorada mediante Python

Transform
Procesos aplicados:
limpieza de datos
normalización
validación de estructuras
relaciones entre entidades
reglas básicas de negocio

Herramientas:
SQL Server
procedimientos DML
Visual Studio (SSIS)
Load

Carga en el modelo relacional:
tablas principales del esquema Climate_model
staging y procesamiento previo en SQL

5. Tecnologías utilizadas
SQL Server
T-SQL (DDL / DML)
Visual Studio (SSIS – ETL)
Python (exploración de extracción web)
Power BI / Cubos (fase analítica en desarrollo)

6. Estructura del repositorio
   <img width="393" height="534" alt="image" src="https://github.com/user-attachments/assets/29316a0b-be82-4b50-b225-df9cd0cd330b" />

7. Estado del proyecto
Actualmente el proyecto cubre:
diseño del modelo relacional
scripts de creación de base
DML de carga de información real
primeras pruebas ETL en Visual Studio
desarrollo inicial de BI y cubos

Pendiente:
automatización completa del pipeline
integración de extracción vía Python
optimización de dimensiones analíticas
escalabilidad del modelo

8. Enfoque académico y profesional
Este repositorio refleja la evolución del aprendizaje aplicado:
transición desde scripts básicos hacia arquitectura de datos, uso de datos reales, integración de ETL y BI

El objetivo es construir una base reutilizable y escalable para proyectos de analítica climática y modelos de negocio basados en datos.

9. Cómo ejecutar el proyecto
Crear la base de datos mediante los scripts en:
scripts-base/

Ejecutar los procedimientos de carga:
dml-final/procedimientos_v1/

Cargar datasets base:
seeds-archivos/

Ejecutar componentes BI (opcional):
bi/

10. Notas finales
El proyecto continúa en desarrollo como laboratorio de aprendizaje en:
ingeniería de datos, modelado relacional, ETL, analítica climática.
Se prioriza evolución continua y mejora incremental del pipeline.
<img width="350" height="692" alt="image" src="https://github.com/user-attachments/assets/1af7749a-90e6-475d-87d3-2efadd90e355" />

**DATAFLOW INTEGRATION SERVICE**
<img width="975" height="722" alt="image" src="https://github.com/user-attachments/assets/562ff321-eccf-4dae-b458-fe13294c44bb" />
<img width="975" height="571" alt="image" src="https://github.com/user-attachments/assets/f729007c-a30d-47de-b8d6-7084db44aa95" />

**cubo OLAP**
<img width="975" height="694" alt="image" src="https://github.com/user-attachments/assets/2301bbaa-fae9-49b6-aac9-bcc77f41ae0e" />






