# syntax=docker/dockerfile:1.4
FROM wordpress:php8.2-fpm

ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8

RUN apt-get update && apt-get install -y \
    mariadb-client \
    curl \
    unzip \
    dos2unix \
    rsync \
    sudo \
    && rm -rf /var/lib/apt/lists/*

# Instalar WP-CLI
RUN curl -o /usr/local/bin/wp https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x /usr/local/bin/wp

# Configuración PHP personalizada
COPY ./config/php/conf.d/custom.ini /usr/local/etc/php/conf.d/

# Copiar plugins y temas

COPY --chown=www-data:www-data ./wordpress/themes /var/www/html/wp-content/themes

# Copiar script de instalación
COPY --chmod=755 install.sh /usr/local/bin/

RUN dos2unix /usr/local/bin/install.sh \
    && chown -R www-data:www-data /var/www/html \
    && find /var/www/html -type d -exec chmod 755 {} \; \
    && find /var/www/html -type f -exec chmod 644 {} \; \
    && echo "www-data ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

RUN mkdir -p /var/www/html/wp-content/uploads \
    && chown -R www-data:www-data /var/www/html/wp-content/uploads \
    && chmod -R 755 /var/www/html/wp-content/uploads

CMD ["bash", "-c", "\
    echo '🕒 Esperando MySQL...' \
    && until mysqladmin ping -hdb -u${WORDPRESS_DB_USER} -p${WORDPRESS_DB_PASSWORD} --silent; do sleep 2; done \
    && echo '✅ MySQL listo' \
    && if [ ! -f wp-settings.php ]; then wp core download --locale=es_ES --allow-root --force; fi \
    && /usr/local/bin/install.sh \
    && php-fpm -F"]
