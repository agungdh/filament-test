FROM php:8.4-fpm-alpine

RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"

RUN apk update \
    && apk add --no-cache nano bash curl git unzip openssh icu-dev libzip-dev curl-dev \
    && docker-php-ext-configure intl \
    && docker-php-ext-install intl zip curl \
    && pecl install redis \
    && docker-php-ext-enable redis

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

COPY . .

RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 storage \
    && chmod -R 755 bootstrap/cache

USER www-data

RUN composer install
