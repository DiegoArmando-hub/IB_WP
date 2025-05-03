<?php

/**
 * The base configuration for WordPress
 *
 * The wp-config.php creation script uses this file during the installation.
 * You don't have to use the web site, you can copy this file to "wp-config.php"
 * and fill in the values.
 *
 * This file contains the following configurations:
 *
 * * Database settings
 * * Secret keys
 * * Database table prefix
 * * Localized language
 * * ABSPATH
 *
 * @link https://wordpress.org/support/article/editing-wp-config-php/
 *
 * @package WordPress
 */

// ** Database settings - You can get this info from your web host ** //
/** The name of the database for WordPress */
define('DB_NAME', 'wordpress');

/** Database username */
define('DB_USER', 'wp_user');

/** Database password */
define('DB_PASSWORD', 'Wp$3cureP@ss_V2!');

/** Database hostname */
define('DB_HOST', '172.28.0.2');

/** Database charset to use in creating database tables. */
define('DB_CHARSET', 'utf8');

/** The database collate type. Don't change this if in doubt. */
define('DB_COLLATE', '');

/**#@+
 * Authentication unique keys and salts.
 *
 * Change these to different unique phrases! You can generate these using
 * the {@link https://api.wordpress.org/secret-key/1.1/salt/ WordPress.org secret-key service}.
 *
 * @since 2.6.0
 */
define('AUTH_KEY',          's,^)fdZ8`+<VJ@Qyyj*rCcXSs]~|bpelYf_5[YS?4Bx#:f#GTfl%D,z2vjjV/txm');
define('SECURE_AUTH_KEY',   'kAsLvz^i!Oo,TLR}r!XW>w{B4-mR2+O[ciev$1sCtW4EelAB^Tf~F-G]%jvd2J<Z');
define('LOGGED_IN_KEY',     '$^rIoY/[?NUeMP2evX_0*W,=!40j-#apVoJ}>^Y Fn]CN:|&;X%;V_jwDCSL[qdZ');
define('NONCE_KEY',         'scWem#?)D_=8sg~Yxh#| q~@bT7ATqjm^<6m9N+3!?}x*ZTY6Gji`t73Ijo%97`?');
define('AUTH_SALT',         'HDAg7lD$2^[2{:~M;v `f,B|K}%v.onM--:#c6Tq&&yA5LR(Nf~MB58G<GqTZ{},');
define('SECURE_AUTH_SALT',  'D%)K<p1K^cnC*m!/<8MOuIOJ01|n&_9MI-b@QA@j+EG#t- eELS~c(Qx@s/iH5<N');
define('LOGGED_IN_SALT',    '[F{p6jjL&DMk/pQu1E F6>E(Mp6G}FNs!~A[,ESh+6P8g:ut0#jz4F9}EE<[Swk_');
define('NONCE_SALT',        '%[;V`P@(Bt?48Z7<l1N2IV3|Ar:O<oH0Ksw!_(oyAnB]_od|yZd8up^NUy0C@EBG');
define('WP_CACHE_KEY_SALT', '-9dUd9UiTo <|.Gsk[1pCH.0Wf#vo]]p(T0Xkt]>]^n3%Sz{R[aZ|0Dqo@@7$YM1');

/**#@-*/

/**
 * WordPress database table prefix.
 *
 * You can have multiple installations in one database if you give each
 * a unique prefix. Only numbers, letters, and underscores please!
 */
$table_prefix = 'wp_';

/* Add any custom values between this line and the "stop editing" line. */

/**
 * For developers: WordPress debugging mode.
 *
 * Change this to true to enable the display of notices during development.
 * It is strongly recommended that plugin and theme developers use WP_DEBUG
 * in their development environments.
 *
 * For information on other constants that can be used for debugging,
 * visit the documentation.
 *
 * @link https://wordpress.org/support/article/debugging-in-wordpress/
 */
if (! defined('WP_DEBUG')) {
	define('WP_DEBUG', true);
}

/** File system method for WordPress updates. */
if (! defined('FS_METHOD')) {
	define('FS_METHOD', 'direct');
}

/* That's all, stop editing! Happy publishing. */

/** Absolute path to the WordPress directory. */
if (! defined('ABSPATH')) {
	define('ABSPATH', __DIR__ . '/');
}

/** Sets up WordPress vars and included files. */
require_once ABSPATH . 'wp-settings.php';
