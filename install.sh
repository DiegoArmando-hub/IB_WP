#!/bin/bash
set -euo pipefail

# Validar variables esenciales
required_vars=(
  "WORDPRESS_DB_NAME"
  "WORDPRESS_DB_USER"DOCK
  "WORDPRESS_DB_PASSWORD"
  "WORDPRESS_URL"
  "ACTIVATE_PLUGINS"
)

for var in "${required_vars[@]}"; do
  if [ -z "${!var:-}" ]; then
    echo "❌ Variable crítica no definida: $var"
    exit 1
  fi
done

WP_DEBUG="${WP_DEBUG:-false}"
DISABLE_XMLRPC="${DISABLE_XMLRPC:-false}"

# Esperar a que MySQL esté listo
echo "🕒 Esperando MySQL..."
for i in {1..10}; do
  if mysqladmin ping -h"${WORDPRESS_DB_HOST}" -u"${WORDPRESS_DB_USER}" -p"${WORDPRESS_DB_PASSWORD}" --silent; then
    echo "✅ MySQL listo"
    break
  else
    echo "🔄 Intento $i/10 fallido"
    [ $i -eq 10 ] && { echo "❌ No se pudo conectar a MySQL después de 10 intentos"; exit 1; }
    sleep $((i * 2))
  fi
done

# Descargar WordPress si no está presente
if [ ! -f /var/www/html/wp-settings.php ]; then
  echo ">>> Descargando WordPress..."
  wp core download --locale=es_ES --allow-root --force
fi

# Crear wp-config.php si no existe
if [ ! -f /var/www/html/wp-config.php ]; then
  echo ">>> Creando wp-config.php..."
  wp config create \
    --dbname="${WORDPRESS_DB_NAME}" \
    --dbuser="${WORDPRESS_DB_USER}" \
    --dbpass="${WORDPRESS_DB_PASSWORD}" \
    --dbhost="${WORDPRESS_DB_HOST}" \
    --allow-root \
    --force

  # Configuración adicional para wp-config.php
  {
    echo "define('FS_METHOD', 'direct');"
    echo "define('WP_DEBUG', ${WP_DEBUG});"
  } >> /var/www/html/wp-config.php
fi

# Instalar WordPress si aún no está instalado
if ! wp core is-installed --allow-root; then
  echo ">>> Instalando WordPress..."
  wp core install \
    --url="${WORDPRESS_URL}" \
    --title="${WORDPRESS_TITLE}" \
    --admin_user="${WORDPRESS_ADMIN_USER}" \
    --admin_password="${WORDPRESS_ADMIN_PASSWORD}" \
    --admin_email="${WORDPRESS_ADMIN_EMAIL}" \
    --skip-email \
    --allow-root
fi

# Configurar permisos de archivos
echo ">>> Configurando permisos de archivos..."
chown -R www-data:www-data /var/www/html
find /var/www/html -type d -exec chmod 755 {} \;
find /var/www/html -type f -exec chmod 644 {} \;

# Eliminar plugins por defecto que no se usan
echo ">>> Eliminando plugins por defecto (Hello Dolly y Akismet)..."
wp plugin delete hello --allow-root || true
wp plugin delete akismet --allow-root || true

# Instalar y activar plugins indicados en ACTIVATE_PLUGINS
echo ">>> Instalando y activando plugins..."
for plugin in ${ACTIVATE_PLUGINS//,/ }; do
  wp plugin install "$plugin" --allow-root --force || echo "?? Plugin no instalado: $plugin"
  wp plugin activate "$plugin" --allow-root || true
done

# Copiar plugins y temas personalizados si existen
if [ -d /var/www/html/wp-content/plugins_custom ]; then
  echo ">>> Copiando plugins personalizados..."
  cp -a /var/www/html/wp-content/plugins_custom/. /var/www/html/wp-content/plugins/
fi

if [ -d /var/www/html/wp-content/themes_custom ]; then
  echo ">>> Copiando temas personalizados (Divi y Divi-Child)..."
  [ -d "/var/www/html/wp-content/themes_custom/Divi" ] && cp -a /var/www/html/wp-content/themes_custom/Divi /var/www/html/wp-content/themes/
  [ -d "/var/www/html/wp-content/themes_custom/divi-child" ] && cp -a /var/www/html/wp-content/themes_custom/divi-child /var/www/html/wp-content/themes/
fi

# Eliminar tema custom si existe
wp theme delete custom --allow-root 2>/dev/null || true

# Crear y dar permisos a upgrade y languages
echo ">>> Corrigiendo permisos de wp-content/upgrade y wp-content/languages..."
mkdir -p /var/www/html/wp-content/upgrade /var/www/html/wp-content/languages
chown -R www-data:www-data /var/www/html/wp-content/upgrade /var/www/html/wp-content/languages
chmod 775 /var/www/html/wp-content/upgrade /var/www/html/wp-content/languages

# Activar el tema hijo o Divi
echo ">>> Activando tema hijo divi-child (o Divi si falla)..."
if wp theme is-installed divi-child --allow-root; then
  wp theme activate divi-child --allow-root || wp theme activate Divi --allow-root
elif wp theme is-installed Divi --allow-root; then
  wp theme activate Divi --allow-root
fi

# Eliminar todos los temas excepto los necesarios
echo ">>> Eliminando temas predeterminados innecesarios..."
for theme in $(wp theme list --field=name --allow-root); do
  if [[ "$theme" != "Divi" && "$theme" != "divi-child" ]]; then
    wp theme delete "$theme" --allow-root || true
  fi
done

# Seguridad: deshabilitar XML-RPC si está configurado
if [ "${DISABLE_XMLRPC}" = "true" ]; then
  echo ">>> Deshabilitando XML-RPC..."
  echo "<?php die('Acceso denegado'); ?>" > "/var/www/html/xmlrpc.php"
fi

echo "✅ Instalación completada en ${WORDPRESS_URL}"
