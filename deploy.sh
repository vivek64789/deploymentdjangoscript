DJANGO_ROOT=~/Project-Bhariya/backend
REACT_ROOT=~/Project-Bhariya/frontend
PUBLIC_PATH=/var/www/bhariya

# Npm build
cd $REACT_ROOT &&\
npm ci --only=production &&\
npm run build || exit

# Django collectstatic
cd $DJANGO_ROOT &&\
python3 manage.py collectstatic --noinput --skip-checks

# Create public path
sudo mkdir $PUBLIC_PATH

# Copy frontend files to public path
sudo cp -r $REACT_ROOT/build/* $PUBLIC_PATH/

# Copy django static files to public path
sudo cp -r $DJANGO_ROOT/static/* $PUBLIC_PATH/static/

# Make permissions to global for the public files
sudo chmod 777 -R $PUBLIC_PATH

# Restart services
sudo systemctl restart gunicorn nginx
sudo systemctl status gunicorn nginx
