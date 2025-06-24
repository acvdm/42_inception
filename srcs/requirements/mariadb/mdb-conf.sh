#!/bin/bash
set -e

#-----------------------START  MARIADB
service mariadb start
sleep 5

#-----------------------CONFIG MARIADB
mariadb -e "CREATE DATABASE IF NOT EXISTS $SQL_DATABASE;"
mariadb -e "CREATE USER IF NOT EXISTS '$SQL_USER'@wordpress IDENTIFIED BY '$SQL_PWD';"
mariadb -e "GRANT ALL PRIVILEGES ON $SQL_DATABASE.* TO '$SQL_USER'@wordpress IDENTIFIED BY '$SQL_PWD';"
mariadb -e "FLUSH PRIVILEGES;"

#-----------------------RESTART MARIADB 
mysqladmin -u root -p$SQL_ROOT_PWD shutdown
mysqld_safe --port=3306 --bin-address=0.0.0.0 --datadir='/var/lib/mysql'
#exec mysqld_safe --datadir='/var/lib/mysql'