#!/bin/bash
# Fix printful nginx problem
chmod o+x /srv/www
chmod +r /srv/www/index.php
chown www-data /srv/www/app.log
rm /etc/nginx/sites-enabled/default.conf
sleep 1
cp default.conf /etc/nginx/sites-enabled/default.conf
sleep 1
service php7.4-fpm restart
sleep 2
nginx -s reload
