<?php

/**
 * Configuración principal de WordPress.
 * Este archivo es generado y modificado automáticamente por el script de instalación.
 * Todas las variables sensibles y de entorno se obtienen de variables de entorno para seguridad y portabilidad.
 */

// --- Configuración de la base de datos ---
// Se obtienen los datos de conexión de variables de entorno para facilitar el cambio de entorno sin editar este archivo.
define('DB_NAME', getenv('WORDPRESS_DB_NAME'));
define('DB_USER', getenv('WORDPRESS_DB_USER'));
define('DB_PASSWORD', getenv('WORDPRESS_DB_PASSWORD'));
define('DB_HOST', getenv('WORDPRESS_DB_HOST'));
define('DB_CHARSET', 'utf8');
define('DB_COLLATE', '');

// --- Claves de seguridad y salts ---
// Estas líneas se insertan automáticamente por install.sh usando la API oficial de WordPress.
// No edites manualmente, se sobrescribirán en cada despliegue.
// Ejemplo:
// define('AUTH_KEY',         '...');
// define('SECURE_AUTH_KEY',  '...');
// define('LOGGED_IN_KEY',    '...');
// define('NONCE_KEY',        '...');
// define('AUTH_SALT',        '...');
// define('SECURE_AUTH_SALT', '...');
// define('LOGGED_IN_SALT',   '...');
// define('NONCE_SALT',       '...');

// --- Prefijo de tablas ---
// Puedes cambiarlo si quieres usar múltiples instalaciones en una sola base de datos.
$table_prefix = 'wp_';

// --- Modo debug ---
// Se activa o desactiva según la variable de entorno WP_DEBUG.
define('WP_DEBUG', getenv('WP_DEBUG') === 'true');

// --- Hardening y ajustes recomendados ---
define('FS_METHOD', 'direct');             // Permite actualizaciones directas desde el panel.
define('DISALLOW_FILE_EDIT', true);        // Bloquea la edición de archivos desde el panel de WordPress.
define('WP_AUTO_UPDATE_CORE', 'minor');    // Solo permite actualizaciones menores automáticas.

// --- Configuración dinámica de URL y dominio ---
// Así, al cambiar WORDPRESS_URL en el .env, WordPress usará automáticamente la URL correcta sin editar este archivo.
$wordpress_url = getenv('WORDPRESS_URL');
if ($wordpress_url) {
	define('WP_HOME', $wordpress_url);     // Dirección principal del sitio
	define('WP_SITEURL', $wordpress_url);  // Dirección de WordPress (core)
}

// --- Carga opcional de configuración local ---
// Permite sobreescribir configuraciones para entornos específicos (por ejemplo, desarrollo local).
if (file_exists(__DIR__ . '/wp-config-local.php')) {
	include(__DIR__ . '/wp-config-local.php');
}

// --- Fin de la configuración estándar ---
// Define la ruta absoluta al directorio de WordPress.
if (!defined('ABSPATH')) {
	define('ABSPATH', __DIR__ . '/');
}
require_once(ABSPATH . 'wp-settings.php');
