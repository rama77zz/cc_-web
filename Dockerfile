# Gunakan image PHP dengan FPM dan Composer
FROM php:8.2-cli

# Install dependensi yang dibutuhkan Laravel
RUN apt-get update && apt-get install -y \
    git zip unzip curl libpng-dev libonig-dev libxml2-dev libzip-dev \
    && docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd zip

# Instal Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Set working directory
WORKDIR /var/www/html

# Copy semua file project Laravel
COPY . .

# Install dependency Laravel
RUN composer install --no-interaction --prefer-dist --optimize-autoloader

# Berikan permission untuk folder yang dibutuhkan
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache

# Expose port default Laravel
EXPOSE 8000

# Jalankan Laravel menggunakan artisan serve
CMD php artisan serve --host=0.0.0.0 --port=8000
