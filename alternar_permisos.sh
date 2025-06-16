#!/bin/bash

# Nombre del contenedor de WordPress (ajusta si usas otro nombre)
WP_CONTAINER="wp-app"

# Detecta el path del proyecto (donde está el script)
PROYECTO="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
CARPETA_WP="$PROYECTO/wordpress"

# Detecta tu usuario y grupo actual
USUARIO_HOST=$(id -u)
GRUPO_HOST=$(id -g)

echo "============================================"
echo " Alternancia de permisos WordPress - Docker "
echo "============================================"
echo "¿Qué deseas hacer?"
echo "1) Permitir edición desde el host (VSCode, terminal, etc.)"
echo "2) Permitir que WordPress escriba (instalar plugins, subir archivos, etc.)"
echo "--------------------------------------------"
read -p "Ingresa 1 o 2 y presiona [Enter]: " OPCION

if [ "$OPCION" == "1" ]; then
  echo "⏳ Cambiando permisos a tu usuario para editar desde el host..."
  sudo chown -R $USUARIO_HOST:$GRUPO_HOST "$CARPETA_WP"
  sudo find "$CARPETA_WP" -type d -exec chmod 775 {} \;
  sudo find "$CARPETA_WP" -type f -exec chmod 664 {} \;
  sudo chmod 600 "$CARPETA_WP/wp-config.php"
  echo "✅ Ahora puedes editar archivos desde VS Code o tu terminal."
elif [ "$OPCION" == "2" ]; then
  echo "⏳ Cambiando permisos a www-data dentro del contenedor WordPress..."
  docker exec -u root "$WP_CONTAINER" chown -R www-data:www-data /var/www/html
  docker exec -u root "$WP_CONTAINER" find /var/www/html -type d -exec chmod 775 {} \;
  docker exec -u root "$WP_CONTAINER" find /var/www/html -type f -exec chmod 664 {} \;
  docker exec -u root "$WP_CONTAINER" chmod 600 /var/www/html/wp-config.php
  echo "✅ WordPress puede escribir y funcionar correctamente."
else
  echo "Opción no válida. Por favor ejecuta el script nuevamente y elige 1 o 2."
  exit 1
fi
