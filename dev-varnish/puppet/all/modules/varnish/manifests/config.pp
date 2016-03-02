class varnish::config(
  $varnish_port = hiera('varnish_port'),
  $apache_port = hiera('apache_port')
) {

  include ::systemd

  file { '/etc/systemd/system/varnish.service':
    ensure        => present,
    content       => template("varnish/varnish.service.erb"),
    require       => Class["varnish::install"],
    notify        => [Class["varnish::service"], Exec['systemctl-daemon-reload']],
  }

  file { '/etc/varnish/default.vcl':
    ensure        => present,
    content       => template("varnish/varnish.conf.erb"),
    require       => Class["varnish::install"],
    notify        => Class["varnish::service"],
  }

  file { '/etc/default/varnish':
    ensure        => present,
    content       => template("varnish/varnish.default.erb"),
    require       => Class["varnish::install"],
    before        => File['/etc/varnish/default.vcl'],
  }
}
