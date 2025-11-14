FROM php:8.2-fpm

# Set working directory
WORKDIR /var/www

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    unzip \
    nodejs \
    npm

# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Install PHP extensions
RUN docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd

# Get latest Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Copy existing application directory contents
COPY . /var/www

# Copy existing application directory permissions
COPY --chown=www-data:www-data . /var/www

# Create entrypoint script
RUN echo '#!/bin/sh\n\
chown -R www-data:www-data /var/www/storage /var/www/bootstrap/cache 2>/dev/null || true\n\
chmod -R 775 /var/www/storage /var/www/bootstrap/cache 2>/dev/null || true\n\
if [ -f /var/www/vendor/autoload.php ]; then\n\
  su -s /bin/sh www-data -c "php artisan serve --host=0.0.0.0 --port=8000"\n\
else\n\
  echo "Waiting for composer install to complete..."\n\
  while [ ! -f /var/www/vendor/autoload.php ]; do\n\
    sleep 2\n\
  done\n\
  su -s /bin/sh www-data -c "php artisan serve --host=0.0.0.0 --port=8000"\n\
fi\n\
' > /usr/local/bin/docker-entrypoint.sh && chmod +x /usr/local/bin/docker-entrypoint.sh

# Expose port 8000 and start php-fpm server
EXPOSE 8000
CMD ["/usr/local/bin/docker-entrypoint.sh"]
