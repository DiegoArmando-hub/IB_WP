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

# Establecer valor predeterminado para WP_DEBUG si no está definido
if [ -z "${WP_DEBUG:-}" ]; then
  WP_DEBUG=false
fi

# Esperar a MySQL
echo "🕒 Esperando MySQL..."
for i in {1..10}; do
  if mysqladmin ping -h"${WORDPRESS_DB_HOST%:*}" -u"${WORDPRESS_DB_USER}" -p"${WORDPRESS_DB_PASSWORD}" --silent; then
    echo "✅ MySQL listo"
    break
  else
    echo "🔄 Intento $i/10 fallido"
    [ $i -eq 10 ] && { echo "❌ No se pudo conectar a MySQL"; exit 1; }
    sleep $((i * 2))
  fi
done

# Descargar WordPress si no está presente
if [ ! -f /var/www/html/wp-settings.php ]; then
  echo ">>> Descargando WordPress..."
  wp core download --locale=es_ES --allow-root --force
fi

# Configurar WordPress
if [ ! -f /var/www/html/wp-config.php ]; then
  echo ">>> Creando wp-config.php..."
  wp config create \
    --dbname="${WORDPRESS_DB_NAME}" \
    --dbuser="${WORDPRESS_DB_USER}" \
    --dbpass="${WORDPRESS_DB_PASSWORD}" \
    --dbhost="${WORDPRESS_DB_HOST}" \
    --allow-root \
    --force
fi

# Instalar WordPress
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

echo "✅ Instalación completada en ${WORDPRESS_URL}"