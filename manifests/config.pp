class znc::config(
  $auth_type
) {
  File {
    owner => znc,
    group => znc,
    mode  => '0644',
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
  file { '/etc/znc/configs/znc.conf.header':
    ensure => file,
    source => 'puppet:///modules/znc/etc/znc/configs/znc.conf.header',
  }
  file { '/etc/znc/configs/znc.conf.seed':
    ensure  => file,
    content => template('znc/etc/znc/configs/znc.conf.seed.erb'),
  }
  file { '/etc/init.d/znc':
    ensure => file,
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
    source => "puppet:///modules/znc/etc/init.d/znc.${znc::params::zc_suffix}",
  }
}
