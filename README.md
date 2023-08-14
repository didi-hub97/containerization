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
|   | --- stop.sh
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



#### Accessing the application:

If your application is running, you should be able to access using localhost in your browser
Navigate to your browser and type http://localhost:<port> 

Navigate to the port of the phpmyadmin by either typing http://localhost/port to access the phpmyadmin interface (which the web app that manages MySQL and MariaDB) or click the port from your Docker Desktop, which ever way works just fine.
Login with the user name specified in the .env and the password assigned to the user and login.

<img width="1481" alt="php-admin-login" src="https://github.com/dooshima-gbamwuan-deimos/module2/assets/138670122/386e49b0-7e5e-4ae7-962c-df49e075f824">

Once logged in, create a you should the database at the extreme left, click on it and create the name of the table specified in your form_submit.php, on line 25 of your code. See the image below

<img width="1481" alt="test" src="https://github.com/dooshima-gbamwuan-deimos/module2/assets/138670122/e60884c3-38f9-4b9e-b21d-6b90025373f4">

Here I used test in my php code (form_submit.php), so my table name will be test.
The test table has 3 columns so we will specific 3 columns as shown in the image below:


The column names for the database are specified in the line 25 of the php code (i.e Name, Email, Message). 
Add the column names alongside their data types as shown in the image below:

<img width="1481" alt="columns" src="https://github.com/dooshima-gbamwuan-deimos/module2/assets/138670122/d09e3c55-afdb-4e1e-922b-37e010dccea4">


The next thing is to access the web application have it submit data to the MySQL database.
In youur browser, navigate to the port the app is running on, and you should see this page
<img width="1761" alt="Screenshot 2023-08-01 at 05 36 03" src="https://github.com/dooshima-gbamwuan-deimos/module2/assets/138670122/11aff40a-d723-414a-8658-37c34eb077a4">

Fill the form and click submit and you should receive this feedback

<img width="1761" alt="Screenshot 2023-08-01 at 05 37 34" src="https://github.com/dooshima-gbamwuan-deimos/module2/assets/138670122/6b594495-567f-4778-b517-3a0111c3f12f">

Now we will explore the next option (using bash scripts or terminal)

#### Using Bash Scripts
***
_It is important to know that the terminal can be used instead of using bash script. This is a matter of preference._
_When the docker compose is not used, we are using docker run,  so it's important to know what's applicable to docker run._

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

Make the script executable by running ```sudo chmod +x <name_of_script>```. Using sudo incase of any permission issues.
Execute the script using ```sudo ./<name_of_script>```.

Access the application just we did when we used docker compose and follow the steps listed above to create the table and submit the form.

_Remember to include .env file in the .gitignore file_
<<<<<<< HEAD

#### Setting up Logging and Monitoring using Prometheus and Grafana:
***
It is important to monitor docker containers and there are several tools that can be used to monitor docker containers
The most popularly used is the Prometheus and Grafana.

##### Building the logging and monitoring images.
* cd to the prometheus directory and create a docker-compose.yml file which will pull/create the image and run the containers
  with the following contents:

```
version: '3'
# networks:
#   connect:
#     driver: bridge
services:

  prometheus:
    image: prom/prometheus:latest
    volumes:
      - ./prometheus.yml:/etc/prometheus/prometheus.yml
      - ./prometheus_db:/var/lib/prometheus
    restart: always
    command:
      - '--config.file=/etc/prometheus/prometheus.yml'
    ports:
      - '9091:9090'
    # networks:
    #   - connect

  cadvisor:
    image: gcr.io/cadvisor/cadvisor:latest
    container_name: cadvisor
    restart: always
    ports:
      - 8080:8080
    volumes:
      - /:/rootfs:ro
      - /var/run:/var/run:rw
      - /sys:/sys:ro
      - /var/lib/docker/:/var/lib/docker:ro
    # networks:
    #   - connect
  

  alertmanager:
    image: prom/alertmanager
    restart: always
    ports:
     - '9093:9093'
    volumes:
      - './alertmanager/:/etc/alertmanager/'
    command:
      - '--config.file=/etc/alertmanager/config.yml'
      - '--storage.path=/alertmanager'
    # networks:
    #   - connect

  node-exporter:
    image: prom/node-exporter
    ports:
      - '9100:9100'
    # networks:
    #   - connect
  

  grafana:
    image: grafana/grafana
    restart: always
    user: "1000"
    environment:
      GF_SECURITY_ADMIN_USER: ${GRAFANA-USER}
      GF_SECURITY_ADMIN_PASSWORD: ${GRAFANA-PASSWORD}
    volumes:
      - ./grafana_db:/var/lib/grafana
    depends_on:
      - prometheus
    ports:
      - '3000:3000'
    # networks:
    #   - connect
  ```

* Create a prometheus.ym file the necessary configurations as shown in the file below:

```
global:
  scrape_interval: 5s
  external_labels:
    monitor: 'docker-container-monitor'

rule_files:
  - "alert.rules"

scrape_configs:
  - job_name: 'prometheus' 
    static_configs: 
      - targets: ['prometheus:9090']

  - job_name: 'node-exporter' 
    static_configs: 
      - targets: ['node-exporter:9100']
      
  - job_name: 'cadvisor'
    scrape_interval: 5s
    static_configs:
    - targets: ['cadvisor:8080']

  - job_name: docker
    scrape_interval: 10s
    metrics_path: /metrics
    static_configs:
      - targets: ['host.docker.internal:9323']  
```


* Set the Docker Daemon to allow the cAdvisor to scrape docker metrics with the configurations below:

```
{
  "metrics-addr" : "127.0.0.1:9323",
  "builder": {
    "gc": {
      "defaultKeepStorage": "20GB",
      "enabled": true
    }
  },
  "experimental": true,
  "features": {
    "buildkit": true
  }
}
```
* In the smae directory create another directory called alertmanager. In this directory, create a config.yml file with the following contents:
```
route:
 group_by: [cluster]
 receiver: alert-test
 routes:
  - match:
      severity: slack
      receiver: alert-test

receivers:
- name: alert-test
  slack_configs:
  - api_url: https://hooks.slack.com/services/******************** (Replace with your slack webhooks url)
    channel: '#alert_test'
    icon_url: https://avatars3.githubusercontent.com/u/3380462
    send_resolved: true
    text: "<!channel> \nsummary: {{ .CommonAnnotations.summary }}\ndescription: {{ .CommonAnnotations.description }}"
```
Check how to set up a slack channel for grafana alerts [here](https://grafana.com/docs/grafana/latest/alerting/manage-notifications/template-notifications/)

* In the prometheus root directory, set the alert rules in the alert.rules

```
groups:
- name: targets
  rules:

  # Alert for any instance that is unreachable for >5 minutes.
  - alert: service_down
    expr: up == 0
    for: 30s
    labels:
      severity: page
    annotations:
      summary: "Instance {{ $labels.instance }} down"
      description: "{{ $labels.instance }} of job {{ $labels.job }} has been down for more than 30 Seconds."

  - alert: high_load
    expr: container_fs_limit_bytes > 0
    for: 1m
    labels:
      severity: page
    annotations:
      summary: "Instance {{ $labels.instance }} under high load"
      description: "{{ $labels.instance }} of job {{ $labels.job }} is under high load."
```

* Navigate to your browser and view the configured targets under the status tab as shown below:
* Set up an account on Grafana cloud [here](https://grafana.com/auth/sign-up/create-user)
* Add data source using Docker Desktop as the data source.
* Open the Grafana cloud and navigate to your dashboard
* With the integration, Grafana is able to collect metrics from Docker Desktop and you should see some some visuals

* At the top right of each visual, there are three dots, click on them and select view.
  
* In the top right corner, click on the drop down and select create alert.
  
<img width="1791" alt="Screenshot 2023-08-04 at 04 49 19" src="https://github.com/dooshima-gbamwuan-deimos/module2/assets/138670122/57a5b414-1695-48e2-9b39-bf752f8b68ba">
  
* Navigate to the bottom and create your alert.

<img width="1791" alt="Screenshot 2023-08-04 at 04 49 19" src="https://github.com/dooshima-gbamwuan-deimos/module-2/assets/138670122/87675201-8981-4464-8ad3-cb33dbf8dc17">

* When your alert conditions are met, the selected alert channel will be alerted.
  
<img width="1791" alt="Screenshot 2023-08-10 at 12 33 14 PM" src="https://github.com/dooshima-gbamwuan-deimos/module-2/assets/138670122/d172ca7d-e70e-45ad-8185-a400042003de">

_It is important to note that, alert can be created for time series charts_
