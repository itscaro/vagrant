class base (
	$php_version = hiera('php_version')
) {
  info ( "PHP Version $php_version" )

  if ($php_version == 5.5) or ($php_version == 5.6) or ($php_version == 7.0) {

	  # add dotdeb repo to sources.list.d
	  file { '/etc/apt/sources.list.d/dotdeb.list':
	    ensure   => 'present',
	    source   => "puppet:///modules/base/dotdeb.list",
			before   => Exec['dotdeb_add_key'],
		}

		exec { 'dotdeb_add_key':
			unless  => 'apt-key list | grep dotdeb.org',
			command => "curl http://www.dotdeb.org/dotdeb.gpg | apt-key add - && apt-get update",
			path    => ["/usr/bin", "/usr/sbin", "/bin"],
			require => Package['curl'],
		}

  }

  package { 'curl':
    ensure => 'installed',
  }

}
