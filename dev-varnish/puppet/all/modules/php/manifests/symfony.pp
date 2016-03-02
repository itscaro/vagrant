class php::symfony (
  $isEnabled = hiera('symfony')
) {
  if $isEnabled {

    exec { 'install_symfony':
      command => 'curl -LsS https://symfony.com/installer -o /usr/local/bin/symfony && chmod a+x /usr/local/bin/symfony',
      path    => ["/usr/bin", "/usr/sbin", "/bin"],
      require => Package["curl"],
    }

  }
}
