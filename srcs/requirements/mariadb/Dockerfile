FROM debian:bullseye

#-----------------------INSTALL MARIADB
RUN apt-get update && apt-get install -y \
    mariadb-server \
    netcat \
    && rm -rf /var/lib/apt/lists/*

#-----------------------COPY MDB CONFIG
COPY --chmod=+x ./mdb-conf.sh /mdb-conf.sh

#-----------------------LAUNCH THE CONFIGURATION FILE
ENTRYPOINT ["./mdb-conf.sh"]