#!/bin/bash

#-----------------------CHECK ENVIRONMENT VARIABLES
if [ -z "$SQL_DATABASE" ] || [ -z "$SQL_USER" ] || [ -z "$SQL_PWD" ] || [ -z "$SQL_ROOT_PWD" ]; then
    echo "ERREUR: Variables d'environnement manquantes (SQL_DATABASE, SQL_USER, SQL_PWD, SQL_ROOT_PWD)"
    exit 1
fi

#-----------------------KILL EXISTING PID
pkill mysqld || true
pkill mariadb || true
sleep 2

#-----------------------START  MARIADB
echo "Demarrage de MariaDB en mode securise..."

mysqld_safe --skip-grant-tables --skip-networking &
MYSQL_PID=$!
sleep 10

if ! pgrep mysqld > /dev/null; then
    echo "ERREUR: impossible de demarrer MariaDB"
    exit 1
fi

#-----------------------CONFIG MARIADB
echo "Configuration de la base de donnees..."

mysql -u root << EOF
FLUSH PRIVILEGES;
ALTER USER 'root'@'localhost' IDENTIFIED BY '$SQL_ROOT_PWD';
CREATE DATABASE IF NOT EXISTS $SQL_DATABASE;
CREATE USER IF NOT EXISTS '$SQL_USER'@'%' IDENTIFIED BY '$SQL_PWD';
GRANT ALL PRIVILEGES ON $SQL_DATABASE.* TO '$SQL_USER'@'%';
FLUSH PRIVILEGES;
EOF

if [ $? -ne 0 ]; then
    echo "ERREUR: Echec de la configuration MariaDB"
    kill $MYSQL_PID
    exit 1
fi

echo "Configuration de la base de donnees reussie..."

#-----------------------RESTART MARIADB 
echo "Redemarrage MariaDB en mode normal"

kill $MYSQL_PID
sleep 5

pkill mysqld ||true
pkill mariadb || true
sleep 2

exec mysqld_safe --port=3306 --bind-address=0.0.0.0 --datadir='/var/lib/mysql'
