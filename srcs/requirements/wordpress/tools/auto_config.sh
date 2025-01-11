#!/bin/bash

# Di default, quando lanci WordPress per la prima volta, 
# viene mostrata una pagina iniziale per configurare il 
# database e il primo utente.
# automatizziamo questo processo tramite uno script Bash chiamato 
# auto_config.sh, evitando di configurare manualmente ogni volta.

# #Vecchio check
# # Funzione per controllare se MariaDB è attivo
# check_mariadb() {
#     nc -z mariadb 3306
# }

# # wait for mysql
# while ! mariadb -h$SQL_HOST -u$SQL_USER -p$SQL_PASSWORD $SQL_DATABASE_NAME &>/dev/null; do
#     echo "from Wordpress: i'm waiting mariadb"
#     echo "DA TOGLIERE!: DB_NAME: $SQL_DATABASE_NAME, DB_USER: $SQL_USER, DB_PASS: $SQL_PASSWORD, DB_HOST: $SQL_HOST"

#     sleep 3
# done

# Nuovo check:
# Funzione per controllare MariaDB con netcat
check_mariadb() {
    nc -z $SQL_HOST 3306
}

# Ciclo per attendere che MariaDB sia pronto
while ! mysql -h"$SQL_HOST" -u"$SQL_USER" -p"$SQL_PASSWORD" -e "SELECT 1;" &>/dev/null; do
    echo "from Wordpress: I'm waiting for MariaDB"
    echo "DA TOGLIERE!: DB_NAME: $SQL_DATABASE_NAME, DB_USER: $SQL_USER, DB_PASS: $SQL_PASSWORD, DB_HOST: $SQL_HOST"
    sleep 3
done
echo "Mariadb è pronto"





# Lo script controlla se il file wp-config.php esiste già.
# Se non esiste, utilizza il comando della CLI di WordPress wp config create 
# per configurare automaticamente le informazioni del database 
# (nome, utente, password, host).
# I valori come $SQL_DATABASE_NAME, $SQL_USER, ecc. devono essere impostati come variabili 
# d'ambiente nel file .env.



if [ ! -f /var/www/wordpress/wp-config.php ]; then

    wp config create --allow-root \
        --dbname=$SQL_DATABASE_NAME \
        --dbuser=$SQL_USER \
        --dbpass=$SQL_PASSWORD \
        --dbhost=$SQL_HOST \
        --path='/var/www/wordpress' || { 
        echo "Errore durante la creazione di wp-config.php"; 
        exit 1; 
    }

    # Configura WordPress automaticamente con i dati forniti.
    wp core install --allow-root \
        --url="https://$WP_DOMAIN_NAME" \
        --title=$WP_SITE_TITLE \
        --admin_user=$WP_ADMIN_USER \
        --admin_password=$WP_ADMIN_PASSWORD \
        --admin_email=$WP_ADMIN_EMAIL \
        --path='/var/www/wordpress'  || {
        echo "Errore durante l'installazione di WordPress";
        exit 1;
        }

    # Crea un nuovo utente WordPress con le credenziali specificate.
    wp user create --allow-root \
        $WP_SECOND_USER $WP_SECOND_EMAIL \
        --role=editor \
        --user_pass=$WP_SECOND_PASSWORD \
        --path='/var/www/wordpress' || {
        echo "Errore durante la creazione dell'utente aggiuntivo";
        exit 1;
    }
fi

mkdir -p /run/php  # Crea la directory necessaria per PHP se non esiste
/usr/sbin/php-fpm7.4 -F  # Avvia il server PHP
