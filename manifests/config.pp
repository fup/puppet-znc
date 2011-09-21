class znc::config(
  $auth_type,
  $ssl,
  $organizationName,
  $localityName,
  $stateOrProvinceName,
  $countryName,
  $emailAddress,
  $commonName,
  $port
) {
  File {
    owner => znc,
    group => znc,
    mode  => '0644',
  }
  Exec {
    path => '/bin:/sbin:/usr/bin:/usr/sbin'
  }

  user { 'znc':
    ensure     => present,
    uid        => '400',
    gid        => '400',
    shell      => '/bin/bash',
    comment    => 'ZNC Service Account',
    managehome => 'true',
  }
  group { 'znc':
    ensure => present,
    gid    => '400',
  }
  file { '/etc/znc':
    ensure => directory,
  }
  file { '/etc/znc/configs':
    ensure => directory,
  }
  file { '/etc/znc/configs/users':
     ensure  => directory,
     purge   => true,
     recurse => true,
     notify  => Exec['remove-unmanaged-users'],
  }
  file { '/etc/znc/configs/znc.conf.header':
    ensure  => file,
    content => template('znc/etc/znc/configs/znc.conf.header.erb'),
  }
  file { '/etc/znc/configs/znc.conf':
    ensure  => file,
    require => Exec['initialize-znc-config'],
  }
  file { '/etc/init.d/znc':
    ensure => file,
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
    source => "puppet:///modules/znc/etc/init.d/znc.${znc::params::zc_suffix}",
  }
  file { '/etc/znc/configs/clean_users':
     ensure => file,
     owner  => 'root',
     group  => 'root',
     mode   => '0700',
     source => "puppet:///modules/znc/etc/znc/configs/clean_users",
  }  
  
  # Bootstrap SSL
  if $ssl == 'true' {
    file { '/etc/znc/ssl':
      ensure => directory,
      mode   => '0600',
    }
    file { '/etc/znc/bin':
      ensure => directory,
    }
    file { '/etc/znc/bin/generate_znc_ssl':
      ensure  => file,
      mode    => '0755',
      content => template('znc/etc/znc/bin/generate_znc_ssl.erb'),
      require => File['/etc/znc/ssl'],
    }
    file { '/etc/znc/znc.pem':
      ensure  => 'file',
      mode    => '0600',
      require => Exec['create-self-signed-znc-ssl'],
    }
    exec { 'create-self-signed-znc-ssl':
      command => '/etc/znc/bin/generate_znc_ssl',
      creates => '/etc/znc/znc.pem',
    }
  }
  
  # Bootstrap config files
  exec { 'initialize-znc-config':
    command => 'cat /etc/znc/configs/znc.conf.header > /etc/znc/configs/znc.conf',
    creates => '/etc/znc/configs/znc.conf',
    require => File['/etc/znc/configs/znc.conf.header'],
  }
  exec { 'remove-unmanaged-users':
     command     => '/etc/znc/configs/clean_users',
     refreshonly => 'true',
     require     => File['/etc/znc/configs/clean_users'],
  }
  znc::user { $znc::params::znc_admins: admin => 'true', }
  znc::user { $znc::params::znc_users: }
}
