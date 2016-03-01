class php::composer (
  $isEnabled = hiera('composer')
) {
  if $isEnabled {
    notify { "Installation of Composer": }

    exec { 'install_composer':
      command => 'curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer',
      path    => ["/usr/bin", "/usr/sbin", "/bin"],
      require => Package["curl", "php5"],
    }

  }
}
