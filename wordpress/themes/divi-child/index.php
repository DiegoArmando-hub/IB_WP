<?php

/**
 * Index Template for Divi Child Theme
 * Carga las plantillas del tema padre si no hay una personalizada.
 */

if (!defined('ABSPATH')) {
    exit; // Salir si se accede directamente
}

get_header();
?>
<main id="content" role="main">
    <?php
    if (have_posts()) {
        while (have_posts()) {
            the_post();
            // Aquí puedes incluir la plantilla modular de Divi
            echo do_shortcode('[et_pb_section][et_pb_row][et_pb_text]¡Contenido dinámico de Divi aquí![/et_pb_text][/et_pb_row][/et_pb_section]');
        }
    } else {
        get_template_part('template-parts/content', 'none');
    }
    ?>
</main>
<?php
get_footer();
