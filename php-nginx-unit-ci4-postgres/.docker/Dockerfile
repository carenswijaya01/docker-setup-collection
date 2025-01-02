FROM unit:1.31.1-php8.2

WORKDIR /app

COPY . /app
COPY config.json /docker-entrypoint.d/config.json
COPY start.sh /start.sh

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
    # -- PHP Ext
    docker-php-ext-install intl mbstring pdo pdo_pgsql pgsql && \
    docker-php-ext-configure pgsql -with-pgsql=/usr/local/pgsql && \
    # docker-php-ext-configure gd && \
    # docker-php-ext-install -j$(nproc) gd && \
    # -- Cleaning
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    # -- Project Setup
    composer install --no-dev --optimize-autoloader --no-scripts && \
    chmod 544 /start.sh && \
    chown -R unit:unit /app && \
    find /app -type d -exec chmod 755 {} \; && \
    find /app -type f -exec chmod 644 {} \;

# port used by the listener in config.json
EXPOSE 80
