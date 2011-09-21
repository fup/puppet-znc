class znc(
  $auth_type = 'plain'
) {
  include stdlib
  include znc::params
  if $auth_type == 'sasl' { include saslauthd }

  ### Begin Flow Logic ###
  anchor { 'znc::begin': }
  -> class { 'znc::package': }
  -> class { 'znc::config': 
       auth_type = $auth_type,
     }
  ~> class { 'znc::service': }
  -> anchor { 'znc::end': }
}
