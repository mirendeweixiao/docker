ARG PHP_VERSION
FROM php:${PHP_VERSION}-fpm

# Set the working directory
WORKDIR /var/www/html/

# Install dependencies and PHP extensions
RUN apt-get update && apt-get install -y --no-install-recommends \
    wget \
    git \
    npm \
    openssh-client \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libpng-dev \
    libwebp-dev \
    libxml2-dev \
    libmemcached-dev \
    unzip \
    zip \
    libzip-dev \
    zlib1g-dev \
    libxslt-dev \
    libsodium-dev \
    && npm install -g yarn \
    && docker-php-ext-configure gd --with-freetype --with-jpeg --with-webp \
    && docker-php-ext-configure intl \
    && docker-php-ext-configure opcache --enable-opcache \
    && docker-php-ext-install -j$(nproc) gd intl exif bcmath pdo_mysql zip xsl opcache mysqli soap sodium sockets \
    && pecl install redis memcached xdebug \
    && docker-php-ext-enable redis memcached exif \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/*

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Setup MailHog sendmail binary
RUN mkdir -p /var/run/php
# Mailhog
COPY mhsendmail_linux_amd64 /usr/local/bin/mhsendmail
RUN chmod +x /usr/local/bin/mhsendmail

# Adjust www-data user permissions
RUN usermod -u 1000 www-data && groupmod -g 1000 www-data
