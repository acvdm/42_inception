FROM debian:bullseye

RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    ca-certificates \
    php \
    php7.4-fpm \
    php-mysql \
    mariadb-client \
    && rm -rf /var/lib/apt/lists/*

COPY ./wp_conf.sh /

RUN chmod +x wp_conf.sh

EXPOSE 9000

ENTRYPOINT ["./wp_conf.sh"]