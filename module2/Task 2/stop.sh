trap """echo -en '\nStopping the DB...';
docker stop $sql_db;
echo -en 'OK\nStopping the phpmyadmin...';
docker stop $php;
echo -en 'OK\nStopping the web-app...';
docker stop $web_app;
echo -en 'OK\nStopping the network...';
docker network rm connect;
echo 'OK';
""" TERM KILL EXIT