<?php

/**
 * The template for displaying all pages
 *
 * This is the template that displays all pages by default.
 * You can customize it further for specific needs.
 *
 * @package Divi-Child
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

            // Renderizar el contenido de la página
            the_content();

            // // Renderizar shortcodes de Divi directamente si es necesario
            // echo do_shortcode('[et_pb_section][et_pb_row][et_pb_text]¡Contenido dinámico de Divi aquí![/et_pb_text][/et_pb_row][/et_pb_section]');
        }
    } else {
        echo '<p>No se encontró contenido para esta página.</p>';
    }
    ?>
</main>
<?php
get_footer();
