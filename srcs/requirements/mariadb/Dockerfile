FROM debian:bullseye

RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y --no-install-recommends \
    mariadb-server && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

COPY ./tools/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf

# Copia dello script e mi assicuro che sia eseguibile modificando i permessi
COPY ./tools/script.sh /usr/local/bin/script.sh
RUN chmod +x /usr/local/bin/script.sh

HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
    CMD mysqladmin ping -u root -p"$SQL_ROOT_PASSWORD" || exit 1

CMD ["/usr/local/bin/script.sh"]
