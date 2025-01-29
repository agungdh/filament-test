FROM php:8.4-fpm-alpine

# Set environment variables
ENV APP_DIR=/var/www/html

# Install necessary dependencies and PHP extensions
RUN apk update \
    && apk add --no-cache nano bash curl git unzip openssh icu-dev libzip-dev curl-dev pcre-dev $PHPIZE_DEPS \
    && docker-php-ext-configure intl \
    && docker-php-ext-install intl zip curl pdo pdo_mysql mysqli \
    && pecl install redis \
    && docker-php-ext-enable redis \
    && apk del $PHPIZE_DEPS

WORKDIR $APP_DIR

# Start PHP-FPM
CMD ["php", "artisan", "queue:work", "-v"]
