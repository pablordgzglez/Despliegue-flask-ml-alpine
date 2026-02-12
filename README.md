# Proyecto Despliegue (FUSO) — Alpine + Flask + Bash

Este repositorio contiene los entregables del proyecto de despliegue: instalación de dependencias en Alpine Linux, despliegue de una app Flask desde un repositorio Git, descarga y procesado de datos (Gowalla) y automatización de peticiones HTTP desde Python.

La aplicación Flask desplegada ofrece servicios de Machine Learning, análisis exploratorio de datos y generación de mapas en HTML.

---

# Requisitos

Entorno recomendado:
- Alpine Linux (en máquina virtual)
- Python 3
- pip
- venv
- Git
- Bash
- wget
- curl
- unzip
- gcc y librerías de compilación

El script del Apartado 1 instala automáticamente las dependencias necesarias.

---

# Instalar dependencias (Apartado 1)

Dar permisos de ejecución:

chmod +x Apartado_1/apartado1_AlvaroPablo.sh

Ejecutar como root:

./Apartado_1/apartado1_AlvaroPablo.sh

Este script instala:
- python3
- py3-pip
- git
- bash
- gcc
- musl-dev
- linux-headers
- wget
- curl
- unzip

---

# Desplegar la aplicación Flask (Apartado 2)

El script realiza:
- Clonado del repositorio ProyectoFUSO
- Creación de entorno virtual
- Instalación de dependencias
- Ejecución de main.py

Pasos:

cd Apartado_2
chmod +x apartado_despliegue_Bash_AlvaroPablo.sh
./apartado_despliegue_Bash_AlvaroPablo.sh

Si todo funciona correctamente, la aplicación quedará ejecutándose en:

http://<IP_DE_LA_VM>:5000/

Para conocer la IP en Alpine:

ifconfig

---

# Descargar y procesar datos Gowalla (Apartado 3)

Este script:
- Descarga dataset desde Google Drive
- Descomprime archivos
- Genera ALL_LOCATIONS.txt
- Filtra por ciudades
- Genera estadísticas
- Crea mapas HTML
- Calcula Top-N usuarios
- Ejecuta nuevamente la aplicación Flask

Ejecutar:

cd Apartado_3
chmod +x apartado3_AlvaroPablo.sh
./apartado3_AlvaroPablo.sh

Los mapas HTML generados se guardan en:

ProyectoFUSO/templates/html_files/

---

# Automatización de peticiones HTTP (Apartado 4)

El script apartado4_AlvaroPablo.py:

- Hace POST a /train
- Usa dataset=iris
- Usa modelo RandomForest
- Itera train_size de 0.1 a 0.9
- Descarga imágenes generadas

Modificar la IP dentro del archivo:

base_url = "http://<IP_DE_LA_VM>:5000"

Ejecutar:

cd Apartado_4
python3 apartado4_AlvaroPablo.py

Las imágenes se guardarán en el directorio actual con nombres como:

irisTr0.7Tst0.3.png

---

# Uso del script Top-N

Ejemplo de ejecución:

python3 topn_selection_AlvaroPablo.py \
  --input_file DatasetsGowalla/DatasetsGowalla/ElPasoGowalla.txt \
  --top 5 \
  --output_file ElPaso_top5.txt

---

# Funcionalidades de la aplicación Flask

La aplicación ProyectoFUSO incluye:

- Train and Evaluate
- Dataset Statistics
- Exploratory Data Analysis
- Clean Images
- Generate Synthetic Dataset
- Compare Execution
- Show HTML Files

---

## Autores
[@alvaroplmr](https://github.com/alvaroplmr)
[@pablordgzglez](https://github.com/pablordgzglez)
