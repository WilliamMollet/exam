# Utiliser Debian Buster comme image de base
FROM debian:buster

# Mettre à jour les paquets et installer les dépendances nécessaires
RUN apt-get update && \
    apt-get install -y nginx php php-fpm php-mysql default-mysql-server wget unzip curl openssl && \
    apt-get clean

# Installer et configurer MySQL
RUN service mysql start && \
    mysql -e "CREATE DATABASE wordpress;" && \
    mysql -e "CREATE USER 'user'@'localhost' IDENTIFIED BY 'password';" && \
    mysql -e "GRANT ALL PRIVILEGES ON wordpress.* TO 'user'@'localhost';" && \
    mysql -e "FLUSH PRIVILEGES;"

# Télécharger et configurer WordPress
RUN wget https://wordpress.org/latest.zip && \
    unzip latest.zip && \
    mv wordpress /var/www/html/ && \
    chown -R www-data:www-data /var/www/html/wordpress

# Télécharger et configurer phpMyAdmin
RUN wget https://www.phpmyadmin.net/downloads/phpMyAdmin-latest-all-languages.zip && \
    unzip phpMyAdmin-latest-all-languages.zip && \
    mv phpMyAdmin-*-all-languages /var/www/html/phpmyadmin && \
    chown -R www-data:www-data /var/www/html/phpmyadmin

# Copier le fichier de configuration Nginx
COPY nginx.conf /etc/nginx/nginx.conf
COPY index.php /var/www/html/index.php

# Générer un certificat auto-signé pour SSL
RUN mkdir /etc/nginx/ssl && \
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/nginx/ssl/nginx.key \
    -out /etc/nginx/ssl/nginx.crt \
    -subj "/C=FR/ST=France/L=Paris/O=MonEntreprise/OU=IT/CN=localhost"

# Déclarer les volumes pour persister les données de WordPress et MySQL
VOLUME /var/www/html/wordpress
VOLUME /var/lib/mysql

# Exposer les ports HTTP et HTTPS
EXPOSE 80 443

# Utiliser un script de démarrage personnalisé
COPY start.sh /start.sh
RUN chmod +x /start.sh

# Utiliser le script de démarrage comme commande par défaut
CMD ["/start.sh"]
