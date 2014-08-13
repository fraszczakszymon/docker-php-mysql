#!/usr/bin/env sh

if [ ! -d /var/lib/mysql/mysql ]; then

    mysqld_safe --skip-syslog &

    while [ ! -x /var/run/mysqld/mysqld.sock ]; do
        sleep 1
    done

    echo 'Setting root password to root'
    /usr/bin/mysqladmin -u root password 'root'

    echo 'Shutting down mysqld'
    mysqladmin -uroot -proot shutdown

fi