class znc::params {  
  case $::operatingsystem {
    redhat,fedora,centos: {
      $zc_suffix   = 'redhat'
      $zc_packages = ['znc', 'znc-extra'] 
    }
  }
  
  $zc_auth_type = 'plain'
  $zc_ssl       = 'false'
  $zc_port      = '8080'
  
  # Need to move into LDAP?
  $znc_admins = ['jfryman', 'ashamim']
  $znc_users  = ['spenclk']
}
