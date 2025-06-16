# Imagen base oficial de WordPress con PHP 8.2 FPM
FROM wordpress:php8.2-fpm

# Configuración regional
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8

# Instalación de utilidades necesarias para administración y scripts
RUN apt-get update && apt-get install -y \
    mariadb-client \
    curl \
    unzip \
    dos2unix \
    rsync \
    sudo \
    && rm -rf /var/lib/apt/lists/*

# Instala WP-CLI para automatización de tareas WordPress
RUN curl -o /usr/local/bin/wp https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x /usr/local/bin/wp

# Añade configuración PHP personalizada
COPY ./config/php/conf.d/custom.ini /usr/local/etc/php/conf.d/

# Copia los temas personalizados y plugins_custom
COPY --chown=www-data:www-data ./wordpress/themes /var/www/html/wp-content/themes
COPY --chown=www-data:www-data ./wordpress/plugins_custom /var/www/html/wp-content/plugins_custom
COPY --chown=www-data:www-data ./wordpress/security /var/www/html/wp-content/security

# Copia el script de instalación y le da permisos de ejecución
COPY --chmod=755 install.sh /usr/local/bin/

# Normaliza saltos de línea y asegura permisos en la estructura de WordPress
RUN dos2unix /usr/local/bin/install.sh \
    && chown -R www-data:www-data /var/www/html \
    && find /var/www/html -type d -exec chmod 755 {} \; \
    && find /var/www/html -type f -exec chmod 644 {} \; \
    && echo "www-data ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# Prepara la carpeta de uploads con los permisos adecuados
RUN mkdir -p /var/www/html/wp-content/uploads \
    && chown -R www-data:www-data /var/www/html/wp-content/uploads \
    && chmod -R 755 /var/www/html/wp-content/uploads

# Comando de inicio: espera MySQL, instala WordPress si es necesario y arranca PHP-FPM
CMD ["bash", "-c", "\
    echo '🕒 Esperando MySQL...' \
    && until mysqladmin ping -hdb -u${WORDPRESS_DB_USER} -p${WORDPRESS_DB_PASSWORD} --silent; do sleep 2; done \
    && echo '✅ MySQL listo' \
    && if [ ! -f wp-settings.php ]; then wp core download --locale=es_ES --allow-root --force; fi \
    && /usr/local/bin/install.sh \
    && php-fpm -F"]
