# Install necessary tools
sudo apt update && sudo apt upgrade -y
sudo apt install -y python3 python3-pip gunicorn

# ===== Variables =====
DJANGO_PROJECT_ROOT=/home/$USER/nsl/backend
DJANGO_PROJECT_NAME=khelxanepal
GUNICORN_PORT=8000
# =====================

# Install python packages
pip3 install -r $DJANGO_PROJECT_ROOT/requirements.txt

# Create environ file
echo "
POSTGRES_USER=nsl
POSTGRES_PASSWORD=generous-tiptoeing-crop-exclusive" > ~/.gunicorn.env

# Create Gunicorn Service
sudo systemctl stop gunicorn
sudo mkdir /var/log/gunicorn
sudo echo "[Unit]
Description=gunicorn daemon
After=network.target
[Service]
User=$USER
Group=$USER
WorkingDirectory=$DJANGO_PROJECT_ROOT
EnvironmentFile=/home/$USER/.gunicorn.env
ExecStartPre=python3 manage.py makemigrations --settings $DJANGO_PROJECT_NAME.settings.production && \
	python3 manage.py migrate --settings $DJANGO_PROJECT_NAME.settings.production
ExecStart=gunicorn --access-logfile - --workers 3 --bind 0.0.0.0:$GUNICORN_PORT $DJANGO_PROJECT_NAME.wsgi:application
Restart=on-failure
[Install]
WantedBy=multi-user.target" > temp.txt &&
sudo mv temp.txt /etc/systemd/system/gunicorn.service
sudo systemctl start gunicorn
sudo systemctl daemon-reload
sudo systemctl enable gunicorn
sudo systemctl status gunicorn
