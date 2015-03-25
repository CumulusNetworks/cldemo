class monitoring::gangliawebhost {
  package { [ 'apache2', 'libapache2-mod-php5', 'rrdtool' ]:
    ensure => installed
  }

  service { 'apache2':
    ensure     => running,
    enable     => true,
    hasrestart => true,
    require    => Package['apache2'],
  }

  file { '/etc/apache2/sites-available/ganglia.lab.local.conf':
    ensure  => present,
    owner   => 'www-data',
    group   => 'www-data',
    mode    => '0644',
    content => template('monitoring/ganglia.lab.local.conf.erb'),
    notify  => Service['apache2'],
  }

  file { '/etc/apache2/sites-enabled/ganglia.lab.local.conf':
    ensure  => link,
    target  => '/etc/apache2/sites-available/ganglia.lab.local.conf',
    require => File['/etc/apache2/sites-available/ganglia.lab.local.conf'],
  }

  file { '/var/www/index.html':
    ensure  => present,
    owner   => 'www-data',
    group   => 'www-data',
    mode    => '0644',
    content => template('monitoring/index.html.erb'),
    notify  => Service['apache2']
  }

  file { '/etc/apache2/sites-enabled/15-default.conf':
    ensure => absent,
    notify => Service['apache2']
  }

  file { '/etc/apache2/sites-enabled/000-default':
    ensure => absent,
    notify => Service['apache2']
  }

  file { [ '/var/lib/ganglia-web/', '/var/lib/ganglia-web/dwoo/' , '/var/lib/ganglia-web/dwoo/compiled' , '/var/lib/ganglia-web/dwoo/cache' ]:
    ensure => directory,
    owner  => 'www-data',
    group  => 'www-data',
    mode   => '0755',
  }

  file { '/var/www/ganglia-web/':
    ensure  => directory,
    recurse => true,
    owner   => 'www-data',
    group   => 'www-data',
  }

  package { 'gmetad' :
    ensure => installed
  }

  service { 'gmetad':
    ensure     => running,
    enable     => true,
    hasstatus  => false,
    hasrestart => true,
  }

  file { '/etc/ganglia/gmetad.conf':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('monitoring/gmetad.conf.erb'),
    notify  => Service['gmetad']
  }
}
