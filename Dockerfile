FROM phusion/baseimage:0.9.12

MAINTAINER Szymon Frąszczak <fraszczak.szymon@gmail.com>

RUN /etc/my_init.d/00_regen_ssh_host_keys.sh
CMD ["/sbin/my_init"]

RUN apt-get update
RUN apt-get install -y curl wget ant apache2 php5 php5-cli php5-fpm php5-mysql php5-pgsql php5-sqlite php5-curl php5-gd php5-mcrypt php5-intl php5-imap php5-tidy libapache2-mod-php5

RUN cp -p /usr/share/zoneinfo/Europe/Warsaw /etc/localtime
RUN echo "Europe/Warsaw" > /etc/timezone 
RUN sed -i "s/;date.timezone =.*/date.timezone = \"Europe\/Warsaw\"/" /etc/php5/fpm/php.ini
RUN sed -i "s/;date.timezone =.*/date.timezone = \"Europe\/Warsaw\"/" /etc/php5/cli/php.ini

ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2

ADD docker/webapp.conf /etc/apache2/sites-available/webapp.conf
ADD docker/httpd.conf /etc/apache2/conf.d/httpd.conf

RUN a2ensite webapp
RUN a2dissite 000-default
RUN a2enmod rewrite
RUN rm -rf /var/www

ADD docker/apache.sh /etc/my_init.d/apache.sh

EXPOSE 80

RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*