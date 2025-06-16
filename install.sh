#!/bin/bash
set -euo pipefail

# ============================================================
# Script de instalación y configuración automática de WordPress
# ============================================================
# Este script realiza las siguientes tareas:
# - Valida variables de entorno esenciales
# - Espera a que MySQL esté disponible
# - Descarga WordPress si no está presente
# - Genera claves de seguridad (salts)
# - Crea wp-config.php con configuración segura y personalizada
# - Instala WordPress si no está instalado
# - Ajusta permisos de archivos y carpetas
# - Elimina plugins por defecto (Hello Dolly, Akismet)
# - Instala y activa plugins indicados en ACTIVATE_PLUGINS
# - Copia plugins y temas personalizados si existen
# - Detecta y activa dinámicamente el tema hijo y protege el padre
# - Elimina todos los temas por defecto excepto el hijo y el padre detectados
# - Deshabilita XML-RPC si está configurado para mayor seguridad
# ============================================================

# --- Validación de variables esenciales ---
required_vars=(
  "WORDPRESS_DB_NAME"
  "WORDPRESS_DB_USER"
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

# Variables opcionales con valores por defecto
WP_DEBUG="${WP_DEBUG:-false}"
DISABLE_XMLRPC="${DISABLE_XMLRPC:-false}"

# --- Espera a que MySQL esté listo ---
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

# --- Descarga WordPress si no existe ---
if [ ! -f /var/www/html/wp-settings.php ]; then
  echo ">>> Descargando WordPress..."
  wp core download --locale=es_ES --allow-root --force
fi

# --- Genera claves de seguridad únicas (salts) ---
echo ">>> Generando claves de seguridad (salts)..."
WP_SALTS=$(curl -s https://api.wordpress.org/secret-key/1.1/salt/)

# --- Crea wp-config.php si no existe ---
if [ ! -f /var/www/html/wp-config.php ]; then
  echo ">>> Creando wp-config.php..."
  wp config create \
    --dbname="${WORDPRESS_DB_NAME}" \
    --dbuser="${WORDPRESS_DB_USER}" \
    --dbpass="${WORDPRESS_DB_PASSWORD}" \
    --dbhost="${WORDPRESS_DB_HOST}" \
    --allow-root \
    --force

  # Añade hardening y configuración adicional
  {
    echo "define('FS_METHOD', 'direct');"
    echo "define('WP_DEBUG', ${WP_DEBUG});"
    echo "define('DISALLOW_FILE_EDIT', true);"
    echo "define('WP_AUTO_UPDATE_CORE', 'minor');"
    echo "${WP_SALTS}"
  } >> /var/www/html/wp-config.php
fi

# --- Instala WordPress si aún no está instalado ---
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

# --- Ajusta permisos de archivos y carpetas ---
echo ">>> Configurando permisos de archivos..."
chown -R www-data:www-data /var/www/html
find /var/www/html -type d -exec chmod 755 {} \;
find /var/www/html -type f -exec chmod 644 {} \;

# --- Elimina plugins por defecto innecesarios ---
echo ">>> Eliminando plugins por defecto (Hello Dolly, Akismet)..."
for plugin in $(wp plugin list --field=name --allow-root); do
  case "$plugin" in
    hello|akismet)
      wp plugin delete "$plugin" --allow-root || true
      ;;
  esac
done

# --- Instala y activa plugins indicados en ACTIVATE_PLUGINS ---
echo ">>> Instalando y activando plugins indicados en ACTIVATE_PLUGINS..."
for plugin in ${ACTIVATE_PLUGINS//,/ }; do
  wp plugin install "$plugin" --allow-root --force || echo "⚠️ Plugin no instalado: $plugin"
  wp plugin activate "$plugin" --allow-root || true
done

# --- Copia plugins y temas personalizados si existen ---
if [ -d /var/www/html/wp-content/plugins_custom ]; then
  echo ">>> Copiando plugins personalizados..."
  cp -a /var/www/html/wp-content/plugins_custom/. /var/www/html/wp-content/plugins/
fi

if [ -d /var/www/html/wp-content/themes_custom ]; then
  echo ">>> Copiando temas personalizados..."
  cp -a /var/www/html/wp-content/themes_custom/. /var/www/html/wp-content/themes/
fi

# --- Detecta y activa dinámicamente el tema hijo y protege el padre ---
THEMES_DIR="/var/www/html/wp-content/themes"
CHILD_THEME=""
PARENT_THEME=""

for dir in "$THEMES_DIR"/*-child; do
  if [ -d "$dir" ]; then
    CHILD_THEME=$(basename "$dir")
    # Busca el nombre del tema padre en el style.css del hijo
    if grep -q "^Template:" "$dir/style.css"; then
      PARENT_THEME=$(grep "^Template:" "$dir/style.css" | head -n1 | awk -F': ' '{print $2}' | tr -d '\r\n')
    fi
    break  # Solo toma el primer hijo encontrado
  fi
done

if [ -n "$CHILD_THEME" ]; then
  echo ">>> Activando tema hijo detectado: $CHILD_THEME"
  wp theme activate "$CHILD_THEME" --allow-root
else
  echo "❌ No se encontró ningún tema hijo (-child) en $THEMES_DIR"
fi

# --- Elimina todos los temas excepto el hijo y el padre detectados ---
echo ">>> Eliminando todos los temas excepto el hijo activo y el padre detectado..."
for theme in $(wp theme list --field=name --allow-root); do
  if [[ "$theme" != "$CHILD_THEME" && "$theme" != "$PARENT_THEME" ]]; then
    wp theme delete "$theme" --allow-root || true
  fi
done

# --- Corrige permisos en carpetas upgrade y languages ---
echo ">>> Corrigiendo permisos de wp-content/upgrade y wp-content/languages..."
mkdir -p /var/www/html/wp-content/upgrade /var/www/html/wp-content/languages
chown -R www-data:www-data /var/www/html/wp-content/upgrade /var/www/html/wp-content/languages
chmod 775 /var/www/html/wp-content/upgrade /var/www/html/wp-content/languages

# --- Deshabilita XML-RPC si está configurado ---
if [ "${DISABLE_XMLRPC}" = "true" ]; then
  echo ">>> Deshabilitando XML-RPC..."
  echo "<?php die('Acceso denegado'); ?>" > "/var/www/html/xmlrpc.php"
fi

echo "✅ Instalación y configuración completadas en ${WORDPRESS_URL}"
