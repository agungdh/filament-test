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

# Create a crontab for www-data
RUN echo "* * * * * php /var/www/html/artisan schedule:run >> /var/log/cron.log 2>&1" > /var/spool/cron/crontabs/www-data \
    && chmod 600 /var/spool/cron/crontabs/www-data \
    && chown www-data:www-data /var/spool/cron/crontabs/www-data

# Ensure the cron service runs as www-data
CMD ["crond", "-f", "-l", "2", "-L", "/var/log/cron.log"]
