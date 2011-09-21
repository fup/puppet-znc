class znc::service {
  service { 'znc':
    ensure  => 'running',
    enable  => 'true',
  }
}
