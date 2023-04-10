#!/usr/bin/env bash
# Install nginx server
sudo apt-get update -y
sudo apt-get install -y nginx

# Config firewall
sudo ufw allow 'Nginx HTTP'
sudo mkdir -p /var/www/html

# Config permissions
sudo chmod -R 755 /var/www

# Create index page
echo 'Hello World!' |sudo tee  /var/www/html/index.html

# Create 404 page
echo "Ceci n'est pas une page" |sudo tee /var/www/html/404.html

# Set redirect for a single page(/redirect_me)

string_for_replacement="server_name _;\n\tadd_header X-Served-By \$hostname;\n\trewrite ^\/redirect_me https:\/\/www.javalite.tech permanent;"

sudo sed -i "s/server_name _;/$string_for_replacement/" /etc/nginx/sites-enabled/default

# Config redirect for 404 error

string_for_replacement="listen 80 default_server;\n\terror_page 404 \/404.html;\n\tlocation = \/404.html {\n\t\troot \/var\/www\/html;\n\t\tinternal;\n\t}"

sudo sed -i "s/listen 80 default_server;/$string_for_replacement/" /etc/nginx/sites-enabled/default

# Restart web server
sudo service nginx restart
