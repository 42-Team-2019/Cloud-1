#!/bin/bash

# Vérification si MySQL est déjà initialisé pour éviter les réinitialisations multiples
if [ -d /var/lib/mysql/ ]; then
    echo "MySQL est déjà initialisé. Aucune action nécessaire."
else
    echo "==> Initialisation de MySQL..."
    
    # Récupération des variables d'environnement
    DB_NAME=${DB_NAME:-wordpress}       
    DB_USER=${DB_USER:-wpuser}          
    DB_PASSWORD=${DB_PASSWORD:-password} 
    MYSQL_ROOT_PASSWORD=${MYSQL_ROOT_PASSWORD:-rootpassword} 
    DB_HOST=${DB_HOST:-mysql}  # Utilisation de l'adresse du serveur MySQL

    # Initialisation de la base de données
    mysql_install_db --user=mysql --datadir=/var/lib/mysql

    # Démarrage temporaire de MySQL pour initialisation
    mysqld --user=mysql --datadir=/var/lib/mysql --skip-networking &

    # Attente que MySQL soit prêt
    echo "Attente du démarrage de MySQL..."
    until mysqladmin -u root -p$MYSQL_ROOT_PASSWORD ping --silent; do
        sleep 1
    done

    # Créer la base de données et l'utilisateur avec les privilèges nécessaires
    echo "==> Création de la base de données et de l'utilisateur..."
    
    # Créer la base de données
    mysql -u root -p$MYSQL_ROOT_PASSWORD -h $DB_HOST -e "CREATE DATABASE IF NOT EXISTS $DB_NAME;"
    
    # Créer l'utilisateur
    mysql -u root -p$MYSQL_ROOT_PASSWORD -h $DB_HOST -e "CREATE USER IF NOT EXISTS '$DB_USER'@'%' IDENTIFIED BY '$DB_PASSWORD';"
    
    # Accorder tous les privilèges à l'utilisateur
    mysql -u root -p$MYSQL_ROOT_PASSWORD -h $DB_HOST -e "GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER'@'%';"
    
    # Appliquer les changements de privilèges
    mysql -u root -p$MYSQL_ROOT_PASSWORD -h $DB_HOST -e "FLUSH PRIVILEGES;"

    # Fermer MySQL
    mysqladmin -u root -p$MYSQL_ROOT_PASSWORD -h $DB_HOST shutdown

    echo "==> Initialisation terminée. Démarrage de MySQL..."
fi
