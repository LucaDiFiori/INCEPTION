FROM debian:bullseye

# Aggiorna la lista dei pacchetti, esegue l'upgrade e installa PHP-FPM
RUN apt-get update && apt-upgrade && apt-get install -y php-fpm

#  php-fpm8.2: Questo è il comando per avviare PHP-FPM versione 8.2.
# -F: Questo flag indica a PHP-FPM di eseguire in primo piano (foreground), 
#     mantenendo il processo attivo. Questo è utile in un contenitore Docker 
#     perché permette al processo di rimanere in esecuzione e di essere gestito 
#     dal sistema di orchestrazione dei contenitori (come Docker Compose).
CMD ["php-fpm8.2", "-F"]