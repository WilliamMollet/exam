#!/bin/bash

# Démarrer MySQL
service mysql start

# Démarrer PHP-FPM (pour gérer les requêtes PHP dans Nginx)
service php7.3-fpm start

# Démarrer Nginx en avant-plan pour maintenir le conteneur actif
nginx -g "daemon off;"
