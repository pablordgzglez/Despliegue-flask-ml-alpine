PACKAGES="python3 python3-dev git nano sudo bash gcc libc-dev g++ musl-dev linux-headers wget curl htop"  # Sustituye por los nombres reales de los paquetes

for package in $PACKAGES 
do
    if [ "$package" = "libc-dev" ]; then
        apk add "$package"
        echo 'instalando libc-dev'
    elif ! apk list --installed | grep -q "^$package"; then
        apk add "$package"
    else
        echo "$package ya está instalado."
    fi
done