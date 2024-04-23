FROM wordpress:php8.3-apache as wp

RUN a2enmod rewrite

# Installation des dépendances
RUN apt-get update && apt-get install -y default-mysql-client git libzip-dev zip unzip libmagickwand-dev
RUN docker-php-ext-install mysqli
RUN docker-php-ext-enable mysqli
RUN docker-php-ext-install pdo_mysql

RUN pecl install xdebug \
    && docker-php-ext-enable xdebug

# Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer && \
apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
# Composer cherche à stocker son dossier de cache .composer/ à la racine
RUN chown -R www-data: /var/www/

# Copie des fichiers de config
COPY docker/certs/ /usr/local/share/ca-certificates/
COPY docker/app.conf /etc/apache2/sites-available/000-default.conf
COPY docker/custom.ini /usr/local/etc/php/conf.d/custom.ini
COPY docker/local/php/entrypoint.sh /usr/bin/entrypoint.sh

#Cleaning
RUN apt-get autoclean && apt-get autoremove && rm -rf /var/lib/apt/lists/*

ARG UID=1000
RUN usermod -u ${UID} www-data
RUN chmod +x /usr/bin/entrypoint.sh

CMD ["/usr/bin/entrypoint.sh"]