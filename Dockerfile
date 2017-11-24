FROM php:7.1-cli

MAINTAINER Nicolas Thal <nico.th4l@gmail.com>

RUN apt-get update \
    && apt-get install -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        libpng12-dev \
        libcurl4-gnutls-dev \
        libpq-dev \
        zlib1g-dev \
        libicu-dev \
        libtidy-dev \
        libmagickwand-dev \
        libmagickcore-dev \
        libgeoip-dev \
        git \
        cron \
        g++

RUN docker-php-ext-configure intl && docker-php-ext-install intl

RUN docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd

RUN docker-php-ext-install -j$(nproc) mcrypt pdo_mysql pdo_pgsql opcache curl tidy zip

RUN pecl install imagick \
    && docker-php-ext-enable imagick

WORKDIR /tmp
RUN git clone https://github.com/Zakay/geoip.git \
    && cd geoip \
    && phpize \
    && ./configure \
    && make \
    && make install \
    && docker-php-ext-enable geoip

RUN pecl install redis \
    && docker-php-ext-enable redis

RUN apt-get install -y build-essential libssl-dev libxrender-dev wget gdebi
WORKDIR /tmp
RUN wget http://download.gna.org/wkhtmltopdf/0.12/0.12.2.1/wkhtmltox-0.12.2.1_linux-jessie-amd64.deb && \
    gdebi --n wkhtmltox-0.12.2.1_linux-jessie-amd64.deb

ADD conf.d/symfony.ini /usr/local/etc/php/conf.d/
ADD conf.d/memory.ini /usr/local/etc/php/conf.d/

RUN usermod -u 1000 www-data

RUN \
  wget -qO - https://deb.nodesource.com/setup_4.x | bash - && \
  apt-get -qq update -y && \
  apt-get -qq install -y nodejs && \
  apt-get -qq clean -y && rm -rf /var/lib/apt/lists/*

# Install StatsD
RUN \
  mkdir -p /opt && \
  cd /opt && \
  wget -qO statsd.tar.gz https://github.com/etsy/statsd/archive/v0.8.0.tar.gz && \
  tar -xzf statsd.tar.gz && \
  mv statsd-0.8.0 statsd && \
  rm -f statsd.tar.gz
