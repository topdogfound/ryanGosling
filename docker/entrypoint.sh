#!/bin/bash

# Wait for a dependent service (like a database) to be ready, if necessary
# until nc -z db 3306; do
#     echo "Waiting for database connection..."
#     sleep 2
# done

# Generate application key if not already set
if [ ! -f .env ]; then
    echo "Creating .env file..."
    cp .env.example .env
fi

# Check if APP_KEY is not set or is empty in .env, if so generate it
if ! grep -q '^APP_KEY=' .env || [ -z "$(grep 'APP_KEY=' .env | cut -d '=' -f2)" ]; then
    echo "Generating application key..."
    php artisan key:generate --no-interaction
else
    echo "Application key already set."
fi

# Set correct permissions for storage and bootstrap/cache directories
chown -R www-data:www-data /var/www/html/storage
chown -R www-data:www-data /var/www/html/bootstrap/cache
chmod -R 775 /var/www/html/storage
chmod -R 775 /var/www/html/bootstrap/cache

# Install PHP dependencies if vendor folder does not exist
if [ ! -d vendor ]; then
    echo "Installing PHP dependencies..."
    composer install --no-interaction --prefer-dist
fi

# Start the main application
exec "$@"
