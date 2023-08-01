DB_NAME="nsl";
DB_USER="nsl";
DB_PASS="generous-tiptoeing-crop-exclusive";

sudo apt update &&\
sudo apt install -y postgresql

echo "CREATE DATABASE $DB_NAME;"                                                        | sudo -u postgres psql
echo "CREATE USER $DB_USER WITH PASSWORD '$DB_PASS';"                                   | sudo -u postgres psql
echo "ALTER ROLE $DB_USER SET client_encoding TO 'utf-8';"                              | sudo -u postgres psql
echo "ALTER ROLE $DB_USER SET default_transaction_isolation TO 'read committed';"       | sudo -u postgres psql
echo "ALTER ROLE $DB_USER SET timezone to 'UTC';"                                       | sudo -u postgres psql
echo "GRANT ALL PRIVILEGES ON DATABASE $DB_NAME TO $DB_USER;"                           | sudo -u postgres psql
