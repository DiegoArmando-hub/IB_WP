<?php

/**
 * Configuración principal de WordPress.
 * Este archivo es generado y modificado automáticamente por el script de instalación.
 * Todas las variables sensibles se obtienen de variables de entorno por seguridad y portabilidad.
 */

// --- Configuración de la base de datos ---
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
$table_prefix = 'wp_';

// --- Modo debug ---
define('WP_DEBUG', getenv('WP_DEBUG') === 'true');

// --- Hardening y ajustes recomendados ---
define('FS_METHOD', 'direct');             // Permite actualizaciones directas
define('DISALLOW_FILE_EDIT', true);        // Bloquea edición de archivos desde el panel
define('WP_AUTO_UPDATE_CORE', 'minor');    // Solo actualizaciones menores automáticas

// --- Carga opcional de configuración local ---
if (file_exists(__DIR__ . '/wp-config-local.php')) {
	include(__DIR__ . '/wp-config-local.php');
}

// --- Fin de la configuración estándar ---
if (!defined('ABSPATH')) {
	define('ABSPATH', __DIR__ . '/');
}
require_once(ABSPATH . 'wp-settings.php');
