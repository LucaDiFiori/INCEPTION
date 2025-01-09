#!/bin/sh

# Avvia il server MySQL in background
mysqld_safe &

# Attendere che il server MySQL sia completamente operativo
until mysql -u root -e "SELECT 1" > /dev/null 2>&1; do
    echo "Attendere che il server MySQL sia completamente operativo..."
    sleep 2
done

# Con questo comando, il client MySQL si connette al server MySQL e cerca di creare 
# un database con il nome specificato nella variabile d'ambiente SQL_DATABASE.
echo "Creazione del database $SQL_DATABASE..."
mysql -u root -e "CREATE DATABASE IF NOT EXISTS \`$SQL_DATABASE\`;"

# Questo comando crea un utente MySQL con:
# - Un nome specificato dalla variabile d'ambiente SQL_USER.
# - Una password specificata dalla variabile d'ambiente SQL_PASSWORD.
# - Permessi di accesso limitati a localhost (`@'localhost')
echo "Creazione dell'utente $SQL_USER..."
mysql -u root -e "CREATE USER IF NOT EXISTS \`$SQL_USER\`@'localhost' IDENTIFIED BY '$SQL_PASSWORD';"

# Concedo tutti i permessi all'utente creato
echo "Concessione dei permessi all'utente $SQL_USER sul database $SQL_DATABASE..."
mysql -u root -e "GRANT ALL PRIVILEGES ON \`$SQL_DATABASE\`.* TO \`$SQL_USER\`@'%' IDENTIFIED BY '$SQL_PASSWORD';"

# Questo comando modifica la password dell'utente root per connessioni locali su MySQL
echo "Modifica della password per l'utente root..."
mysql -u root -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '$SQL_ROOT_PASSWORD';"

# Ricaricare i privilegi
echo "Ricaricamento dei privilegi..."
mysql -u root -e "FLUSH PRIVILEGES;"

# Spegnimento del server
echo "Spegnimento del server MySQL..."
mysqladmin -u root -p"$SQL_ROOT_PASSWORD" shutdown

# Avviare il server in modalità normale
exec mysqld_safe
