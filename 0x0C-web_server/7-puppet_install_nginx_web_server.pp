# Installs and configures an nginx server

exec { 'update packages':
  command => 'sudo apt-get update',
  path    => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
}

package { 'nginx':
  ensure   => installed,
  provider => 'apt',
}

exec { 'mkdir_html':
  command => 'mkdir -p /var/www/html/',
  path    => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
}

exec { 'chmod_html':
  command => 'sudo chmod -R 755 /var/www',
  path    => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
}

exec { 'create_sites-available':
  command => 'mkdir -p /etc/nginx/sites-available/',
  path    => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
}

file { '/var/www/html/index.html':
  content => 'Hello World!',
}

exec { 'config':
  path    => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
  command => 'sudo echo -e "server {\n\t\tlisten 80 default_server;\n\t\tlisten [::]:80 default_server;\n\n\t\troot /var/www/html;\n\t\tindex index.html index.htm index.nginx-debian.html;\n\t\tserver_name _;\n\t\tlocation / {\n\t\ttry_files \$uri \$uri/ =404;\n\t\t}\n\t\trewrite ^/redirect_me(.*)$ http://www.youtube.com/ permanent;\n}" > /etc/nginx/sites-available/default'
}

service { 'service-mamager':
  ensure => running,
  name   => 'nginx',
}

exec {'restart':
  command => 'sudo service nginx restart',
  path    => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
}
