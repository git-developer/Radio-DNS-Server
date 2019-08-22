FROM php:alpine

# PHP dependencies, create users, allow php (as non root) to open ports
RUN docker-php-ext-install sockets \ 
    && addgroup -S php && adduser -S php -G php \
    && mkdir -p /home/php/dns/ \
    && apk add --no-cache libcap \
    && setcap CAP_NET_BIND_SERVICE=+eip /usr/local/bin/php

# copy all files
WORKDIR /home/php/dns/
COPY --chown=php:php . /home/php/dns/

# set server vars
ENV SERVER_IP=0.0.0.0 \
    SERVER_PORT=53 \
    RADIO_DOMAIN=radio.example.com \
    ALLOWED_DOMAIN=home.example.com \
    TIME_SERVER=ntp0.fau.de

# open port
EXPOSE 53/udp

# run
CMD ["php","/home/php/dns/hamaserver.php"]
USER php