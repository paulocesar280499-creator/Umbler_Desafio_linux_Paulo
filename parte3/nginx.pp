package { 'nginx':
  ensure => installed,
}

file { '/etc/nginx/nginx.conf':
  ensure => file,
  owner  => 'root',
  group  => 'root',
  mode   => '0644',
  notify => Service['nginx'],
}

service { 'nginx':
  ensure => running,
  enable => true,
}
