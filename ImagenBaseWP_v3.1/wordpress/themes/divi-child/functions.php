<?php
/**
 * Divi Child Theme Functions
 * @package Divi-Child
 * @version 1.0
 */

// Seguridad: No ejecutar directamente
defined('ABSPATH') || exit;

// ==============================================
// 1. CARGAR ESTILOS Y SCRIPTS (VERSIÓN OPTIMIZADA)
// ==============================================
function divi_child_enqueue_styles() {
    // CSS principal de Divi (versión minimizada)
    wp_enqueue_style(
        'divi-parent-style', 
        get_template_directory_uri() . '/style.min.css',
        array(),
        wp_get_theme('Divi')->get('Version')
    );
    
    // CSS del tema hijo con dependencia del padre
    wp_enqueue_style(
        'divi-child-style',
        get_stylesheet_uri(),
        array('divi-parent-style'),
        wp_get_theme()->get('Version')
    );
}
add_action('wp_enqueue_scripts', 'divi_child_enqueue_styles', 20);

// ==============================================
// 2. CONFIGURACIÓN INICIAL DEL TEMA
// ==============================================
function divi_child_setup() {
    // Ruta de imágenes (uso de constante)
    define('DIVI_CHILD_IMG_URI', get_stylesheet_directory_uri() . '/img/');
    
    // Soporte para WooCommerce
    add_theme_support('woocommerce');
    
    // Habilitar shortcodes en plantillas JSON
    add_filter('et_builder_enable_shortcode_in_template', '__return_true');
}
add_action('after_setup_theme', 'divi_child_setup');

// ==============================================
// 3. META TAGS PERSONALIZADOS
// ==============================================
function divi_child_add_meta_tags() {
    echo '<meta name="author" content="Diego Armando">';
}
add_action('wp_head', 'divi_child_add_meta_tags', 5);

// ==============================================
// 4. SHORTCODES PERSONALIZADOS
// ==============================================
add_shortcode('divi_child_logo', function() {
    return DIVI_CHILD_IMG_URI . 'logo.png';
});

// ==============================================
// 5. DEBUG (ELIMINAR EN PRODUCCIÓN)
// ==============================================
function divi_child_css_debug() {
    echo '<style>body { border: 5px solid lime !important; }</style>';
    
    if (wp_style_is('divi-child-style', 'enqueued')) {
        error_log('[Divi Child] ✅ CSS cargado correctamente');
    } else {
        error_log('[Divi Child] ❌ Error: CSS no detectado');
    }
}
add_action('wp_footer', 'divi_child_css_debug');

// ==============================================
// 6. SEGURIDAD (OPCIONAL - RECOMENDADO EN wp-config.php)
// ==============================================
if (!defined('DISALLOW_FILE_EDIT')) {
    define('DISALLOW_FILE_EDIT', true);
}
