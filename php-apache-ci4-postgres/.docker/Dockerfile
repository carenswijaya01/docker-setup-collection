FROM php:8.0-apache

# Set Workdir
WORKDIR /var/www/html

# Copy all (exclude by .dockerignore) to /var/www/html
COPY . .

# Configure Apache
COPY .docker/vhost.conf /etc/apache2/sites-available/000-default.conf

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
    # -- Apache Setup
    a2enmod rewrite && \
    # -- Project Setup
    composer install --no-dev --optimize-autoloader --no-scripts && \
    chown -R www-data:www-data /var/www/html && \
    find /var/www/html -type d -exec chmod 755 {} \; && \
    find /var/www/html -type f -exec chmod 644 {} \;

# Final
USER www-data
