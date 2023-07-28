# Use the official PHP 7.4 Apache image as the base image
FROM php:7.4-apache

#RUN echo "ServerName localhost" >> /etc/apache2/apache/apache.conf

COPY ./web/src /var/www/html/
RUN docker-php-ext-install pdo pdo_mysql


# Expose port 80 to the host machine
EXPOSE 3000:80