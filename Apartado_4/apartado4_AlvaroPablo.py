import requests

# Dirección IP y puerto donde está el servidor Flask desplegado. (Hay que cambiar la IP según donde esté corriendo)
base_url = "http://10.120.142.148:5000" 


for i in range(1, 10):
    train_size = round(i * 0.1, 1)
    test_size = round(1 - train_size, 1)

    # Diccionario de datos para el request
    diccionario = {
        'dataset': 'iris',
        'model': 'RandomForest',
        'train_size': train_size,
        'test_size': test_size
    }

    response = requests.post(f"{base_url}/train", data=diccionario)

    if response.status_code == 200:
        print(f"Hecho para train_size={train_size}, test_size={test_size}")

        # Nombre del archivo de imagen generado
        nombre_documento = f"irisTr{train_size}Tst{test_size}.png"
        url_imagen = f"{base_url}/static/{nombre_documento}"

        # Descarga de la imagen generada
        img_response = requests.get(url_imagen)
        if img_response.status_code == 200:
            with open(nombre_documento, 'wb') as fichero:
                fichero.write(img_response.content)
            print(f"Imagen guardada como {nombre_documento}")
        else:
            print(f"Error al descargar la imagen: {url_imagen} ---> status code: {img_response.status_code}")
    else:
        print(f"Error en la petición de entrenamiento ---> status code: {response.status_code}")
