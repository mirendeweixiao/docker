# Docker LNMP Environment

A comprehensive LNMP (Linux, Nginx, MySQL, PHP) environment with Docker for development and testing purposes. This setup includes additional services such as Redis, MailHog, and Ofelia for a complete development ecosystem.

## Table of Contents

- [Docker LNMP Environment](#docker-lnmp-environment)
  - [Table of Contents](#table-of-contents)
  - [Project Structure](#project-structure)
  - [Getting Started](#getting-started)
    - [Prerequisites](#prerequisites)
    - [Installing](#installing)
  - [Environment Configuration](#environment-configuration)
  - [Docker Compose Services](#docker-compose-services)
  - [Usage](#usage)
  - [Configuration](#configuration)
    - [Nginx Configuration](#nginx-configuration)
    - [PHP Configuration](#php-configuration)
      - [Xdebug Configuration](#xdebug-configuration)
    - [MySQL Configuration](#mysql-configuration)
    - [Redis Configuration](#redis-configuration)
    - [MailHog Configuration](#mailhog-configuration)
    - [Ofelia Configuration](#ofelia-configuration)
  - [Networking](#networking)
  - [Volumes](#volumes)
  - [Troubleshooting](#troubleshooting)
  - [Contributing](#contributing)
  - [License](#license)

## Project Structure

```
├── config.ini
├── docker-compose.yml
├── LICENSE
├── nginx
│   ├── conf
│   │   ├── fastcgi_params
│   │   ├── mime.types
│   │   ├── nginx.conf
│   │   ├── sites-conf
│   │   │   ├── general.conf
│   │   │   ├── php.conf
│   │   │   └── proxy.conf
│   │   ├── sites-enabled
│   │   │   └── domain.conf.example
│   │   └── ssl
│   │       ├── domain.com.crt
│   │       └── domain.com.key
│   └── Dockerfile
├── php-fpm
│   ├── conf
│   │   ├── pear.conf
│   │   ├── php
│   │   │   ├── conf.d
│   │   │   │   ├── docker-php-ext-*.ini
│   │   │   │   └── docker-php-ext-xdebug.ini.example
│   │   │   └── php.ini
│   │   ├── php-fpm.conf
│   │   ├── php-fpm.conf.default
│   │   └── php-fpm.d
│   │       ├── docker.conf
│   │       ├── www.conf
│   │       ├── www.conf.default
│   │       └── zz-docker.conf
│   ├── Dockerfile
│   └── mhsendmail_linux_amd64
└── README.md
```

## Getting Started

### Prerequisites

- [Docker](https://docs.docker.com/get-docker/)
- [Docker Compose](https://docs.docker.com/compose/install/)

### Installing

1. Clone this repository:
   ```
   git clone https://github.com/hirale/docker.git
   cd docker
   ```

2. Copy the example environment file:
   ```
   cp .env.example .env
   ```

3. Set up your domain configuration in Nginx:
   ```
   cp nginx/conf/sites-enabled/domain.conf.example nginx/conf/sites-enabled/your-domain.conf
   ```

4. (Optional) Set up SSL configuration:
   ```
   # Place your SSL certificate and key in the nginx/conf/ssl directory
   cp your-ssl-cert.crt nginx/conf/ssl/domain.com.crt
   cp your-ssl-key.key nginx/conf/ssl/domain.com.key
   ```

5. Customize the `.env` file with your preferred settings.

## Environment Configuration

The `.env` file contains important configuration variables. Key variables include:

- `NGINX_VERSION`, `PHP_VERSION`, `MYSQL_VERSION`: Specify the versions of Nginx, PHP, and MySQL to use.
- `MYSQL_DATABASE`, `MYSQL_USER`, `MYSQL_PASSWORD`, `MYSQL_ROOT_PASSWORD`: MySQL configuration.
- `WEB_ROOT`: The path to your web projects.
- `NGINX_CONFIG`, `PHP_CONFIG`, `OFELIA_CONFIG`: Paths to configuration directories.

## Docker Compose Services

The `docker-compose.yml` file defines the following services:

1. `nginx`: Web server
2. `php-fpm`: PHP FastCGI Process Manager
3. `mysql`: MySQL database server
4. `mailhog`: Email testing tool
5. `redis`: In-memory data structure store
6. `ofelia`: Job scheduler

## Usage

Starting the environment:
```
docker compose -p your-project-name up -d
```

Stopping the environment:
```
docker compose -p your-project-name down
```

Accessing containers (e.g., php-fpm):
```
docker exec -it -u www-data php-fpm /bin/bash
```

## Configuration

### Nginx Configuration

- Main configuration: `nginx/conf/nginx.conf`
- Site configurations: `nginx/conf/sites-enabled/`
- SSL certificates: `nginx/conf/ssl/`

### PHP Configuration

- PHP-FPM configuration: `php-fpm/conf/php-fpm.conf`
- PHP INI: `php-fpm/conf/php/php.ini`
- PHP extensions: `php-fpm/conf/php/conf.d/`

#### Xdebug Configuration

To enable and configure Xdebug for PHP debugging:

1. Enable `xdebug`:

   ```
   mv php-fpm/conf/php/conf.d/docker-php-ext-xdebug.ini.example php-fpm/conf/php/conf.d/docker-php-ext-xdebug.ini
   docker restart php-fpm
   ```

2. Configure your IDE to listen for PHP Debug connections on port 9003.

### MySQL Configuration

MySQL is configured using environment variables in the `docker-compose.yml` file and `.env` file.

### Redis Configuration

Redis uses the default configuration. To customize, add a `redis.conf` file and mount it as a volume in `docker-compose.yml`.

### MailHog Configuration

MailHog uses the default configuration. The `mhsendmail_linux_amd64` binary in the `php-fpm` directory can be used to send emails to MailHog for testing.

### Ofelia Configuration

Ofelia is configured using the `config.ini` file in the root directory.

## Networking

Services are connected to a custom network named `backend` with predefined IP addresses. The network uses the subnet 172.20.0.0/16.

## Volumes

- `mysql`: Persists MySQL data

## Troubleshooting

1. Check Docker logs: `docker compose -p your-project-name logs`
2. Verify running containers: `docker compose -p your-project-name ps`
3. Ensure correct paths in `.env` file
4. Check for port conflicts

## Contributing

Contributions to hirale/docker are welcome! Please submit Pull Requests or open Issues on the GitHub repository.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.