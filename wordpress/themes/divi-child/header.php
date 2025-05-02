<?php

/**
 * Header Template for Divi Child Theme
 */
?>
<!DOCTYPE html>
<html <?php language_attributes(); ?>>

<head>
    <meta charset="<?php bloginfo('charset'); ?>">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="<?php bloginfo('description'); ?>">
    <?php wp_head(); ?>
</head>

<body <?php body_class(); ?>>
    <?php
    // Ruta al archivo infoCliente.txt
    $info_cliente_file = get_stylesheet_directory() . '/infoCliente.txt';

    // Leer y procesar el archivo
    $company_info = [];
    if (file_exists($info_cliente_file)) {
        $lines = file($info_cliente_file, FILE_IGNORE_NEW_LINES | FILE_SKIP_EMPTY_LINES);
        foreach ($lines as $line) {
            list($key, $value) = explode('=', $line, 2);
            $company_info[trim($key)] = trim($value);
        }
    }
    ?>
    <!-- Top Bar -->
    <div class="top-bar" role="banner">
        <div class="container">
            <div class="social-icons">
                <?php
                // Generar dinámicamente los enlaces de redes sociales
                $social_keys = ['Facebook', 'Twitter', 'Google', 'Pinterest', 'LinkedIn'];
                foreach ($social_keys as $key) {
                    if (!empty($company_info[$key])) {
                        echo '<a href="' . esc_url($company_info[$key]) . '" target="_blank" aria-label="' . esc_attr($key) . '">
                                <i class="fab fa-' . strtolower($key) . '"></i>
                              </a>';
                    }
                }
                ?>
            </div>
            <div class="contact-info">
                <?php if (!empty($company_info['phone'])) : ?>
                    <span>
                        <i class="fas fa-phone-alt"></i>
                        <a href="tel:<?php echo esc_attr($company_info['phone']); ?>">
                            <?php echo esc_html($company_info['phone']); ?>
                        </a>
                    </span>
                <?php endif; ?>
                <?php if (!empty($company_info['email'])) : ?>
                    <span>
                        <i class="fas fa-envelope"></i>
                        <a href="mailto:<?php echo esc_url($company_info['email']); ?>">
                            <?php echo esc_html($company_info['email']); ?>
                        </a>
                    </span>
                <?php endif; ?>
            </div>
        </div>
    </div>

    <!-- Main Header -->
    <header id="main-header" role="navigation">
        <div class="container">
            <div class="logo-container">
                <?php
                if (has_custom_logo()) {
                    the_custom_logo();
                } else {
                    echo '<a href="' . esc_url(home_url('/')) . '">';
                    echo '<img src="' . get_stylesheet_directory_uri() . '/img/logo.png" alt="' . esc_attr(get_bloginfo('name')) . '">';
                    echo '</a>';
                }
                ?>
            </div>
            <nav class="main-nav" aria-label="Main Menu">
                <?php
                wp_nav_menu(array(
                    'theme_location' => 'primary-menu',
                    'container' => false,
                    'menu_class' => 'menu',
                    'fallback_cb' => false,
                ));
                ?>
            </nav>
            <div class="search-container">
                <form method="get" action="<?php echo esc_url(home_url('/')); ?>" role="search">
                    <label for="search-bar" class="screen-reader-text">Buscar:</label>
                    <input type="text" id="search-bar" name="s" placeholder="Buscar..." aria-label="Search">
                    <button type="submit" aria-label="Submit Search"><i class="fas fa-search"></i></button>
                </form>
            </div>
        </div>
    </header>
    <?php wp_footer(); ?>
</body>

</html>