#!/bin/bash

# Di default, quando lanci WordPress per la prima volta, 
# viene mostrata una pagina iniziale per configurare il 
# database e il primo utente.
# automatizziamo questo processo tramite uno script Bash chiamato 
# auto_config.sh, evitando di configurare manualmente ogni volta.



# Con lo script che utilizza i comandi della WordPress CLI (wp), stai automatizzando la configurazione iniziale di WordPress. 
# Questo script configura due aspetti principali:

# 1. Configurazione del file wp-config.php
# Il file wp-config.php è il cuore della configurazione di WordPress e contiene 
# le informazioni necessarie per connettersi al database.
# Con:
# $SQL_DATABASE: Nome del database MySQL/MariaDB per WordPress.
# $SQL_USER: Utente che ha accesso al database.
# $SQL_PASSWORD: Password dell'utente del database.
# dbhost: Host e porta del server MariaDB (nel tuo caso, mariadb:3306).

# 2. Configurazione del sito WordPress
# Dopo aver creato il file wp-config.php, lo script utilizza comandi della CLI per configurare WordPress 
# senza richiedere interazione manuale (ad esempio, nome del sito, nome utente, password, email, ecc.).

# 3. Creazione di utenti aggiuntivi
# Possiamo aggiungere ulteriori utenti con il comando wp user create.




# Lo script controlla se il file wp-config.php esiste già.
# Se non esiste, utilizza il comando della CLI di WordPress wp config create 
# per configurare automaticamente le informazioni del database 
# (nome, utente, password, host).
# I valori come $SQL_DATABASE, $SQL_USER, ecc. devono essere impostati come variabili 
# d'ambiente nnel file .env.
#
# NOTA: Controllo che non esista già perchè wp-config.php è il file di configurazione di WordPress,
#       generato da questo script, che contiene le informazioni di accesso al database.
#       Se esiste già (ad esempio se ho già avviato il container in precedenza), non serve riconfigurare il database.

if [ ! -f /var/www/wordpress/wp-config.php ]; then
    wp config create --allow-root \
        --dbname=$SQL_DATABASE \
        --dbuser=$SQL_USER \
        --dbpass=$SQL_PASSWORD \
        --dbhost=mariadb:3306 \
        --path='/var/www/wordpress'


# Configura WordPress automaticamente con i dati forniti.
# Il comando wp core install è utilizzato per eseguire il setup iniziale di WordPress,
# creando un sito e configurando l'utente amministratore principale.
    wp core install --allow-root \
        --url=$WP_DOMAIN_NAME \
        --title=$WP_SITE_TITLE \
        --admin_user=$WP_ADMIN_USER \
        --admin_password=$WP_ADMIN_PASSWORD \
        --admin_email=$WP_ADMIN_EMAIL \
        --path='/var/www/wordpress' # Indica il percorso in cui si trova l'installazione di WordPress.
                                    # Garantisce che il comando venga eseguito sulla directory corretta.


# Creates a new WordPress user with the specified role and credentials.
# - --allow-root: Allows execution of the command as the root user.
# - $WP_SECOND_USER: Username for the new user.
# - $WP_SECOND_EMAIL: Email address associated with the new user.
# - --role=editor: Assigns the "editor" role to the new user.
# - --user_pass=$SECOND_PASSWORD: Sets the password for the new user.
# - --path='/var/www/wordpress': Specifies the WordPress installation path.
    wp user create --allow-root \
        $WP_SECOND_USER $WP_SECOND_EMAIL \
        --role=editor \
        --user_pass=$SECOND_PASSWORD \
        --path='/var/www/wordpress'
fi

mkdir -p /run/php  # Crea la directory necessaria per PHP se non esiste
/usr/sbin/php-fpm7.4 -F  # Avvia il server PHP