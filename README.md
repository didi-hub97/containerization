## Deimos Internship Module 2 task

### Task:
***
Containerisation is an important part of software development as it packages an application, it dependencies, runtime, etc 
into a single container and thus be deployed to where it will run.
The task involves, dockerizing a php application that sends data to a mysql database.
The source php and index.html code used for this application can be found [here](https://dev.to/satellitebots/create-a-web-server-and-save-form-data-into-mysql-database-using-php-beginners-guide-fah)


### Aim of Project:
***
Over time technology has evolved and so has software development.
In the ideal world every development environment matches the production one, at least in terms of software versions and features (like compilation options etc.) 
In times past, developers faced challenges with applications working in one OS and failing in another or applications working in either production stage and failing at deployment stage thus making software development and deployment a challenge
In more recent times, applications can be packaged together alongside with the dependencies and runtime and shipped 
to another stage or hosted on another OS, thus solving of the problem of "it's not running my device". 
Containerization made this possible; where applications are packaged into containers and shipped

**In this project, using one of the most commonly used software development stacks, LAMP(Linux, Apache, Mysql, php), we built a login website that submits form the mysql database and volumes are used to ensure data persistence.**


### Requirements/Tools Used:
***
* Basic knowledge of Linux and Docker
* [Docker Docs](https://docs.docker.com/get-started/overview/)
* VS-code
* Docker
* Grafana and Prometheus 
* GitHub 

_Please note I am still working on setting up Prometheus and Grafana for this project and I will turn it on or before nextweek._


### Solution architecture:



### Directory Structure:
***
```
Module 2/
|--web/
|   |-- src/
|   |   -- index.html
|   |   -- form_submit.php
|-- Task 2/
|   |-- web /
|   |     -- src /
|   |          -- index.html
|   |          -- form_submit.php
|   | --- Dockerfile
|   | --- build.sh
|
|-- docker-compose.yml
|--README.md
|.env/.gitignore
```


### Details of Work done:
***
The task was in two parts, 
- To run containers using docker compose
- Manage multiple containers without using docker compose. For the purpose of the project, I used a bash script.
It is important to know that, this can also be done using the terminal.

**Let's explore how the task was done using docker-compose**
- First I created a Dockerfile using the code below
```
FROM php:7.4-apache
RUN docker-php-ext-install pdo pdo_mysql

```
Using the fundamental docker command, ```FROM``` the php-apache image is used as the base image and the ```docker-php-ext-install pdo pdo_mysql```
is used as the php drive so the web app can connect to the database. 
Excluding the part of the image will throw a driver connection error.

The .env file is used to contain the contain environment variables and sensitive data that are not supposed to be contain
in the main source code such as password and .gitignore is used to ignore the file so that the file is not pushed to the GitHub.

Since this application is a multi-container application, a docker-compose will be used to manage to the containers.
The YAML(Ain't markup language) is used to create a docker-compose file, with the .yml extension.
The docker-compose file should be in the root directory.

Let's take a look at the docker compose file
```
version: '3.8'

services:

  web:
    build: 
        context: .
        dockerfile: Dockerfile 
    depends_on:
      - db
    env_file:
      - .env
    volumes:
       - ./web/src:/var/www/html/
    
    ports:
      - 8080:80

  db:
    image: mysql:latest
    command: --default-authentication-plugin=mysql_native_password
    restart: always
    env_file:
      - .env
    environment:
      MYSQL_ROOT_PASSWORD: ${MYSQL_ROOT_PASSWORD}
      MYSQL_DATABASE: ${MYSQL_DATABASE}
      #MYSQL_USER: ${MYSQL_USER}
      MYSQL_PASSWORD: ${MYSQL_PASSWORD}
    ports:
      - 3306:3306
    volumes:
      - db:/var/lib/mysql     

  phpmyadmin:
    image: phpmyadmin:latest
    ports:
      - 81:80
    restart: always
    environment:
      PMA_HOST: db
    depends_on:
      - db
volumes:
      db:

```
* The version 3.8 of docker-compose is used to manage the containers
* The services section specifies the containers we want to run in this docker-compose file alongside the ports they
should be accessible on
* Volumes are used to ensure data persistence, so the data isn't lost when the containers are stopped since containers are ephemeral and stateless
* The necessary environment variables are also set.
* The _PMA-HOST_ in the phpmyadmin is used to specify the name of the MySQL database container the phpmyadmin should connect to through the web 
interface when it is up and running.

**The source code used to build this web application can be found [here](https://dev.to/satellitebots/create-a-web-server-and-save-form-data-into-mysql-database-using-php-beginners-guide-fah)**

There source code is be in the /web/src directory refer to the directory structure above.

#### How to build your application:

The ```docker-compose up``` is used to run the containers. Inside the docker-compose file, the path to the dockerfile needed to build the web applicatio
is specified while other images such as the MySQL and the phpmyadmin are pull from the docker hub thus running the containers.
```docker-compose down``` command is used to stop the containers from running and also remove them.
The command should be executed in the terminal.
The terminal should have this output if your build was successful.
![Terminal output](/Users/dooshimagbamwuan/Desktop/terminal_output)

#### Accessing the application:

Navigate to your Docker Desktop and your containers should be show running under the status tab in the Docker Desktop as shown in the 
image below.
![Docker containers](/Users/dooshimagbamwuan/Desktop/docker-containers)

Navigate to the port of the phpmyadmin by either typing http://localhost/port to access the phpmyadmin interface (which the web app that manages MySQL and MariaDB) or click the port from your Docker Desktop, which ever way works just fine.
Login with the user name specified in the .env and the password assigned to the user and login.

![login](/Users/dooshimagbamwuan/Desktop/php-admin-login)

Once logged in, create a you should the database at the extreme left, click on it and create the name of the table specified in your form_submit.php, on line 25 of your code. See the image below

![php-code](/Users/dooshimagbamwuan/Desktop/php-code)

Here I used test so my table name will be test.
Also in the php code the test table has 3 columns so we will specific 3 columns as shown in the image below:

![test-table](/Users/dooshimagbamwuan/Desktop/test)

The column names for the database are specified in the line 25 of the php code (i.e Name, Email, Message). 
Add the column names alongside their data types as shown in the image below:

![columns](/Users/dooshimagbamwuan/Desktop/columns)

The next thing is to access the web application have it submit data to the MySQL database.
In youur browser, navigate to the port the app is running on, and you should see this page
![appp](/Users/dooshimagbamwuan/Desktop/app)

Fill the form and click submit and you should receive this feedback
![feeback](/Users/dooshimagbamwuan/Desktop/feedback)

Now we explore the next option (using bash scripts or terminal)

#### Using Bash Scripts
***
_It is important to know that the terminal can be used instead of using bash script. This is a matter of preference._
_When the docker compose is not used, we are using docker run,  so it's important to know what's applicable with docker run._

The bash script can be found here:

```
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

```
* The first thing to do is to create a network so that the containers can be on a single network for them to communicate with each other.
* The name specifies the name of the docker container ID is saved in the ```sql_db=$``` so that when stopping the container the name sql_db will be used
instead of the ID.
Everything else to pretty similar to the docker-compose

Make the script executable by running ```sudo chmod +x <name_of_script>```. Uisng sudo incase of any permission issues.
Execute the script using ```sudo ./<name_of_script>```.

Access the application just we did when we used docker compose and follow the steps listed above to create the table and submit the form.

_Remember to include .env file in the .gitignore file_

**Up next is setting up monitoring using grafana and prometheus**
