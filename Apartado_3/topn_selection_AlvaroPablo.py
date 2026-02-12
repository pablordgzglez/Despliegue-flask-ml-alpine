from collections import Counter
import argparse

def main():
    # Configuración de argparse para obtener los argumentos de entrada, top y salida
    parser = argparse.ArgumentParser(description="Seleccionar los usuarios con más visitas.")
    parser.add_argument('--input_file', type=str, required=True, help="Archivo de entrada con las visitas.")
    parser.add_argument('--top', type=int, required=True, help="Número de usuarios en el top.")
    parser.add_argument('--output_file', type=str, required=True, help="Archivo de salida con el top de usuarios.")
    args = parser.parse_args()
    
    # Leer el archivo de entrada y obtener la lista de usuarios
    with open(args.input_file, 'r') as file:
        user_visits = [line.split('\t')[0] for line in file]
    
    # Contar interacciones por usuario
    user_counter = Counter(user_visits)
    top_users = user_counter.most_common(args.top)
    
    # Guardar el resultado en el archivo de salida
    with open(args.output_file, 'w') as output_file:
        for user, count in top_users:
            output_file.write(f"{user}\n")
    
    # Informar al usuario de la finalización
    print(f"Top {args.top} usuarios con más visitas guardado en '{args.output_file}'.")

# Ejecutar el script
if __name__ == "__main__":
    main()
