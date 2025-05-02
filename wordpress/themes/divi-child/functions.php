<?php

/**
 * Divi Child Theme Functions
 * @package Divi-Child
 * @version 1.0
 */

defined('ABSPATH') || exit;

// ==============================================
// 1. CONFIGURACIÓN BÁSICA DEL TEMA
// ==============================================
function divi_child_setup()
{
    // Cargar traducciones
    load_child_theme_textdomain('divi-child', get_stylesheet_directory() . '/languages');

    // Registrar menús
    register_nav_menus(array(
        'primary-menu' => __('Menú Principal', 'divi-child'),
        'footer-menu' => __('Menú de Pie', 'divi-child')
    ));

    // Configurar logo personalizado
    add_theme_support('custom-logo', array(
        'height'      => 80,
        'width'       => 180,
        'flex-height' => true,
        'flex-width'  => true,
    ));
}
add_action('after_setup_theme', 'divi_child_setup');

// ==============================================
// 2. CARGAR ESTILOS Y SCRIPTS
// ==============================================
function divi_child_enqueue_styles()
{
    // Cargar estilo del tema padre (Divi)
    wp_enqueue_style(
        'divi-parent-style',
        get_template_directory_uri() . '/style.css',
        array(),
        wp_get_theme('Divi')->get('Version')
    );

    // Cargar estilo del tema hijo
    wp_enqueue_style(
        'divi-child-style',
        get_stylesheet_uri(),
        array('divi-parent-style'),
        wp_get_theme()->get('Version')
    );
}
add_action('wp_enqueue_scripts', 'divi_child_enqueue_styles', 20);

// ==============================================
// 3. SHORTCODES PARA PLANTILLAS
// ==============================================
function divi_child_logo_shortcode()
{
    if (function_exists('the_custom_logo')) {
        ob_start();
        the_custom_logo();
        return ob_get_clean();
    }
    return '';
}
add_shortcode('divi_child_logo', 'divi_child_logo_shortcode');

function divi_child_site_title_shortcode()
{
    return esc_html(get_bloginfo('name'));
}
add_shortcode('divi_child_site_title', 'divi_child_site_title_shortcode');

// ==============================================
// 4. CONFIGURACIÓN ADICIONAL
// ==============================================
function divi_child_theme_support()
{
    add_theme_support('title-tag');
    add_theme_support('post-thumbnails');
    add_theme_support('html5', array(
        'search-form',
        'comment-form',
        'comment-list',
        'gallery',
        'caption',
    ));
}
add_action('after_setup_theme', 'divi_child_theme_support');
