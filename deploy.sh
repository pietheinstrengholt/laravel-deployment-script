#!/bin/bash

cd /var/www/html

# Remove the old version
rm version

# Bring the website down
php artisan down

# Show current status
git status

# Clean the repository
git clean -f -d

# Do a hard reset to overwrite everyting
git reset --hard origin/master

# Pull latest changes
git pull

# Log the version number
git log --pretty="%h" -n1 HEAD > version

# Update all dependencies
composer install

# Perform database migration
php artisan migrate

# Clear routes and config
php artisan config:clear
php artisan view:clear
php artisan route:clear
php artisan cache:clear

# Cache routes

# Chmod storage directory
chmod -R 777 storage/

# Copy the htaccess to production
yes | cp -rf /var/www/htaccess-production /var/www/html/public/.htaccess

# Bring website online again
php artisan up
