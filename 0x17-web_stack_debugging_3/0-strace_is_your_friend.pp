# Debugs apache2 server error

exec { 'sed -i s/phpp/php/g /var/www/html/wp-settings.php':
  path => '/usr/bin:/usr/sbin:/bin'
}
