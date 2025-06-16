<?php
// Configuración base para WordPress en Docker

// Variables de entorno para mayor portabilidad
define('DB_NAME', getenv('WORDPRESS_DB_NAME') ?: 'wordpress');
define('DB_USER', getenv('WORDPRESS_DB_USER') ?: 'wp_user');
define('DB_PASSWORD', getenv('WORDPRESS_DB_PASSWORD') ?: 'Wp$3cureP@ss_V2!');
define('DB_HOST', getenv('WORDPRESS_DB_HOST') ?: 'db');
define('DB_CHARSET', 'utf8');
define('DB_COLLATE', '');

// Salts y claves de autenticación
define('AUTH_KEY',          's,^)fdZ8`+<VJ@Qyyj*rCcXSs]~|bpelYf_5[YS?4Bx#:f#GTfl%D,z2vjjV/txm');
define('SECURE_AUTH_KEY',   'kAsLvz^i!Oo,TLR}r!XW>w{B4-mR2+O[ciev$1sCtW4EelAB^Tf~F-G]%jvd2J<Z');
define('LOGGED_IN_KEY',     '$^rIoY/[?NUeMP2evX_0*W,=!40j-#apVoJ}>^Y Fn]CN:|&;X%;V_jwDCSL[qdZ');
define('NONCE_KEY',         'scWem#?)D_=8sg~Yxh#| q~@bT7ATqjm^<6m9N+3!?}x*ZTY6Gji`t73Ijo%97`?');
define('AUTH_SALT',         'HDAg7lD$2^[2{:~M;v `f,B|K}%v.onM--:#c6Tq&&yA5LR(Nf~MB58G<GqTZ{},');
define('SECURE_AUTH_SALT',  'D%)K<p1K^cnC*m!/<8MOuIOJ01|n&_9MI-b@QA@j+EG#t- eELS~c(Qx@s/iH5<N');
define('LOGGED_IN_SALT',    '[F{p6jjL&DMk/pQu1E F6>E(Mp6G}FNs!~A[,ESh+6P8g:ut0#jz4F9}EE<[Swk_');
define('NONCE_SALT',        '%[;V`P@(Bt?48Z7<l1N2IV3|Ar:O<oH0Ksw!_(oyAnB]_od|yZd8up^NUy0C@EBG');
define('WP_CACHE_KEY_SALT', '-9dUd9UiTo <|.Gsk[1pCH.0Wf#vo]]p(T0Xkt]>]^n3%Sz{R[aZ|0Dqo@@7$YM1');

// Prefijo de tablas
$table_prefix = 'wp_';

// Modo debug controlado por variable de entorno
define('WP_DEBUG', getenv('WP_DEBUG') === 'true');

define('WP_DEBUG_LOG', true);
define('WP_DEBUG_DISPLAY', false);


// Sistema de archivos directo (recomendado en Docker)
define('FS_METHOD', 'direct');

// Idioma por defecto
define('WPLANG', 'es_ES');

// Ruta absoluta de WordPress
if (!defined('ABSPATH')) {
	define('ABSPATH', __DIR__ . '/');
}

require_once ABSPATH . 'wp-settings.php';
