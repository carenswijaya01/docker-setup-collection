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
    # -- Oracle Installation
    alien -i --scripts ./oracle-instantclient11.2-basic-11.2.0.4.0-1.x86_64.rpm && \
    alien -i --scripts ./oracle-instantclient11.2-devel-11.2.0.4.0-1.x86_64.rpm && \
    echo /usr/lib/oracle/11.2/client64/lib > /etc/ld.so.conf.d/oracle.conf && \
    ldconfig && \
    # -- PHP Ext
    docker-php-ext-install intl pdo mbstring && \
    docker-php-ext-configure oci8 --with-oci8=instantclient,/usr/lib/oracle/11.2/client64/lib && \
    docker-php-ext-install oci8 && \
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
