FROM dunglas/frankenphp:php8.2.27-bookworm

ARG USER=appuser

# Copy all (exclude by .dockerignore) to /var/www/html
COPY . .

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

RUN apt-get update && apt-get install -y --no-install-recommends \
    # -- mbstring lib
    libonig-dev \
    # -- gd lib
    # libpng-dev \
    # libjpeg-dev \
    # zlib1g-dev \
    # -- intl lib
    libxml2-dev \
    # -- postgres lib
    libpq-dev \
    zip \
    unzip && \
    cp env .env && \
    # -- PHP Ext
    install-php-extensions intl mbstring pdo pdo_pgsql pgsql && \
    # -- Cleaning
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    # -- Project Setup
    composer install --no-dev --optimize-autoloader --no-scripts && \
    useradd ${USER}; \
    chown -R ${USER}:${USER} /data/caddy && chown -R ${USER}:${USER} /config/caddy

USER ${USER}
