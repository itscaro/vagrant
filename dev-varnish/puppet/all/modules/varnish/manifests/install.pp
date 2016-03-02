class varnish::install {

  file { '/etc/apt/sources.list.d/varnish.list':
    ensure   => 'present',
    source   => "puppet:///modules/varnish/varnish.list",
    before   => Exec['varnish_add_key'],
  }

  exec { 'varnish_add_key':
    unless  => 'apt-key list | grep varnish-cache.org',
    command => "curl https://repo.varnish-cache.org/debian/GPG-key.txt | apt-key add - && apt-get update",
    path    => ["/usr/bin", "/usr/sbin", "/bin"],
    require => Package['curl', 'apt-transport-https'],
  }

  package { ['apt-transport-https']:
    ensure  => installed,
  }

  package { ['varnish']:
    ensure  => installed,
  }

}
