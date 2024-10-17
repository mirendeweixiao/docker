#!/bin/bash

# Function to add a new PHP version to docker-compose.yml
add_php_service() {
  PHP_VERSION=$1

  echo "Adding PHP-FPM service for PHP $PHP_VERSION to docker-compose.yml..."

  # Check if PHP version service already exists
  if grep -q "php-fpm$PHP_VERSION:" docker-compose.yml; then
    echo "PHP $PHP_VERSION is already added to docker-compose.yml."
    return
  fi

  # Find the line where the services block starts
  LINE_NUMBER=$(grep -n "services:" docker-compose.yml | cut -d ":" -f 1)

  # Insert the new PHP service right after the services block
  if [ -n "$LINE_NUMBER" ]; then
    sed -i "${LINE_NUMBER}a \ \ php-fpm$PHP_VERSION:\n    build:\n      context: ./php-fpm$PHP_VERSION\n      args:\n        PHP_VERSION: $PHP_VERSION\n    container_name: php-fpm$PHP_VERSION\n    volumes:\n      - \${WEB_ROOT}:/var/www/html/\n      - \./php-fpm$PHP_VERSION/conf:/usr/local/etc\n    restart: always\n    networks:\n      - backend\n    depends_on:\n      - mysql\n      - nginx\n    deploy:\n      resources:\n        limits:\n          cpus: \"1.00\"\n          memory: 1G\n" docker-compose.yml
    echo "PHP $PHP_VERSION service added to the services block successfully!"
  else
    echo "Failed to find the services block in docker-compose.yml."
  fi
}

# Function to remove a PHP version from docker-compose.yml
remove_php_service() {
  PHP_VERSION=$1

  echo "Removing PHP-FPM service for PHP $PHP_VERSION from docker-compose.yml..."

  # Check if PHP version service exists
  if ! grep -q "php-fpm$PHP_VERSION:" docker-compose.yml; then
    echo "PHP $PHP_VERSION is not found in docker-compose.yml."
    return
  fi

  # Remove the service from docker-compose.yml
  sed -i "/php-fpm$PHP_VERSION:/,/memory: 1G/d" docker-compose.yml

  # Remove empty lines
  sed -i '/^$/d' docker-compose.yml

  echo "PHP $PHP_VERSION service removed successfully!"
}

# Function to copy php-fpm directory for the new PHP version
copy_php_fpm_directory() {
  PHP_VERSION=$1

  echo "Copying php-fpm directory for PHP $PHP_VERSION..."

  # Check if php-fpm directory already exists
  if [ -d "php-fpm$PHP_VERSION" ]; then
    echo "php-fpm directory for PHP $PHP_VERSION already exists."
    return
  fi

  # Copy the original php-fpm directory and customize for the new PHP version
  cp -r php-fpm "php-fpm$PHP_VERSION"
  sed -i "s/PHP_VERSION=[0-9]\+\.[0-9]\+/PHP_VERSION=$PHP_VERSION/g" php-fpm$PHP_VERSION/Dockerfile

  echo "php-fpm directory for PHP $PHP_VERSION copied and customized successfully!"
}

# Function to remove php-fpm directory for a PHP version
remove_php_fpm_directory() {
  PHP_VERSION=$1

  echo "Removing php-fpm directory for PHP $PHP_VERSION..."

  # Check if php-fpm directory exists
  if [ -d "php-fpm$PHP_VERSION" ]; then
    rm -rf "php-fpm$PHP_VERSION"
    echo "php-fpm directory for PHP $PHP_VERSION removed successfully!"
  else
    echo "php-fpm directory for PHP $PHP_VERSION does not exist."
  fi
}

# Function to validate PHP version input
validate_php_version() {
  PHP_VERSION=$1
  if ! [[ "$PHP_VERSION" =~ ^[0-9]+\.[0-9]+$ ]]; then
    echo "Invalid PHP version format. Please use X.Y format (e.g., 7.4 or 8.1)."
    exit 1
  fi
}

# Main script
echo "Manage PHP versions in the Docker LNMP environment."
echo "Options: A (Add), R (Remove)"
read -p "Enter your choice: " ACTION
read -p "Enter the PHP version (e.g., 7.4, 8.0): " PHP_VERSION

# Validate input
validate_php_version "$PHP_VERSION"

if [[ "$ACTION" == "A" || "$ACTION" == "a" ]]; then
  # Copy php-fpm directory for the new PHP version
  copy_php_fpm_directory "$PHP_VERSION"

  # Add PHP service to docker-compose.yml
  add_php_service "$PHP_VERSION"
elif [[ "$ACTION" == "R" || "$ACTION" == "r" ]]; then
  # Remove PHP service from docker-compose.yml
  remove_php_service "$PHP_VERSION"

  # Remove php-fpm directory for the PHP version
  remove_php_fpm_directory "$PHP_VERSION"
else
  echo "Invalid action. Use 'A' for add or 'R' for remove."
fi

echo "Run: docker compose -p your-project-name up -d"
