# Utilisation de l'image officielle Nginx
FROM nginx:latest

# Installer systemd, systemctl, fish, openssl et gettext-base
RUN apt-get update && \
    apt-get install -y \
    systemd \
    systemd-sysv \
    fish \
    openssl \
    gettext-base && \
    rm -rf /var/lib/apt/lists/*

# Créer le dossier pour les certificats SSL
RUN mkdir -p /etc/nginx/ssl

# Copier le script de génération des certificats
COPY ./scripts/generate_and_verify_ssl.sh /usr/local/bin/generate_and_verify_ssl.sh

# Donner les permissions d'exécution au script
RUN chmod +x /usr/local/bin/generate_and_verify_ssl.sh

# Copier la configuration Nginx (template avec des variables d'environnement)
COPY ./conf/nginx.conf.template /etc/nginx/nginx.conf.template

# Exposer les ports HTTP et HTTPS
EXPOSE 80 443

# Exécuter le script de génération et démarrer Nginx
CMD /usr/local/bin/generate_and_verify_ssl.sh
