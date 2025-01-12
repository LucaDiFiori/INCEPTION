#!/bin/bash

# Attendi che MariaDB sia pronto
while ! mysql -h"$SQL_HOST" -u"$SQL_USER" -p"$SQL_PASSWORD" -e "SELECT 1;" &>/dev/null; do
    echo "Attendo MariaDB..."
    sleep 3
done

echo "Mariadb è pronto"

# Crea wp-config.php manualmente se non esiste
if [ ! -f /var/www/wordpress/wp-config.php ]; then
    cat > /var/www/wordpress/wp-config.php << EOF
<?php
define( 'DB_NAME', '${SQL_DATABASE_NAME}' );
define( 'DB_USER', '${SQL_USER}' );
define( 'DB_PASSWORD', '${SQL_PASSWORD}' );
define( 'DB_HOST', '${SQL_HOST}' );
define( 'DB_CHARSET', 'utf8' );
define( 'DB_COLLATE', '' );

$(wget -qO- https://api.wordpress.org/secret-key/1.1/salt/)

\$table_prefix = 'wp_';

define( 'WP_DEBUG', false );

if ( ! defined( 'ABSPATH' ) ) {
        define( 'ABSPATH', __DIR__ . '/' );
}

require_once ABSPATH . 'wp-settings.php';
EOF

    chown nginx:nginx /var/www/wordpress/wp-config.php
    chmod 644 /var/www/wordpress/wp-config.php

    # Configura WordPress
    wp core install --allow-root \
        --url="https://$WP_DOMAIN_NAME" \
        --title="$WP_SITE_TITLE" \
        --admin_user="$WP_ADMIN_USER" \
        --admin_password="$WP_ADMIN_PASSWORD" \
        --admin_email="$WP_ADMIN_EMAIL" \
        --path='/var/www/wordpress'

    # Crea utente aggiuntivo
    wp user create --allow-root \
        "$WP_SECOND_USER" "$WP_SECOND_EMAIL" \
        --role=editor \
        --user_pass="$WP_SECOND_PASSWORD" \
        --path='/var/www/wordpress'
fi

# Avvia PHP-FPM
mkdir -p /run/php
exec /usr/sbin/php-fpm7.4 -F