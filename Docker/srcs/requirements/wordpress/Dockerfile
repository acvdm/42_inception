FROM debian:bullseye

RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    php \
    php7.4-fpm \
    php-mysql \
    mariadb-client \
    && rm -rf /var/lib/apt/lists/*

COPY --chmod=0755 ./wp_conf.sh ./wp_conf.sh

ENTRYPOINT ["./wp_conf.sh"]