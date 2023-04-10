#!/usr/bin/env bash

set -e # Exit immediately if a command exits with a non-zero status

# Install Nginx
sudo apt-get update -y
sudo apt-get install -y nginx

# Configure firewall
sudo ufw allow 'Nginx HTTP'

# Create directory for web pages
sudo mkdir -p /var/www/html

# Set permissions for web directory
sudo chmod -R 755 /var/www

# Create custom index page
echo 'Hello World!' | sudo tee /var/www/html/index.html

# Create custom 404 error page
echo "Ceci n'est pas une page" | sudo tee /var/www/html/404.html

# Configure redirect for a single page (/redirect_me)
redirect_config="server_name _;\n\tadd_header X-Served-By \$hostname;\n\trewrite ^\/redirect_me https:\/\/www.javalite.tech permanent;"
sudo sed -i "s/server_name _;/$redirect_config/" /etc/nginx/sites-enabled/default

# Configure redirect for 404 errors
error_config="listen 80 default_server;\n\terror_page 404 \/404.html;\n\tlocation = \/404.html {\n\t\troot \/var\/www\/html;\n\t\tinternal;\n\t}"
sudo sed -i "s/listen 80 default_server;/$error_config/" /etc/nginx/sites-enabled/default

# Restart Nginx service
sudo service nginx restart

echo "Nginx installed and configured successfully!"

