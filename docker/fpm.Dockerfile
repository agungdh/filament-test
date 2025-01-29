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

# Install Composer globally
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

WORKDIR $APP_DIR

# Copy application files
RUN rm -rf $APP_DIR
COPY .. .

# Set ownership and permissions
RUN chown -R www-data:www-data $APP_DIR \
    && chmod -R 755 $APP_DIR/storage \
    && chmod -R 755 $APP_DIR/bootstrap/cache

# Install Composer dependencies
USER www-data
RUN composer install \
    && rm -rf ~/.composer/cache

# Expose the default PHP-FPM port
EXPOSE 9000

# Start PHP-FPM
CMD ["php-fpm"]
