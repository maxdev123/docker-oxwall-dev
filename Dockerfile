FROM php:5-apache

RUN apt-get update && apt-get install -y \
      cron \
      libjpeg-dev \
      libfreetype6-dev \
      libpng-dev \
      libssl-dev \
      ssmtp \
      zip \
 && rm -rf /var/lib/apt/lists/*

RUN docker-php-ext-configure gd --with-freetype-dir=/usr --with-png-dir=/usr --with-jpeg-dir=/usr \
 && docker-php-ext-install gd mbstring mysql pdo_mysql zip ftp

RUN a2enmod rewrite ssl
COPY apache2.conf /etc/apache2/apache2.conf

ENV OXWALL_VERSION 1.8.4.1

RUN curl -fsSL -o oxwall.zip \
      "http://developers.oxwall.com/dl/oxwall-$OXWALL_VERSION.zip" \
 && mkdir -p /usr/src/oxwall \
 && mv oxwall.zip /usr/src/oxwall/ \
 && cd /usr/src/oxwall \
 && unzip oxwall.zip \
 && rm oxwall.zip

RUN mkdir -p /etc/apache2/external
COPY 001-default-ssl.conf /etc/apache2/sites-enabled/001-default-ssl.conf
COPY php.ini /usr/local/etc/php/php.ini
COPY docker-entrypoint.sh /entrypoint.sh

EXPOSE 80
EXPOSE 443

ENTRYPOINT ["/entrypoint.sh"]
CMD ["apache2-foreground"]
