FROM debian:bullseye

#-----------------------INSTALL MARIADB
RUN apt-get update && apt-get install -y --no-install-recommends \
    mariadb-server \
    netcat \
    && rm -rf /var/lib/apt/lists/*

#-----------------------COPY MDB CONFIG
COPY --chmod=0755 ./mdb-conf.sh /mdb-conf.sh

#-----------------------LAUNCH THE CONFIGURATION FILE
ENTRYPOINT ["./mdb-conf.sh"]