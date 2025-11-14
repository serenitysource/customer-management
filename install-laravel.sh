#!/bin/bash

echo "==================================="
echo "Customer Management Laravel Setup"
echo "==================================="

# Install Laravel
echo "Installing Laravel 11..."
composer create-project laravel/laravel temp-laravel "11.*"

# Move Laravel files to current directory
echo "Moving Laravel files..."
mv temp-laravel/* .
mv temp-laravel/.* . 2>/dev/null
rm -rf temp-laravel

echo "Laravel 11 installed successfully!"
