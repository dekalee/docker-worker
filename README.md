Dekalee Worker (docker)
=======================

This docker image wraps all required components for our php / symfony workers at AdBack, but it might be useful for you too.

Components
----------

The following librairies, components and programs are already installed:
- php7.3-cli
- libfreetype6
- libjpeg62-turbo-dev
- libpng-dev
- libcurl4-gnutls-dev
- libpq-dev
- zlib1g-dev
- libicu-dev
- libtidy-dev
- libmagickwand-dev
- libmagickcore-dev
- libgeoip-dev
- libzip-dev
- git
- cron
- g++
- gnupg2
- php-intl
- php-gd
- php-pdo_mysql
- php-pdo_pgsql
- php-opcache
- php-curl
- php-tidy
- php-zip
- php-imagick
- nodejs
- statsd
- blackfire
- couchbase

Usage
-----

Simply set this docker image as your base image in your Dockerfile
```dockerfile
FROM dekalee/docker-worker:latest
```
and add your configuration below

