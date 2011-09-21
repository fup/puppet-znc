
class znc(
  $auth_type           = '',
  $ssl                 = '',
  $organizationName    = '',
  $localityName        = '',
  $stateOrProvinceName = '',
  $countryName         = '',
  $emailAddress        = '',
  $commonName          = '',
  $port                = ''
) {
  include stdlib
  include znc::params
  if $auth_type == 'sasl' { include saslauthd }
  
  ### Begin Parameter Setting ###
  if $auth_type == '' { $REAL_auth_type = $znc::params::zc_auth_type }
  else { $REAL_auth_type = $auth_type }
  
  if $ssl == '' { $REAL_ssl = $znc::params::zc_ssl }
  else { $REAL_ssl = $ssl }
  
  if $port == '' { $REAL_port = $znc::params::zc_port }
  else { $REAL_port = $port }

  # Make sure that all of the SSL parameters are filled out.
  if ($ssl == 'true') and 
    ($organizationName == '' or
     $localityName == '' or 
     $stateOrProvinceName == '' or 
     $countryName == '' or 
     $emailAddress == '' or 
     $commonName == '') 
  {
    fail("Missing Parameters to generate an SSL Certificate")   
  }

  ### Begin Flow Logic ###
  anchor { 'znc::begin': }
  -> class { 'znc::package': }
  -> class { 'znc::config': 
       auth_type           => $REAL_auth_type,
       ssl                 => $REAL_ssl,
       organizationName    => $organizationName,
       localityName        => $localityName,
       stateOrProvinceName => $stateOrProvinceName,
       countryName         => $countryName,
       emailAddress        => $emailAddress,
       commonName          => $commonName,
       port                => $REAL_port,
     }
  ~> class { 'znc::service': }
  -> anchor { 'znc::end': }
}