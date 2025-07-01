FROM debian:bullseye-slim

#-----------------------INSTALL NGINX & OPENSSL
RUN apt-get update && apt-get install -y --no-install-recommends \
    nginx \
    openssl \
    && rm -rf /var/lib/apt/lists/*

#-----------------------GENERERATE AUTO-SIGNED CERTIFICATE   
RUN mkdir -p /etc/nginx/ssl \
    && openssl req -x509 -nodes \
    -out /etc/nginx/ssl/certificate.crt \
    -keyout /etc/nginx/ssl/private_key.key \
    -subj "/C=FR/ST=IleDeFrance/L=Paris/O=42/CN=$(WP_DOMAIN_NAME)"

#-----------------------COPY NGINX CONFIG
COPY ./nginx.conf /etc/nginx/nginx.conf

RUN mkdir -p /var/www/wordpress

RUN chown -R www-data:www-data /var/www/wordpress

#-----------------------LAUNCH NGINX AS PID 1
CMD ["nginx", "-g", "daemon off;"]