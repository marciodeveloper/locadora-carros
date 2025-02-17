FROM php:8.1-apache

# Instala pacotes necessários
RUN apt-get update && apt-get install -y \
    libicu-dev libzip-dev zip unzip git \
    && docker-php-ext-install pdo_mysql intl zip

# Habilita mod_rewrite
RUN a2enmod rewrite

# Ajusta o DocumentRoot para /var/www/html/public
RUN sed -ri -e 's!/var/www/html!/var/www/html/public!g' /etc/apache2/sites-available/000-default.conf

# Permite que .htaccess (Laravel) funcione (AllowOverride All)
RUN echo '<Directory /var/www/html>\n\
    Options Indexes FollowSymLinks\n\
    AllowOverride All\n\
    Require all granted\n\
</Directory>' > /etc/apache2/conf-available/allowoverride.conf \
    && a2enconf allowoverride

# Copia o Composer de uma imagem oficial para dentro
COPY --from=composer:latest /usr/bin/composer /usr/local/bin/composer

WORKDIR /var/www/html

EXPOSE 80
CMD ["apache2-foreground"]
