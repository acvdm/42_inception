# syntax=docker/dockerfile:1.10

FROM debian:bullseye

RUN apt-get update && apt-get install -y --no-requirements-recommends \
    curl \
    php \
    php7.4-fpm \
    php-mysql \
    mariadb-client
    && rm -rf /var/lib/apt/lists/*

COPY chmod=+x ./wp_conf.sh ./wp_conf.sh

ENTRYPOINT ["./wp_conf.sh"]