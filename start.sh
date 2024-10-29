#!/bin/bash

# Démarrer Nginx en avant-plan pour maintenir le conteneur actif
nginx -g "daemon off;"

# Démarrer MySQL
service mysql start

# Démarrer PHP-FPM (pour gérer les requêtes PHP dans Nginx)
service php7.3-fpm start

