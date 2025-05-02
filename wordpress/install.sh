#!/bin/bash
set -euo pipefail

# Validar variables esenciales
required_vars=(
  "WORDPRESS_DB_NAME"
  "WORDPRESS_DB_USER"
  "WORDPRESS_DB_PASSWORD"
  "WORDPRESS_URL"
)

for var in "${required_vars[@]}"; do
  if [ -z "${!var}" ]; then
    echo "❌ Variable crítica no definida: $var"
    exit 1
  fi
done

# Esperar a MySQL
echo "🕒 Esperando MySQL..."
for i in {1..10}; do
  if mysqladmin ping -h172.28.0.2 -u"${WORDPRESS_DB_USER}" -p"${WORDPRESS_DB_PASSWORD}" --ssl=0 --silent; then
    echo "✅ MySQL listo"
    break
  else
    echo "🔄 Intento $i/10 fallido"
    [ $i -eq 10 ] && { echo "❌ No se pudo conectar a MySQL"; exit 1; }
    sleep $((i * 2))
  fi
done

# Configuración básica de WordPress
if [ ! -f /var/www/html/wp-config.php ]; then
  echo ">>> Creando wp-config.php..."
  wp config create \
    --dbname="${WORDPRESS_DB_NAME}" \
    --dbuser="${WORDPRESS_DB_USER}" \
    --dbpass="${WORDPRESS_DB_PASSWORD}" \
    --dbhost="172.28.0.2" \
    --allow-root \
    --force

  # Configuraciones adicionales seguras
  {
    echo "define('WP_SITEURL', '${WORDPRESS_URL}');"
    echo "define('WP_HOME', '${WORDPRESS_URL}');"
    echo "define('FS_METHOD', 'direct');"
    echo "define('DISALLOW_FILE_EDIT', true);"
    [ -n "${WP_DEBUG}" ] && echo "define('WP_DEBUG', ${WP_DEBUG});"
  } >> /var/www/html/wp-config.php
fi

# Instalar WordPress si no está instalado
if ! wp core is-installed --allow-root; then
  echo ">>> Instalando WordPress..."
  wp core install \
    --url="${WORDPRESS_URL}" \
    --title="${WORDPRESS_TITLE:-Mi Sitio WordPress}" \
    --admin_user="${WORDPRESS_ADMIN_USER:-admin}" \
    --admin_password="${WORDPRESS_ADMIN_PASSWORD:-password}" \
    --admin_email="${WORDPRESS_ADMIN_EMAIL:-admin@example.com}" \
    --skip-email \
    --allow-root
fi

# Configurar logo y título del sitio
echo ">>> Configurando logo y título..."
wp option update site_icon $(wp media import /var/www/html/wp-content/themes/divi-child/img/logo.png --porcelain --allow-root) --allow-root
wp option update blogname "${WORDPRESS_TITLE:-Mi Sitio WordPress}" --allow-root

# Activar tema Divi Child
echo ">>> Activando tema Divi Child..."
wp theme activate divi-child --allow-root || {
  echo "⚠️ No se pudo activar el tema hijo, activando Divi..."
  wp theme activate divi --allow-root
}

# Limpiar temas innecesarios
echo ">>> Limpiando temas innecesarios..."
wp theme list --allow-root --field=name | grep -v -E "divi|divi-child" | xargs -r wp theme delete --allow-root

# Instalar plugins requeridos
if [ -n "${ACTIVATE_PLUGINS}" ]; then
  echo ">>> Instalando plugins: ${ACTIVATE_PLUGINS}..."
  IFS=',' read -ra plugins <<< "${ACTIVATE_PLUGINS}"
  for plugin in "${plugins[@]}"; do
    plugin=$(echo "$plugin" | xargs)
    if [ -n "$plugin" ]; then
      if ! wp plugin is-installed "$plugin" --allow-root; then
        wp plugin install "$plugin" --allow-root
      fi
      wp plugin activate "$plugin" --allow-root
    fi
  done
fi

# Configuración de seguridad XML-RPC
if [ "${DISABLE_XMLRPC:-false}" = "true" ]; then
  echo ">>> Deshabilitando XML-RPC..."
  echo "<?php die('Acceso denegado'); ?>" > "/var/www/html/xmlrpc.php"
  chown www-data:www-data "/var/www/html/xmlrpc.php"
fi

echo "✅ Instalación completada en ${WORDPRESS_URL}"