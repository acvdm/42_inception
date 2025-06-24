#!/bin/bash

#-----------------------INSTALL WORDPRESS 
if [ ! -f /var/www/wordpress/wp-config.php ]; then
    echo "Installation de Wordpress..."

    # install wp-cli
    curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
    chmod +x wp-cli.phar
    mv wp-cli.phar /usr/bin/wp

    # prepare wordpress directory
    mkdir -p /var/www/wordpress
    cd /var/www/wordpress
    chmod -R 755 /var/www/wordpress
    chown -R www-data:www-data /var/www/wordpress

    # installer wordpress
    wp core download --allow-root

    # configuration wp-config.php 
    wp core config \
        --dbhost="mariadb:3306" \
        --dbname="$SQL_DATABASE" \
        --dbuser="$SQL_USER" \
        --dbpass="$SQL_PWD" \
        --allow-root 

    # wordpress installation + configuration
    wp core install \
        --url="$WP_DOMAIN_NAME" \
        --title="$WP_TITLE" \
        --admin_user="$WP_ADMIN_NAME" \
        --admin_password="$WP_ADMIN_PWD" \
        --admin_email="$WP_ADMIN_EMAIL" \
        --allow-root

    # create a new user
    wp user create "$WP_USER_NAME" "$WP_USER_EMAIL" \
        --user-pass="$WP_USER_PWD" \
        --role="$WP_USER_ROLE" \
        --allow-root
    echo "Wordpress installe avec succes !"
else
    echo "Wordpress deja configure, demarrage..."
fi

#-----------------------PHP-FPM CONFIGURATION
sed -i '36 s@/run/php/php7.4-fpm.sock@9000@' /etc/php/7.4/fpm/pool.d/www.conf
mkdir -p /run/php

#-----------------------LAUNCH PHP-FPM
/usr/sbin/php-fpm7.4 -F


