# Modifies the server to hadle more request volume

exec { 'Modify max open file':
  command => 'sed -i s/15/1024/g /etc/default/nginx && service nginx restart',
  path    => '/usr/bin:/usr/sbin:/bin'
}
