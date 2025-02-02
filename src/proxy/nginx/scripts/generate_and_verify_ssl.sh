#!/bin/bash

# Vérification si les certificats existent
if [ ! -f ${SSL_CERT_PATH} ] || [ ! -f ${SSL_KEY_PATH} ]; then
    echo "Les certificats SSL n'existent pas. Génération en cours..."

    # Générer le certificat SSL auto-signé
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
        -keyout ${SSL_KEY_PATH} \
        -out ${SSL_CERT_PATH} \
        -subj "/C=FR/ST=Paris/L=Paris/O=Example/OU=IT Department/CN=${DOMAIN_NAME}"

    # Vérifier la création des certificats SSL
    if [ -f ${SSL_CERT_PATH} ] && [ -f ${SSL_KEY_PATH} ]; then
        echo "Certificats générés avec succès."
    else
        echo "Erreur : Les certificats n'ont pas été générés correctement." >&2
        exit 1
    fi
else
    echo "Les certificats SSL existent déjà."
fi

# Substitution des variables dans la configuration Nginx et lancement de Nginx
echo "Démarrage de Nginx..."
envsubst < /etc/nginx/nginx.conf.template > /etc/nginx/nginx.conf && nginx -g "daemon off;"
