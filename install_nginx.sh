#! /bin/bash
sudo apt-get update
sudo apt-get install -y nginx
sudo systemctl start nginx
sudo systemctl enable nginx
echo "<center><h1>Yes</h1><br><h2>Deployed via Terraform<h2><br>$HOSTNAME" > /var/www/html/index.html