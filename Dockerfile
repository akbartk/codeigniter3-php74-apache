FROM php:7.4-apache

LABEL maintainer="AkbarTK <akbar.exe@gmail.com>"

RUN apt-get update
RUN apt-get upgrade -y

RUN apt-get install --fix-missing -y libpq-dev
RUN apt-get install --no-install-recommends -y libpq-dev
RUN apt-get install -y libxml2-dev libbz2-dev zlib1g-dev
RUN apt-get -y install libsqlite3-dev libsqlite3-0 mariadb-client curl exif ftp
RUN docker-php-ext-install intl
RUN docker-php-ext-install mysqli pdo pdo_mysql
RUN docker-php-ext-enable mysqli
RUN docker-php-ext-enable pdo
RUN docker-php-ext-enable pdo_mysql
RUN apt-get -y install --fix-missing zip unzip nano
RUN apt-get -y install --fix-missing git

# Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer
RUN composer self-update --2
ADD conf/apache.conf /etc/apache2/sites-available/000-default.conf
RUN a2enmod rewrite

RUN printf "#!/bin/bash\n/usr/sbin/apache2ctl -D FOREGROUND" > /startScript.sh
RUN chmod +x /startScript.sh

COPY . /var/www/html
RUN cd /var/www/html
# RUN chmod -R 0777 /var/www/html/writable

RUN apt-get clean \
    && rm -r /var/lib/apt/lists/*

EXPOSE 80 443
VOLUME ["/var/www/html", "/var/log/apache2", "/etc/apache2"]

CMD ["bash", "/startScript.sh"]