<?php

/**
 * Footer Template for Divi Child Theme
 */
?>
<footer id="main-footer" role="contentinfo">
    <div class="footer-top">
        <div class="container">
            <!-- Redes Sociales -->
            <div class="footer-social-icons">
                <?php
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

            <!-- Información de Contacto -->
            <div class="footer-contact-info">
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
    <div class="footer-bottom">
        <div class="container">
            <p>&copy; <?php echo date('Y'); ?> <?php bloginfo('name'); ?>. Todos los derechos reservados.</p>
        </div>
    </div>
    <?php wp_footer(); ?>
</footer>