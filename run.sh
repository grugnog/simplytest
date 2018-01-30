#!/usr/bin/env sh

echo 'Starting servers'
# Use the normal PHP configuration from now on.
mv /etc/php7/php.ini.apache /etc/php7/php.ini
multirun "httpd -D FOREGROUND" "/usr/bin/mysqld --user=mysql --console"
