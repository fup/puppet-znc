define znc::user(
  $admin = 'false'
) {
  File {
    owner => 'root',
    group => 'root',
    mode  => '0600',
  }
  Exec { 
    path => '/bin:/sbin:/usr/bin:/usr/sbin',
  }
  
  file { "/etc/znc/configs/users/${name}":
    ensure  => file,
    content => template('znc/etc/znc/configs/znc.conf.seed.erb'),
    before  => Exec["add-znc-user-${name}"],
  } 
  exec { "add-znc-user-${name}":
    command => "cat /etc/znc/configs/users/${name} >> /etc/znc/configs/znc.conf",
    unless  => "grep ${name} /etc/znc/configs/znc.conf",
    require => Exec['initialize-znc-config'],
    notify  => Service['znc'],
  }
}