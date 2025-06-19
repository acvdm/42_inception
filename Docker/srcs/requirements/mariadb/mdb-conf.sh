#1/bin/bash
set -e

#-----------------------START  MARIADB
service mariadb start

#-----------------------CONFIG MARIADB
mysql -e "CREATE DATABASE IF NOT EXISTS $SQL_DATABASE"
mysql -e "CREATE USER '$SQL_USER'@wordpress IDENTIFIED BY '$SQL_PWD;'"
mysql -e "GRANT ALL PRIVILEGES ON $SQL_DATABASE.* TO '$SQL_USER'@wordpress IDENTIFIED BY '$SQL_PWD;'"

#-----------------------RESTART MARIADB 
mysqladmin -u root -p$SQL_ROOT_PWD shutdown
mysqld_safe --port=3306 --bin-address=0.0.0.0 --datadir='/var/lib/mysql'