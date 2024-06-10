# Modify OS config to allow login to holberton

exec {'change-os-configuration-for-holberton-user-hard':
  command => 'sed -i s/5/5000/g /etc/security/limits.conf',
  path    => '/usr/bin:/usr/sbin:/bin'
}

exec {'change-os-configuration-for-holberton-user-soft':
  command => 'sed -i s/4/3000/g /etc/security/limits.conf',
  path    => '/usr/bin:/usr/sbin:/bin'
}
