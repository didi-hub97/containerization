#!/bin/bash

# Create the network called connect
docker network create --driver bridge connect


sql_db=$(docker run -d \
   --name sql_db \
   --restart always \
   --network connect \
   -e MYSQL_ROOT_PASSWORD=pass \
   -e MYSQL_ROOT_USER=root \
   -e MYSQL_DATABASE=deimos \
   -v /Users/dooshimagbamwuan/Documents/mysql_data:/var/lib/mysql \
   -p 3309:3306 \
   mysql:latest)

# Create phpMyAdmin container
# PMA_HOST is the IP or domain of the MySQL server,
# so we can use the MySQL container name as the domain
# cause the Docker network create the route as a DNS server.
php=$(docker run \
   --name php \
   --network connect \
   -e PMA_HOST=sql_db \
   -p 5000:80 \
   phpmyadmin:latest)


web_app=$(docker run -d \
    --name web_app \
    --network connect \
    -v ./web/src:/var/www/html \
    -p 3000:80 \
    --env-file /Users/dooshimagbamwuan/Documents/.env \
    web-app)


echo "Application is running. Use Ctrl-C to terminate."

# As the app container runs "forever" in detached mode,
# we should keep this script also running,
# otherwise all containers will be terminated upon EXIT.
while :; do sleep 1; done
