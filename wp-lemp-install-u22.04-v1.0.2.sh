#!/bin/bash
echo ""
echo "************************"
echo ""
echo "LEMP Stack & Wordpress"
echo "Instalasi"
echo "Script V1.0.2"
echo ""
echo "************************"
echo ""
if [[ $EUID -ne 0 ]]; then
   echo "Script ini harus dijalankan oleh root" 
   exit 1
fi
echo "Script ini akan menginstal LEMP Stack & Wordpress untuk sistem Anda."
echo ""
read -p "Tekan enter to melanjutkan instalasi. Jika ingin membatalkan instalasi, tekan 'Ctrl + C'."
echo ""
echo "Sebelum memulai proses instalasi, mohon ketik nama dan password untuk variabel berikut"
echo ""
echo "Password untuk user 'root' pada MariaDB"
echo ""
read dbrootpass
echo ""
echo "Nama database untuk Wordpress:"
echo ""
read wpdbname
echo ""
echo "Nama user untuk database Wordpress:"
echo ""
read wpdbuser
echo ""
echo "Password untuk user database Wordpress:"
echo ""
read wpdbpass
echo ""
echo "Terima kasih!"
echo "Memulai proses instalasi..."
echo ""
#
# Nginx Install
apt-get update
apt-get install nginx -y
systemctl is-enabled nginx
#
# MariaDB Install
apt-get install mariadb-server mariadb-client -y
systemctl is-enabled mariadb
printf "\n y\n y\n ${dbrootpass}\n ${dbrootpass}\n y\n y\n y\n y\n" | sudo mysql_secure_installation
#
# MariaDB Create Database
mysql -e "CREATE DATABASE ${wpdbname};"
mysql -e "GRANT ALL PRIVILEGES ON ${wpdbname}.* TO '${wpdbuser}'@'localhost' IDENTIFIED BY '${wpdbpass}';"
mysql -e "FLUSH PRIVILEGES;"
#
# PHP Install
apt-get install php php-mysql php-fpm php-zip -y
systemctl is-enabled php8.1-fpm
#
# WP Install
apt-get install unzip -y
cd /tmp
wget -c https://wordpress.org/latest.zip
unzip latest.zip
mv wordpress /var/www/html/wordpress
rm latest.zip
cd /var/www/html/wordpress
echo "<?php
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
 * * ABSPATH
 *
 * @link https://wordpress.org/support/article/editing-wp-config-php/
 *
 * @package WordPress
 */

// ** Database settings - You can get this info from your web host ** //
/** The name of the database for WordPress */
define( 'DB_NAME', '${wpdbname}' );

/** Database username */
define( 'DB_USER', '${wpdbuser}' );

/** Database password */
define( 'DB_PASSWORD', '${wpdbpass}' );

/** Database hostname */
define( 'DB_HOST', 'localhost' );

/** Database charset to use in creating database tables. */
define( 'DB_CHARSET', 'utf8' );

/** The database collate type. Don't change this if in doubt. */
define( 'DB_COLLATE', '' );

/**#@+
 * Authentication unique keys and salts.
 *
 * Change these to different unique phrases! You can generate these using
 * the {@link https://api.wordpress.org/secret-key/1.1/salt/ WordPress.org secret-key service}.
 *
 * You can change these at any point in time to invalidate all existing cookies.
 * This will force all users to have to log in again.
 *
 * @since 2.6.0
 */
define( 'AUTH_KEY',         'put your unique phrase here' );
define( 'SECURE_AUTH_KEY',  'put your unique phrase here' );
define( 'LOGGED_IN_KEY',    'put your unique phrase here' );
define( 'NONCE_KEY',        'put your unique phrase here' );
define( 'AUTH_SALT',        'put your unique phrase here' );
define( 'SECURE_AUTH_SALT', 'put your unique phrase here' );
define( 'LOGGED_IN_SALT',   'put your unique phrase here' );
define( 'NONCE_SALT',       'put your unique phrase here' );

/**#@-*/

/**
 * WordPress database table prefix.
 *
 * You can have multiple installations in one database if you give each
 * a unique prefix. Only numbers, letters, and underscores please!
 */
\$table_prefix = 'wp_';

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
define( 'WP_DEBUG', false );

/* Add any custom values between this line and the "stop editing" line. */



/* That's all, stop editing! Happy publishing. */

/** Absolute path to the WordPress directory. */
if ( ! defined( 'ABSPATH' ) ) {
	define( 'ABSPATH', __DIR__ . '/' );
}

/** Sets up WordPress vars and included files. */
require_once ABSPATH . 'wp-settings.php';" >> wp-config.php
echo "server {
        listen 80;
        listen [::]:80;
        root /var/www/html/wordpress;
        index  index.php index.html index.htm;
        server_name ${wpdbname};

        error_log /var/log/nginx/${wpdbname}_error.log;
        access_log /var/log/nginx/${wpdbname}_access.log;

        client_max_body_size 100M;
        location / {
                try_files \$uri \$uri/ /index.php?\$args;
        }
        location ~ \.php$ {
                include snippets/fastcgi-php.conf;
                fastcgi_pass unix:/run/php/php8.1-fpm.sock;
                fastcgi_param   SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
        }
}" >> /etc/nginx/conf.d/${wpdbname}.conf
rm /etc/nginx/sites-enabled/default
rm /etc/nginx/sites-available/default
nginx -t
systemctl restart nginx
systemctl disable apache2
#
# PHP.ini modifications
cd /etc/php/8.1/fpm
mv php.ini php.ini.ori
wget https://raw.githubusercontent.com/chronz/shiny-guacamole/main/php.ini
systemctl restart php8.1-fpm
chown -R www-data:www-data /var/www/html/wordpress
echo ""
echo "*************************"
echo ""
echo "LEMP Stack & Wordpress"
echo "Instalasi"
echo "Script V1.0.2"
echo ""
echo "Berhasil Terinstal"
echo ""
echo "Silahkan selesaikan instalasi pada web GUI server yang dapat diakses dari:"
echo "http://SERVER_IP/"
echo ""
echo "Wordpress DB Name: ${wpdbname}"
echo "Wordpress DB User: ${wpdbuser}"
echo "Wordpress Lokasi Instal: /var/www/html/wordpress"
echo ""
echo "************************"
