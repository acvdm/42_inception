# syntax=docker/dockerfile:1.10

FROM debian:bullseye

#-----------------------INSTALL MARIADB
RUN apt-get update && apt-get install -y --no-install-recommends \
    mariadb-server \
    && rm -rf /var/lib/apt/lists/*

#-----------------------COPY MDB CONFIG
COPY chmod=+x ./mdb-conf.sh /mdb-conf.sh

#-----------------------LAUNCH THE CONFIGURATION FILE
ENTRYPOINT ["./mdb-conf.sh"]