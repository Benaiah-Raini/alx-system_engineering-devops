# configures a new server with nginx and custom headers

exec { 'command':
  command  => 'apt-get -y update;
  apt-get -y install nginx;
  sudo sed -iE "s/listen 80 default_server;/listen 80 default_server; \n\tadd_header X-Served-By \$hostname;/" /etc/nginx/sites-available/default;
  sudo service nginx restart',
  provider => shell,
}
