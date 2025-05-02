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
    <?php wp_head(); ?>
</head>

<body <?php body_class(); ?>>
    <!-- Top Bar -->
    <div class="top-bar">
        <div class="container">
            <div class="social-icons">
                <a href="#"><i class="fab fa-facebook-f"></i></a>
                <a href="#"><i class="fab fa-twitter"></i></a>
                <a href="#"><i class="fab fa-google"></i></a>
                <a href="#"><i class="fab fa-pinterest"></i></a>
                <a href="#"><i class="fab fa-linkedin-in"></i></a>
            </div>
            <div class="contact-info">
                <span><i class="fas fa-phone-alt"></i> 800-2345-6789</span>
                <span><i class="fas fa-envelope"></i> <a href="mailto:globaly@demolink.org">globaly@demolink.org</a></span>
            </div>
        </div>
    </div>

    <!-- Main Header -->
    <header id="main-header">
        <div class="container">
            <div class="logo-container">
                <?php
                if (has_custom_logo()) {
                    the_custom_logo();
                } else {
                    echo '<a href="' . esc_url(home_url('/')) . '">';
                    echo '<img src="' . get_stylesheet_directory_uri() . '/img/logo.png" alt="' . get_bloginfo('name') . '">';
                    echo '</a>';
                }
                ?>
            </div>
            <nav class="main-nav">
                <?php
                wp_nav_menu(array(
                    'theme_location' => 'primary-menu',
                    'container' => false,
                    'menu_class' => 'menu',
                ));
                ?>
            </nav>
            <div class="search-container">
                <form method="get" action="<?php echo esc_url(home_url('/')); ?>">
                    <input type="text" name="s" placeholder="Search...">
                    <button type="submit"><i class="fas fa-search"></i></button>
                </form>
            </div>
        </div>
    </header>
    <?php wp_footer(); ?>
</body>

</html>