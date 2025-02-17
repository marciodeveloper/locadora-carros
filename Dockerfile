# Usando imagem oficial do PHP 8.x com Apache
FROM php:8.1-apache

# Atualiza e instala extensões necessárias
RUN apt-get update && apt-get install -y \
    libicu-dev \
    libzip-dev \
    zip \
    unzip \
    git \
    && docker-php-ext-install \
    pdo_mysql \
    intl \
    zip

# Habilita o mod_rewrite do Apache para permitir URLs amigáveis do Laravel
RUN a2enmod rewrite

# Instala o Composer a partir da imagem oficial do Composer
COPY --from=composer:latest /usr/bin/composer /usr/local/bin/composer

# Define a pasta de trabalho dentro do container
WORKDIR /var/www/html

# Copia o conteúdo do projeto para dentro do container (opcional se não for usar volume)
# COPY . /var/www/html

# Exemplo de comando para rodar na inicialização (opcional):
# RUN composer install && php artisan key:generate

# Expõe a porta 80
EXPOSE 80
