# syntax=docker/dockerfile:1.4
FROM wordpress:php8.2-fpm

ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8

# Instalar dependencias y limpiar caché
RUN apt-get update && apt-get install -y \
    mariadb-client \
    curl \
    unzip \
    dos2unix \
    rsync \
    sudo \
    && rm -rf /var/lib/apt/lists/*

# Instalar WP-CLI con verificación de integridad
RUN curl -o /usr/local/bin/wp https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && echo "a39021ac809530ea607580dbf93afbc46ba02f86b6cffd03de4b126ca53079f6 /usr/local/bin/wp" | sha256sum -c - \
    && chmod +x /usr/local/bin/wp

# Configuración PHP personalizada
COPY ./config/php/conf.d/custom.ini /usr/local/etc/php/conf.d/

# Copiar temas y plugins (si no se usan volúmenes)
COPY --chown=www-data:www-data ./themes /var/www/html/wp-content/themes_custom
COPY --chown=www-data:www-data ./plugins /var/www/html/wp-content/plugins_custom

# Copiar script de instalación
COPY --chmod=755 install.sh /usr/local/bin/

# Configurar permisos y finalizar
RUN dos2unix /usr/local/bin/install.sh \
    && chown -R www-data:www-data /var/www/html \
    && find /var/www/html -type d -exec chmod 755 {} \; \
    && find /var/www/html -type f -exec chmod 644 {} \; \
    && echo "www-data ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# Definir entrada del contenedor y comando por defecto
ENTRYPOINT ["/usr/local/bin/install.sh"]
CMD ["php-fpm"]