#Sacamos los archivos de github
git clone https://github.com/pablosanchezp/ProyectoFUSO

#Creamos el entorno virtual 
python3 -m venv entorno_AlvaroPablo

#Lo activamos
source entorno_AlvaroPablo/bin/activate

#Instalamos alas librerias del requirements 
pip install -r requirements.txt

#Ejecutamos el main
python3 ProyectoFUSO/main.py
