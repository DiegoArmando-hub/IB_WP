#!/bin/bash
set -euo pipefail

# Validar variables cr¨ªticas
required_vars=(
  "WORDPRESS_DB_NAME"
  "WORDPRESS_DB_USER"
  "WORDPRESS_DB_PASSWORD"
  "WORDPRESS_URL"
  "WORDPRESS_ADMIN_USER"
  "WORDPRESS_ADMIN_PASSWORD"
)

for var in "${required_vars[@]}"; do
  eval "value=\${${var}}"
  if [ -z "${value}" ]; then
    echo "? Variable cr¨ªtica no definida: $var"
    exit 1
  fi
done

# Esperar a MySQL
for i in {1..10}; do
  if mysqladmin ping -h172.28.0.2 -u"${WORDPRESS_DB_USER}" -p"${WORDPRESS_DB_PASSWORD}" --ssl=0 --silent; then
    echo "? MySQL responde (intento $i/10)"
    break
  else
    echo "?? Fallo ping MySQL (intento $i/10)"
    sleep $((i * 2))
  fi
done

# Conectar a la base de datos
for i in {1..10}; do
  if mysql -h172.28.0.2 -u"${WORDPRESS_DB_USER}" -p"${WORDPRESS_DB_PASSWORD}" --ssl=0 -e "USE ${WORDPRESS_DB_NAME};"; then
    echo "? Conexi¨®n exitosa (intento $i/10)"
    break
  else
    echo "?? Fallo conexi¨®n (intento $i/10)"
    [ $i -eq 10 ] && {
      echo "? Error: Credenciales incorrectas o red no configurada"
      exit 1
    }
    sleep $((i * 2))
  fi
done

# Crear wp-config.php si no existe
if [ ! -f /var/www/html/wp-config.php ]; then
  echo ">>> Generando wp-config.php..."
  wp config create \
    --dbname="${WORDPRESS_DB_NAME}" \
    --dbuser="${WORDPRESS_DB_USER}" \
    --dbpass="${WORDPRESS_DB_PASSWORD}" \
    --dbhost="172.28.0.2" \
    --allow-root \
    --force

  # Configuraciones adicionales
  echo "define('WP_SITEURL', '${WORDPRESS_URL}');" >> /var/www/html/wp-config.php
  echo "define('WP_HOME', '${WORDPRESS_URL}');" >> /var/www/html/wp-config.php
  echo "define('FS_METHOD', 'direct');" >> /var/www/html/wp-config.php
  echo "define('WP_DEBUG', ${WP_DEBUG:-false});" >> /var/www/html/wp-config.php
fi

# Instalar WordPress si no est¨¢ instalado
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

# Instalar plugins indicados en ACTIVATE_PLUGINS
echo ">>> Instalando plugins..."
for plugin in ${ACTIVATE_PLUGINS//,/ }; do
  if ! wp plugin install $plugin --allow-root --force 2>/dev/null; then
    echo "?? Plugin no instalado: $plugin (?nombre correcto?)"
  fi
done

# Copiar plugins y temas personalizados
echo ">>> Copiando assets personalizados..."
cp -a /var/www/html/wp-content/plugins_custom/. /var/www/html/wp-content/plugins/
cp -a /var/www/html/wp-content/themes_custom/. /var/www/html/wp-content/themes/

# Eliminar tema custom si existe
echo ">>> Eliminando tema custom si existe..."
wp theme delete custom --allow-root 2>/dev/null || true

# Crear y dar permisos a upgrade y languages
echo ">>> Corrigiendo permisos de wp-content/upgrade y wp-content/languages..."
mkdir -p /var/www/html/wp-content/upgrade /var/www/html/wp-content/languages
chown -R www-data:www-data /var/www/html/wp-content/upgrade /var/www/html/wp-content/languages
chmod 775 /var/www/html/wp-content/upgrade /var/www/html/wp-content/languages

# Activar el tema hijo o Divi
echo ">>> Activando tema hijo divi-child (o Divi si falla)..."
if wp theme is-installed divi-child --allow-root && wp theme is-installed divi --allow-root; then
  wp theme activate divi-child --allow-root || wp theme activate divi --allow-root
elif wp theme is-installed divi --allow-root; then
  wp theme activate divi --allow-root
fi

# Eliminar todos los temas excepto los necesarios
echo ">>> Eliminando temas predeterminados innecesarios..."
for theme in $(wp theme list --field=name --allow-root); do
  if [[ "$theme" != "divi" && "$theme" != "divi-child" ]]; then
    wp theme delete $theme --allow-root || true
  fi
done

# Seguridad: deshabilitar XML-RPC si est¨¢ configurado
if [ "${DISABLE_XMLRPC}" = "true" ]; then
  echo ">>> Deshabilitando XML-RPC..."
  echo "<?php die('Acceso denegado'); ?>" > "/var/www/html/xmlrpc.php"
fi

echo "? Instalaci¨®n completada en ${WORDPRESS_URL}"
