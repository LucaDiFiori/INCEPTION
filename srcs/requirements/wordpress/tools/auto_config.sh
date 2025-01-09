#!/bin/bash

# Di default, quando lanci WordPress per la prima volta, 
# viene mostrata una pagina iniziale per configurare il 
# database e il primo utente.
# automatizziamo questo processo tramite uno script Bash chiamato 
# auto_config.sh, evitando di configurare manualmente ogni volta.

# Funzione per controllare se MariaDB è attivo
check_mariadb() {
    nc -z mariadb 3306
}

# Aspetta che MariaDB sia attivo
# while ! check_mariadb; do
#     echo "Aspettando che MariaDB sia attivo..."
#     sleep 5
# done

#!/bin/sh

# wait for mysql
while ! mariadb -h$SQL_HOSTNAME -u$SQL_USER -p$SQL_PASSWORD $SQL_DATABASE &>/dev/null; do
    sleep 3
done


# Lo script controlla se il file wp-config.php esiste già.
# Se non esiste, utilizza il comando della CLI di WordPress wp config create 
# per configurare automaticamente le informazioni del database 
# (nome, utente, password, host).
# I valori come $SQL_DATABASE, $SQL_USER, ecc. devono essere impostati come variabili 
# d'ambiente nel file .env.

if [ ! -f /var/www/wordpress/wp-config.php ]; then
    wp config create --allow-root \
        --dbname=$SQL_DATABASE \
        --dbuser=$SQL_USER \
        --dbpass=$SQL_PASSWORD \
        --dbhost=mariadb:3306 \
        --path='/var/www/wordpress'

    # Configura WordPress automaticamente con i dati forniti.
    wp core install --allow-root \
        --url=$WP_DOMAIN_NAME \
        --title=$WP_SITE_TITLE \
        --admin_user=$WP_ADMIN_USER \
        --admin_password=$WP_ADMIN_PASSWORD \
        --admin_email=$WP_ADMIN_EMAIL \
        --path='/var/www/wordpress' 

    # Crea un nuovo utente WordPress con le credenziali specificate.
    wp user create --allow-root \
        $WP_SECOND_USER $WP_SECOND_EMAIL \
        --role=editor \
        --user_pass=$WP_SECOND_PASSWORD \
        --path='/var/www/wordpress'
fi

mkdir -p /run/php  # Crea la directory necessaria per PHP se non esiste
/usr/sbin/php-fpm7.4 -F  # Avvia il server PHP
