FROM debian:bullseye-slim

#-----------------------INSTALL NECESSARY PACKAGES
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    ca-certificates \
    php7.4-fpm \
    php-mysql \
    mariadb-client \
    && rm -rf /var/lib/apt/lists/*

#-----------------------COPY WP_CONF.SH
COPY ./wp_conf.sh /

RUN chmod +x wp_conf.sh

#-----------------------LAUNCH THE CONFIGURATION FILE
ENTRYPOINT ["./wp_conf.sh"]