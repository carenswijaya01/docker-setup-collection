FROM php:8.0-apache

# Set Workdir
WORKDIR /var/www/html

# Copy all (exclude by .dockerignore) to /var/www/html
COPY . .

# Configure Apache
COPY .docker/vhost.conf /etc/apache2/sites-available/000-default.conf

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Set environment variables for Oracle Instant Client
ENV LD_LIBRARY_PATH=/usr/lib/oracle/11.2/client64/lib/
ENV ORACLE_HOME=/usr/lib/oracle/11.2/client64

RUN apt-get update && apt-get install -y --no-install-recommends \
    # -- mbstring lib
    libonig-dev \ 
    # -- gd lib
    # libpng-dev \
    # libjpeg-dev \
    # zlib1g-dev \
    # -- intl lib
    libxml2-dev \
    # -- alien preparation
    libaio1 \
    libaio-dev \
    alien \
    gnupg2 \
    wget \
    ca-certificates \
    lsb-release \
    zip \
    unzip && \
    cp env .env && \
    # -- Oracle Installation
    alien -i --scripts ./oracle-instantclient11.2-basic-11.2.0.4.0-1.x86_64.rpm && \
    alien -i --scripts ./oracle-instantclient11.2-devel-11.2.0.4.0-1.x86_64.rpm && \
    echo /usr/lib/oracle/11.2/client64/lib > /etc/ld.so.conf.d/oracle.conf && \
    ldconfig && \
    # -- PHP Ext
    docker-php-ext-install intl pdo mbstring && \
    docker-php-ext-configure oci8 --with-oci8=instantclient,/usr/lib/oracle/11.2/client64/lib && \
    docker-php-ext-install oci8 && \
    # docker-php-ext-configure gd && \
    # docker-php-ext-install -j$(nproc) gd && \
    # -- Cleaning
    apt-get clean && rm ./oracle-* && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    # -- Apache Setup
    a2enmod rewrite && \
    # -- Project Setup
    composer install --no-dev --optimize-autoloader --no-scripts && \
    chown -R www-data:www-data /var/www/html && \
    find /var/www/html -type d -exec chmod 755 {} \; && \
    find /var/www/html -type f -exec chmod 644 {} \;

# Final
USER www-data