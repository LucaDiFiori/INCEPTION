FROM debian:bullseye

# Aggiorno ed installo i seguenti pacchetti:
# - php7.3
#   Questo è il linguaggio di programmazione PHP, versione 7.3. 
#   PHP è ampiamente utilizzato per lo sviluppo web e permette 
#   di creare siti dinamici. 
#
# - php-fpm
#   PHP-FPM (FastCGI Process Manager) è un gestore di processi per PHP. 
#   È progettato per gestire le richieste PHP in modo più efficiente 
#   rispetto al tradizionale modulo Apache o Nginx.
#
# - php-mysql
#   è un'estensione di PHP che consente a PHP di interagire con i 
#   database MySQL e MariaDB. Con questa estensione, puoi eseguire 
#   operazioni di database come creare, leggere, aggiornare ed 
#   eliminare dati (CRUD) all'interno delle tue applicazioni PHP.
#
#
# - mariadb-client
#   Questo pacchetto installa il client di MariaDB, che è  un'interfaccia a riga di comando per interagire con il server MariaDB
#   Il client consente di connettersi e interagire 
#   con i server di database MariaDB. 
#
# 
# NOTA:
# In questo Dockerfile per WordPress, installiamo `mariadb-client` invece di `mariadb-server` 
# perché WordPress si connette a un server MariaDB esistente, che è in un altro container
#, quindi non è necessario avere un server qui. 
# Il client consente a WordPress di interagire con il server MariaDB per eseguire 
# query sui dati e gestire le informazioni necessarie per il funzionamento dell'applicazione.

RUN apt-get update && apt-get upgrade -y && apt-get install -y \
    php7.4 \
    php-fpm \
    php-mysql \
    php-xml \
    php-curl \
    php-gd \
    php-mbstring \
    php-intl \
    mariadb-client \
    wget

    
#- Copia il file di configurazione di PHP-FPM
COPY tools/www.conf /etc/php/7.4/fpm/pool.d/www.conf

# aggiungo utente 
RUN groupadd nginx && useradd -M -s /sbin/nologin -g nginx nginx


# - Scarica l'archivio di WordPress dalla URL 
#   specificata e lo salva nella directory /var/www
#
# - Estrae il contenuto dell'archivio scaricato 
#   nella directory /var/www, creando una cartella 
#   chiamata wordpress
#
# - Rimuove l'archivio scaricato per liberare spazio
#
# - Cambia il proprietario della cartella wordpress
#   e dei suoi contenuti a root per garantire i 
#   permessi corretti
RUN wget https://wordpress.org/wordpress-6.0.tar.gz -P /var/www \
    && tar -xzf /var/www/wordpress-6.0.tar.gz -C /var/www \
    && rm /var/www/wordpress-6.0.tar.gz \
    && chown -R root:root /var/www/wordpress





# Ora scarichiamo lo strumento WP-CLI (WordPress Command Line Interface) per
# configurare e gestire il sito WordPress da riga di comando.
# Questo strumento semplifica questa operazione, incluso il settaggio del
# file di configurazione wp-config.php.
#
# nota:
#    La guida sottolinea che una CLI è un'interfaccia a riga di comando 
#    che permette di interagire con programmi tramite comandi testuali, come Bash 
#
# WordPress infatti necessita di dettagli del database (nome, utente, password e host) 
# per potersi connetter. Queste informazioni vengono solitamente 
# definite nel file wp-config.php. Se non configurate, quando accedi 
# al sito verrai reindirizzato alla pagina di configurazione guidata di WordPress
#
# Dopo aver scaricato wp-cli, lo rendiamo eseguibile e lo spostiamo nella directory /usr/local/bin
# per usarlo facilmmente con il comando wp (comando principale di wp-cli)
# senza dover specificare il percorso dove è installato
RUN wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp


# Copia lo script auto_config.sh nella directory /usr/local/bin
COPY tools/auto_config.sh /usr/local/bin/auto_config.sh

# Usare ENTRYPOINT garantisce che il comportamento desiderato (configurare WordPress 
# e avviare il server PHP) venga sempre eseguito ogni volta che il container viene avviato, 
# indipendentemente da eventuali comandi aggiuntivi forniti.
ENTRYPOINT ["/bin/bash", "/usr/local/bin/auto_config.sh"]
