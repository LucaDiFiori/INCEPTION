#!/bin/sh

# Con questo script andremo a creare il nostro database e l'utente per accedervi

# Avviamo il servizio mysql
#service mysql start;
mysqld_safe &

# # Attendere fino a quando il server MySQL è attivo
# until mysqladmin ping --silent; do
#     echo "Attendere che il server MySQL si avvii..."
#     sleep 2
# done

# Con questo comando, il client MySQL si connette al server MySQL e cerca di creare 
# un database con il nome specificato nella variabile d'ambiente SQL_DATABASE.
mysql -e "CREATE DATABASE IF NOT EXISTS \`$SQL_DATABASE\`;"


# Questo comando crea un utente MySQL con:
# - Un nome specificato dalla variabile d'ambiente SQL_USER.
# - Una password specificata dalla variabile d'ambiente SQL_PASSWORD.
# - Permessi di accesso limitati a localhost (`@'localhost')
mysql -e "CREATE USER IF NOT EXISTS \`$SQL_USER\`@'localhost' IDENTIFIED BY '$SQL_PASSWORD';"


# Concedo tutti i permessi all'utente creato
mysql -e "GRANT ALL PRIVILEGES ON \`$SQL_DATABASE\`.* TO \`$SQL_USER\`@'%' IDENTIFIED BY '$SQL_PASSWORD';"


# Questo comando modifica la password dell'utente root per connessioni locali su MySQL, impostandola al 
# valore specificato nella variabile d'ambiente SQL_ROOT_PASSWORD
mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '$SQL_ROOT_PASSWORD';"

# Questo comando Forza il server MySQL a ricaricare le tabelle dei privilegi 
# Questo è necessario quando si effettuano modifiche alla configurazione dei privilegi 
# (ad esempio, creando utenti o assegnando permessi)
mysql -e "FLUSH PRIVILEGES;"

# riavviamo MySql
mysqladmin -u root -p$SQL_ROOT_PASSWORD shutdown

# Questo comando avvia il server MySQL/MariaDB all'interno dell'ambiente controllato fornito da mysqld_safe.
# mysqld_safe è uno script di avvio fornito con MySQL/MariaDB che avvia il server MySQL (mysqld) in modo sicuro.
exec mysqld_safe