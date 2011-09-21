class znc::package {
  package { $znc::params::zc_packages: 
    ensure => present
  }
}