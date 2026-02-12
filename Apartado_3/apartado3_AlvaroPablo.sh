#!/bin/bash

# Variables de configuración
URL="https://drive.google.com/uc?export=download&id=1PHWBGuwDHw4ZEIlCbgMTiEUrG8FmlJK2"
ARCHIVO_ZIP="DatasetsGowalla.zip"
PATH_GOWALLA_FILES="DatasetsGowalla"
DIRECTORIO_FILTRADO="Filtered"
PATH_MAIN_PYTHON="ProyectoFUSO/generate_maps.py"
PATH_OUTPUT_GOWALLA_FILES="ProyectoFUSO/templates/html_files/"
PATH_INDIVIDUAL_MAPS="ProyectoFUSO/generate_individual_maps.py"


# Sacamos el archivo ZIP
wget --no-check-certificate -O "$ARCHIVO_ZIP" "$URL"

#Lo descomprimimos
unzip -o "$ARCHIVO_ZIP" -d "$PATH_GOWALLA_FILES"

#Creamos la carpeta Filtered si no existe
if [ ! -d "$DIRECTORIO_FILTRADO" ]; then
    mkdir "$DIRECTORIO_FILTRADO"
    echo "Carpeta '$DIRECTORIO_FILTRADO' creada."
fi

#Para cada fichero del la carpeta descomprimida
for fichero in "$PATH_GOWALLA_FILES"/"$PATH_GOWALLA_FILES"/*; do
    #Obtenemos el nombre de la ciudad
    ciudad=$(basename "$fichero" Gowalla.txt)
    
    #Metemos las columnas 3,4 y 5 de los .txt en ALL_LOCATIONS.txt
    cut -d$'\t' -f3,4,5 "$fichero" >> ALL_LOCATIONS.txt
    
    #Metemos las columnas 1,2 y 5 en ficheros filtrados para cada ciudad
    cut -d$'\t' -f1,2,5 "$fichero" > "$DIRECTORIO_FILTRADO/${ciudad}filtered.txt"
done

echo ""
echo ""
#Mostramos las estadísticas para cada ciudad
echo "******************ESTADISTICAS_CIUDADES******************"
for fichero in "$PATH_GOWALLA_FILES"/"$PATH_GOWALLA_FILES"/*; do
    echo "-----------------------------------------------"
    #Cogemos el nombre de cada ciudad
    ciudad=$(basename "$fichero" Gowalla.txt)
    echo "Estadísticas para $ciudad .txt:"
    
    #Cantidad de usuarios distintos
    usuarios_distintos=$(cut -d$'\t' -f1 "$fichero" | sort | uniq | wc -l)
    echo "-Número de usuarios distintos: $usuarios_distintos"
    
    # Número de localizaciones distintas
    lugares_distintos=$(cut -d$'\t' -f5 "$fichero" | sort | uniq | wc -l)
    echo "-Número de localizaciones distintas: $lugares_distintos"
    
    # Número de filas completas
    filas_completas=$(wc -l < "$fichero")
    echo "-Número de filas completas: $filas_completas"
    
    # Número de check-ins en 2010-07
    checkins_julio=$(grep '2010-07' "$fichero" | wc -l)
    echo "-Número de check-ins en 2010-07: $checkins_julio"
    
    # Número de check-ins en 2010-08
    checkins_agosto=$(grep '2010-08' "$fichero" | wc -l)
    echo "-Número de check-ins en 2010-08: $checkins_agosto"
done
echo "-----------------------------------------------"
echo "*********************************************************"


#Activamos el entorno virtual creado en el segundo ejercicio
source entorno_AlvaroPablo/bin/activate

echo ""
echo ""

#Generamos los mapas para estas ciudades
ciudades="ElPaso Glasgow Manchester WashingtonDC"
echo "**************************MAPAS**************************"
for fichero in "$PATH_GOWALLA_FILES"/"$PATH_GOWALLA_FILES"/*; do
    #Sacamos el nombre de la ciudad
    ciudad=$(basename "$fichero" Gowalla.txt)  
    #Comprobamos si la ciudad del fichero iterado esta en la lista de las que hay que crear un mapa 
    if [[ " $ciudades " == *" $ciudad "* ]]; then
        echo "-----------------------------------------------"
        #Generamos el mapa
        output_html="${PATH_OUTPUT_GOWALLA_FILES}/${ciudad}GowallaMap"
        python3 "$PATH_MAIN_PYTHON" --input_file "$fichero" --city_name "$ciudad" --output_html "$output_html"
        echo "Mapa HTML generado para $ciudad: $output_html"
    fi
done
echo "-----------------------------------------------"
echo "*********************************************************"


echo ""
echo ""
#Generar mapas individuales para algunos usuarios
echo "*******************MAPAS_INDIVIDUALES********************"
for fichero in "$PATH_GOWALLA_FILES"/"$PATH_GOWALLA_FILES"/*; do
    #Cogemos el nombre de cada ciudad
    ciudad=$(basename "$fichero" Gowalla.txt)

    if [[ " $ciudades " == *" $ciudad "* ]]; then       
        echo "-----------------------------------------------"
        #Dependiendo de la ciudad cogemos un usuario que ha sido elegido a mano de los archivos como pone en la practica
        if [ "$ciudad" = "ElPaso" ]; then
            usuario=667
        fi
        if [ "$ciudad" = "Glasgow" ]; then
            usuario=268
        fi
        if [ "$ciudad" = "Manchester" ]; then
            usuario=332
        fi
        if [ "$ciudad" = "WashingtonDC" ]; then
            usuario=22
        fi       
        #Generamos el mapa                   
        output_html="${PATH_OUTPUT_GOWALLA_FILES}/${ciudad}_${usuario}_Map.html"
        python3 "$PATH_INDIVIDUAL_MAPS" --user_id "$usuario" --city_name "$ciudad" --input_file "$fichero" --output_html "$output_html"
        echo "Mapa individual generado para el usuario $usuario en $ciudad: $output_html"
    fi 
done
echo "-----------------------------------------------"
echo "*********************************************************"
echo ""
echo ""
#Generar el top 5 de usuarios de una ciudad elegida
TOP_N=5
CIUDAD_ELEGIDA="ElPaso" 
python3 topn_selection_AlvaroPablo.py --input_file "${PATH_GOWALLA_FILES}/${PATH_GOWALLA_FILES}/${CIUDAD_ELEGIDA}Gowalla.txt" --top $TOP_N --output_file "${CIUDAD_ELEGIDA}_top${TOP_N}.txt"
echo "*********************MAPAS_TOP_5*************************"
while read -r usuario; do
    echo "-----------------------------------------------"
    output_html="${PATH_OUTPUT_GOWALLA_FILES}/${CIUDAD_ELEGIDA}_${usuario}_TopMap.html"
    python3 "$PATH_INDIVIDUAL_MAPS" --user_id "$usuario" --city_name "$CIUDAD_ELEGIDA" --input_file "${PATH_GOWALLA_FILES}/${PATH_GOWALLA_FILES}/${CIUDAD_ELEGIDA}Gowalla.txt" --output_html "$output_html"
    echo "Mapa Top 5 generado para el usuario $usuario en $CIUDAD_ELEGIDA: $output_html"
done < "${CIUDAD_ELEGIDA}_top${TOP_N}.txt"
echo "-----------------------------------------------"
echo "*********************************************************"


python3 ProyectoFUSO/main.py
