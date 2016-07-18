FROM debian:jessie

MAINTAINER Nicolas Thal <nico.th4l@gmail.com>

RUN apt-get update \
    && apt-get install -y curl git \
    && echo "deb http://packages.dotdeb.org jessie all" > /etc/apt/sources.list.d/dotdeb.list \
    && curl -sS https://www.dotdeb.org/dotdeb.gpg | apt-key add - \
    && apt-get update \
    && apt-get install -y php7.0-common php7.0-cli php7.0-mcrypt php7.0-mysql php7.0-apcu php7.0-gd php7.0-imagick php7.0-curl php7.0-intl php7.0-tidy php7.0-pgsql php7.0-geoip php7.0-dev

RUN git clone https://github.com/phpredis/phpredis.git \
    && cd phpredis \
    && git checkout php7 \
    && phpize \
    && ./configure \
    && make && make install \
    && cd .. \
    && rm -rf phpredis

RUN apt-get install -y build-essential libssl-dev libxrender-dev wget gdebi
WORKDIR /tmp
RUN wget http://download.gna.org/wkhtmltopdf/0.12/0.12.2.1/wkhtmltox-0.12.2.1_linux-jessie-amd64.deb && \
    gdebi --n wkhtmltox-0.12.2.1_linux-jessie-amd64.deb

ADD conf.d/symfony.ini /etc/php5/cli/conf.d/
ADD conf.d/redis.ini /etc/php5/cli/conf.d/

RUN usermod -u 1000 www-data
