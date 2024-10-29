#!/bin/bash

# Démarrer MySQL
service mysql start

# Démarrer PHP-FPM (pour gérer les requêtes PHP dans Nginx)
service php7.3-fpm start
chmod 777 /var/run/php/php7.3-fpm.sock

# Démarrer Nginx en avant-plan pour maintenir le conteneur actif
nginx -g 'daemon off;'