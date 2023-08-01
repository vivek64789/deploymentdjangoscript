ROOT_DOMAIN=nepalsuperleague.com
HOST=www.nepalsuperleague.com
FRONTEND_ROOT=/var/www/nsl
GUNICORN_PORT=8000

# Install required tools
sudo apt update && sudo apt upgrade -y
sudo apt install -y software-properties-common
sudo apt install -y nginx letsencrypt python3-certbot-nginx

# Obtain SSL Certificates
sudo certbot certonly --nginx -d $HOST -d $ROOT_DOMAIN ||\
sudo certbot certonly --nginx -d $HOST || exit

# Firewall rules
sudo ufw allow 'OpenSSH'
sudo ufw allow 'Nginx Full'
sudo ufw allow 'Nginx HTTP'
sudo ufw allow 'Nginx HTTPS'

# Setup nginx configuration
echo "server {
        listen 443 ssl;
        server_name $HOST;

        ssl_certificate /etc/letsencrypt/live/$HOST/fullchain.pem;
        ssl_certificate_key /etc/letsencrypt/live/$HOST/privkey.pem;

        root $FRONTEND_ROOT;

        location = /index.html                  { try_files \$uri =404; }
	try_files \$uri \$uri/ /;

        location = / {
                index index.html;

                # Kill cache
                expires -1;

                #rewrite ^/ /index.html;
        }

        location /static/ {
                alias $FRONTEND_ROOT/static/;
        }

        location /assets/ {
                alias $FRONTEND_ROOT/assets/;
        }

}

server {
        listen 80;
        server_name $ROOT_DOMAIN $HOST;
        return 301 https://\$host\$request_uri;
}

server {
        listen 443;
        server_name $ROOT_DOMAIN;
        return 301 http://$HOST\$request_uri;
}" > temp.conf
sudo mv temp.conf /etc/nginx/sites-available/$HOST
sudo ln -s /etc/nginx/sites-available/$HOST /etc/nginx/sites-enabled/$HOST
sudo systemctl daemon-reload
sudo systemctl restart nginx
sudo systemctl status nginx
