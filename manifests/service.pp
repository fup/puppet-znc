class znc::service {
  service { 'znc':
    ensure  => 'running',
    enabled => 'true',
  }
}
