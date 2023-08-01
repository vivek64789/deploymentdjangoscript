echo
echo ======= Basic HTTP AUthentication =======
echo

HTTP_USER="franchise"
PASSWORD="7aNA#$7^2!z2&g56U*Kas"
PASSWORD_FILE="/etc/nginx/.htpasswd"

# Install apache3-utils for htpasswd
which apache2-utils || sudo apt install apache2-utils -yq

# Generate password using htpasswd
htpasswd -c -b "$PASSWORD_FILE" "$HTTP_USER" "$PASSWORD"


