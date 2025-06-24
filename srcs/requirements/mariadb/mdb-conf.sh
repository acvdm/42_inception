#!/bin/bash

# Vérifier que les variables d'environnement sont définies
if [ -z "$SQL_DATABASE" ] || [ -z "$SQL_USER" ] || [ -z "$SQL_PWD" ] || [ -z "$SQL_ROOT_PWD" ]; then
    echo "ERREUR: Variables d'environnement manquantes (SQL_DATABASE, SQL_USER, SQL_PWD, SQL_ROOT_PWD)"
    exit 1
fi

#------------------------------------------------------
pkill mysqld || true
pkill mariadb || true
sleep 2

if pgrep mysqld > /dev/null; then
    echo "ERREUR: mysqld est toujours live"
fi

if pgrep mariadb > /dev/null; then
    echo "ERREUR: mariadb est toujours live"
fi

#-----------------------START  MARIADB
#service mariadb start
#sleep 5
echo "Demarrage de Mdb en mode securise..."
mysqld_safe --skip-grant-tables --skip-networking &
MYSQL_PID=$!
sleep 10

if ! pgrep mysqld > /dev/null; then
    echo "ERREUR: impossible de demarrer MDB"
    exit 1
fi

#-----------------------CONFIG MARIADB
#mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '$SQL_ROOT_PWD';"
#mysql -e "CREATE DATABASE IF NOT EXISTS $SQL_DATABASE;"
#mysql -e "CREATE USER IF NOT EXISTS '$SQL_USER'@'%' IDENTIFIED BY '$SQL_PWD';"
#mysql -e "GRANT ALL PRIVILEGES ON $SQL_DATABASE.* TO '$SQL_USER'@'%';"
#mysql -e "FLUSH PRIVILEGES;"

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
    echo "ERREUR: Echec de la configuration MDB"
    kill $MYSQL_PID
    exit 1
fi

echo "Configuration de la base de donnees reussie..."

#-----------------------RESTART MARIADB 
echo "Redemarrage MDB en mode normal"
kill $MYSQL_PID
sleep 5

pkill mysqld ||true
pkill mariadb || true
sleep 2


#mysqladmin -u root -p$SQL_ROOT_PWD shutdown
exec mysqld_safe --port=3306 --bind-address=0.0.0.0 --datadir='/var/lib/mysql'
#exec mysqld_safe --datadir='/var/lib/mysql'