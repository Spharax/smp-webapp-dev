FROM php:7.2-buster

RUN apt-get update && \
    apt-get install -y curl \
    acl \
    zsh \
    sudo \
    git \
    unzip \
    net-tools \
    wget \
    vim \
    zlib1g-dev \
    libicu-dev \
    g++ \
    libjpeg-dev \
    libpng-dev \
    libfreetype6-dev \
    libzip-dev \
    openssl

RUN ln -s /usr/local/bin/php /usr/local/bin/php7.2

RUN docker-php-ext-configure pdo_mysql \
    && docker-php-ext-install -j$(nproc) pdo_mysql \
    && docker-php-ext-configure intl \
    && docker-php-ext-install -j$(nproc) intl \
    && docker-php-ext-configure zip \
    && docker-php-ext-install -j$(nproc) zip \
    && docker-php-ext-configure exif \
    && docker-php-ext-install -j$(nproc) exif \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd \
    && docker-php-ext-install pcntl

RUN pecl install xdebug-2.7.2 \
    && docker-php-ext-enable xdebug
COPY config/xdebug.ini /xdebug.ini
RUN cat /xdebug.ini >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && rm /xdebug.ini

RUN wget -O composer.phar https://getcomposer.org/composer.phar \
    && mv composer.phar /usr/local/bin/composer \
    && chmod +x /usr/local/bin/composer

ENV COMPOSER_MEMORY_LIMIT=-1

COPY scripts /scripts

CMD ["/scripts/run.sh"]
