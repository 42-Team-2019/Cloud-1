# Utiliser l'image officielle MySQL comme base
FROM mysql:8.0

# Copier le script d'initialisation dans le conteneur
COPY ./config/init_mysql.sh /docker-entrypoint-initdb.d/

# Rendre le script exécutable 
RUN chmod +x /docker-entrypoint-initdb.d/init_mysql.sh

# Exposer le port MySQL
EXPOSE 3306


