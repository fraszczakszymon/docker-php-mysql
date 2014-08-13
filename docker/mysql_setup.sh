#!/usr/bin/env sh

echo 'Starting mysqld'
mysqld_safe &

echo 'Waiting for mysqld to come online'
while [ ! -x /var/run/mysqld/mysqld.sock ]; do
    sleep 1
done

echo "CREATE DATABASE IF NOT EXISTS webapp;" | mysql -uroot
echo "GRANT ALL PRIVILEGES ON webapp.* TO developer@localhost IDENTIFIED BY 'webapp';" | mysql -uroot

echo 'Shutting down mysqld'
mysqladmin -uroot shutdown