FROM debian:bookworm-slim

RUN apt-get update && apt-get dist-upgrade -y

RUN apt-get -y install lsb-release ca-certificates curl apt-transport-https
RUN curl -sSLo /tmp/debsuryorg-archive-keyring.deb https://packages.sury.org/debsuryorg-archive-keyring.deb
RUN dpkg -i /tmp/debsuryorg-archive-keyring.deb
RUN sh -c 'echo "deb [signed-by=/usr/share/keyrings/deb.sury.org-php.gpg] https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list'
RUN apt-get update

RUN apt-get install -y sudo wget curl zip unzip 7zip nano net-tools supervisor nginx \
    php8.4-fpm \
    php8.4-mysql \
    php8.4-sqlite3 \
    php8.4-gd \
    php8.4-mbstring \
    php8.4-curl \
    php8.4-zip \
    php8.4-intl \
    php8.4-dom \
    php8.4-redis

RUN curl -fsSL https://deb.nodesource.com/setup_23.x -o nodesource_setup.sh
RUN bash nodesource_setup.sh
RUN apt-get install -y nodejs
RUN node -v

RUN apt-get clean && rm -rf /var/lib/apt/lists/*

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

WORKDIR /var/www/html

COPY . /var/www/html

COPY nginx.conf /etc/nginx/sites-available/default

COPY php.ini /etc/php/8.4/fpm/php.ini

RUN npm install

RUN npm run build

RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 storage \
    && chmod -R 755 bootstrap/cache

USER www-data

RUN composer install

RUN php artisan storage:link

RUN php artisan optimize

CMD ["sh", "docker-cmd-start.sh"]

EXPOSE 80
