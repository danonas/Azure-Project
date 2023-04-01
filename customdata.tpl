#!/bin/bash

sudo apt-get update 
sudo apt-get install apache2 -y
sudo apt-get install php libapache2-mod-php -y
sudo systemctl restart apache2
sudo apt-get install wget -y
wget https://wordpress.org/latest.tar.gz
sudo tar -xf latest.tar.gz -C /var/www/html/
sudo mv /var/www/html/wordpress/* /var/www/html/
sudo cp /var/www/html/wp-config-sample.php /var/www/html/wp-config.php
sudo sed 's/database_name_here/db-wordpress/g' /var/www/html/wp-config.php -i
sudo sed 's/username_here/mysqladminun@team2mysql-wordpress/g' /var/www/html/wp-config.php -i
sudo sed 's/password_here/W0rdpr3ss@p4ss/g' /var/www/html/wp-config.php -i
sudo sed 's/localhost/team2mysql-wordpress.mysql.database.azure.com/g' /var/www/html/wp-config.php -i
DBNAME="db-wordpress"
sudo apt-get install mysql-server -y
sudo apt-get install php-mysql -y
sudo ufw allow in "Apache Full"
sudo chown -R www-data:www-data /var/www/html/
sudo rm -f /var/www/html/index.html 
sudo systemctl restart apache2
