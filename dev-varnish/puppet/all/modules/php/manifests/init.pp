class php(
  $php_version = hiera('php_version'),
  $php_extensions = hiera('php_extensions'),
  $php = hiera('php'),
) {

  if $php_version == 7.0 {
    # PHP 7.0
    $phpPackageName = "php$php_version"
    $phpIniPathServerWeb = "/etc/php/7.0/apache2/php.ini"
    $phpIniPathCli = "/etc/php/7.0/cli/php.ini"
  } else {
    # PHP 5.x
    $phpPackageName = 'php5'
    $phpIniPathServerWeb = "/etc/php5/apache2/php.ini"
    $phpIniPathCli = "/etc/php5/cli/php.ini"
  }
  $_extensions = $php_extensions.map |$item| { "$phpPackageName-$item" }

  package { $phpPackageName:
    ensure  => present,
    require => Package["apache2"],
  }

  package { $_extensions:
    ensure  => present,
    require => Package[$phpPackageName],
  }

  exec { "enabledphp":
    command => "a2enmod $phpPackageName",
    path    => ["/usr/bin", "/usr/sbin", "/bin"],
    require => Package[$phpPackageName, "apache2"],
  }

  package { "libapache2-mod-$phpPackageName":
    ensure  => present,
    require => Package[$phpPackageName, "apache2"],
  }

  file { $phpIniPathServerWeb:
    ensure     => file,
    content    => template("php/php.ini.erb"),
    notify     => Service["apache2"],
    require    => Package[$phpPackageName],
  }

  file { $phpIniPathCli:
    ensure     => file,
    content    => template("php/php.cli.ini.erb"),
    require    => Package[$phpPackageName],
  }

  include php::symfony, php::composer
}
