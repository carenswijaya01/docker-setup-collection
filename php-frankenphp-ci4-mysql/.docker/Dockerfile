FROM composer:latest as vendor

# Set Workdir
WORKDIR /app

# Copy all (exclude by .dockerignore) to /var/www/html
COPY composer.json composer.json
COPY composer.lock composer.lock

RUN composer install \
    --ignore-platform-reqs \
    --no-interaction \
    --no-plugins \
    --no-scripts \
    --prefer-dist

FROM dunglas/frankenphp:php8.2.27-alpine as build

ARG USER=appuser

WORKDIR /app
COPY . /app
COPY --from=vendor /app/vendor/ /app/vendor/
COPY --from=vendor /usr/bin/composer /usr/bin/composer

RUN install-php-extensions intl mbstring pdo pdo_mysql mysqli && \
    adduser -D -s /bin/sh ${USER} && \
    chown -R ${USER}:${USER} /data/caddy && chown -R ${USER}:${USER} /config/caddy && \
    chown -R ${USER}:${USER} /app && \
    find /app -type d -exec chmod 755 {} \; && \
    find /app -type f -exec chmod 644 {} \;

USER ${USER}
