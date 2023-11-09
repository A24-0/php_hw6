FROM php:8.1-fpm

WORKDIR /app

RUN groupadd --gid 1000 docker

RUN useradd --gid 1000 --uid 1000 docker

RUN apt-get update
RUN apt-get upgrade -y

RUN apt install -y git zip unzip

RUN apt install -y libpq-dev && \
      docker-php-ext-install pdo pdo_pgsql pgsql

#COPY entrypoint.sh /entrypoint-component.sh

RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
RUN php -r "if (hash_file('sha384', 'composer-setup.php') === 'e21205b207c3ff031906575712edab6f13eb0b361f2085f1f1237b7126d785e826a450292b6cfd1d64d92e6563bbde02') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
RUN php composer-setup.php
RUN php -r "unlink('composer-setup.php');"

RUN mv composer.phar /usr/local/bin/composer

USER docker:docker

EXPOSE 9000

CMD ["php-fpm", "-O", "-F"]