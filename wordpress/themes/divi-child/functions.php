<?php
// Asegura que los estilos del tema padre se carguen correctamente
add_action('wp_enqueue_scripts', function () {
    wp_enqueue_style('parent-style', get_template_directory_uri() . '/style.css');
});
