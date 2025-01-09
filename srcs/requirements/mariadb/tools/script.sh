# #!/bin/sh

# # Avvia il server MySQL in background
# mysqld_safe &

# # Attendere che il server MySQL sia completamente operativo
# until mysql -u root -e "SELECT 1" > /dev/null 2>&1; do
#     echo "Attendere che il server MySQL sia completamente operativo..."
#     sleep 2
# done

# # Creazione del database
# echo "Creazione del database $SQL_DATABASE..."
# mysql -u root -e "CREATE DATABASE IF NOT EXISTS \`$SQL_DATABASE\`;"

# # Creazione dell'utente
# echo "Creazione dell'utente $SQL_USER..."
# mysql -u root -e "CREATE USER IF NOT EXISTS \`$SQL_USER\`@'localhost' IDENTIFIED BY '$SQL_PASSWORD';"

# # Concessione dei permessi all'utente creato
# echo "Concessione dei permessi all'utente $SQL_USER sul database $SQL_DATABASE..."
# mysql -u root -e "GRANT ALL PRIVILEGES ON \`$SQL_DATABASE\`.* TO \`$SQL_USER\`@'%' IDENTIFIED BY '$SQL_PASSWORD';"

# # Modifica della password per l'utente root
# echo "Modifica della password per l'utente root..."
# mysql -u root -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '$SQL_ROOT_PASSWORD';"

# # Ricaricare i privilegi
# echo "Ricaricamento dei privilegi..."
# mysql -u root -e "FLUSH PRIVILEGES;"

# # Spegnimento del server
# echo "Spegnimento del server MySQL..."
# mysqladmin -u root -p"$SQL_ROOT_PASSWORD" shutdown

# # Avviare il server in modalità normale
# exec mysqld_safe

#!/bin/sh

if [ ! -d "/run/mysqld" ]; then
	mkdir -p /run/mysqld
	chown -R mysql:mysql /run/mysqld
fi

if [ ! -d "/var/lib/mysql/mysql" ]; then
	
	chown -R mysql:mysql /var/lib/mysql

	# init database
	mysql_install_db --basedir=/usr --datadir=/var/lib/mysql --user=mysql --rpm > /dev/null

	tfile=`mktemp`
	if [ ! -f "$tfile" ]; then
		return 1
	fi

	# https://stackoverflow.com/questions/10299148/mysql-error-1045-28000-access-denied-for-user-billlocalhost-using-passw
	cat << EOF > $tfile
USE mysql;
FLUSH PRIVILEGES;

DELETE FROM	mysql.user WHERE User='';
DROP DATABASE test;
DELETE FROM mysql.db WHERE Db='test';
DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');

ALTER USER 'root'@'localhost' IDENTIFIED BY '$SQL_ROOT_PASSWORD';

CREATE DATABASE $SQL_DATABASE CHARACTER SET utf8 COLLATE utf8_general_ci;
CREATE USER '$SQL_USER'@'%' IDENTIFIED by '$SQL_PASSWORD';
GRANT ALL PRIVILEGES ON $SQL_DATABASE.* TO '$SQL_USER'@'%';

FLUSH PRIVILEGES;
EOF
	# run init.sql
	/usr/bin/mysqld --user=mysql --bootstrap < $tfile
	rm -f $tfile
fi

# allow remote connections
sed -i "s|skip-networking|# skip-networking|g" /etc/my.cnf.d/mariadb-server.cnf
sed -i "s|.*bind-address\s*=.*|bind-address=0.0.0.0|g" /etc/my.cnf.d/mariadb-server.cnf

exec /usr/bin/mysqld --user=mysql --console