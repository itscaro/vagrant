class php::composer (
  $isEnabled = hiera('composer')
) {
  if $isEnabled {

    exec { 'install_composer':
      command => 'curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer',
      environment => ['HOME=/root'],
      path    => ["/usr/bin", "/usr/sbin", "/bin"],
      require => Package["curl"],
    }

  }
}
