#!/bin/bash

mysql_install_db;

chmod -R 777 /var/lib/mysql;

exec /usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf;
