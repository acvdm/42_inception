#!/bin/bash

#-----------------------INSTALL WORDPRESS 
if [ ! -f /var/www/wordpress/wp-config.php ]; then

    # prepare wordpress directory
    mkdir -p /var/www/wordpress
    cd /var/www/wordpress
    chmod -R 755 /var/www/wordpress
    chown -R www-data:www-data /var/www/wordpress

    cd /var/www/wordpress

    # install wp-cli
    curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
    chmod +x wp-cli.phar
    mv wp-cli.phar /usr/bin/wp

    # installer wordpress
    wp core download --allow-root
    cp wp-config-sample.php wp-config.php 

    if [ ! -f /var/www/wordpress/wp-config-sample.php ]; then
        echo "ERREUR: fichier wp-config-sample.php non trouve..."
    fi

    sed -i "s/database_name_here/$SQL_DATABASE/" wp-config.php
    sed -i "s/username_here/$SQL_USER/" wp-config.php
    sed -i "s/password_here/$SQL_PWD/" wp-config.php
    sed -i "s/localhost/mariadb/" wp-config.php

    if [ ! -f /var/www/wordpress/wp-config.php ]; then
        echo "wp-config.php n'a pas ete cree..."
        exit 1
    fi

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
        --user_pass="$WP_USER_PWD" \
        --role="$WP_USER_ROLE" \
        --allow-root
    echo "Wordpress installe avec succes !"
    
else
    echo "Wordpress est deja installe !"
fi

#-----------------------PHP-FPM CONFIGURATION
sed -i '36 s@/run/php/php7.4-fpm.sock@9000@' /etc/php/7.4/fpm/pool.d/www.conf
mkdir -p /run/php

#-----------------------LAUNCH PHP-FPM
/usr/sbin/php-fpm7.4 -F


