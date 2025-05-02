<?php

/**
 * Index Template for Divi Child Theme
 * Carga las plantillas del tema padre si no hay una personalizada.
 */

if (!defined('ABSPATH')) {
    exit; // Salir si se accede directamente
}

get_header();

if (have_posts()) {
    while (have_posts()) {
        the_post();
        get_template_part('template-parts/content', get_post_format());
    }
} else {
    get_template_part('template-parts/content', 'none');
}

get_footer();
