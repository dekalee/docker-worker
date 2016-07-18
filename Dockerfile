FROM debian:jessie

MAINTAINER Nicolas Thal <nico.th4l@gmail.com>

RUN apt-get update && apt-get install -y php5-common php5-cli php5-mcrypt php5-mysql php5-apcu php5-gd php5-imagick php5-curl php5-intl php5-tidy php5-pgsql php5-geoip php5-dev

RUN yes yes | pecl install redis-2.2.7 && echo "extension=redis.so > /etc/php5/cli/conf.d/30-redis.so"

RUN apt-get install -y build-essential libssl-dev libxrender-dev wget gdebi
WORKDIR /tmp
RUN wget http://download.gna.org/wkhtmltopdf/0.12/0.12.2.1/wkhtmltox-0.12.2.1_linux-jessie-amd64.deb && \
    gdebi --n wkhtmltox-0.12.2.1_linux-jessie-amd64.deb

ADD conf.d/symfony.ini /etc/php5/cli/conf.d/
ADD conf.d/redis.ini /etc/php5/cli/conf.d/

RUN usermod -u 1000 www-data
