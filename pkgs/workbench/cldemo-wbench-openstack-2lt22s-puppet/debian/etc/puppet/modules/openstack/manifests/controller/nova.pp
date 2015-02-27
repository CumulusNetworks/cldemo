# This class is for nova compute and nova-network
class openstack::controller::nova {

  mysql::db { 'nova':
    user     => 'nova',
    password => 'cn321',
    host     => '%',
    grant    => 'ALL',
  } ->

  package { [ 'nova-api',
              'nova-cert',
              'nova-conductor',
              'nova-consoleauth',
              'nova-novncproxy',
              'nova-scheduler',
              'python-novaclient',
              'nova-compute-kvm',
              'nova-network',
              'vlan',
              'ifenslave', ]:
    ensure  => installed,
  }

  file { '/var/lib/nova/nova.sqlite':
    ensure  => absent,
    require => Package['nova-api'],
    notify  => Service[ ['nova-api',
                      'nova-cert',
                      'nova-consoleauth',
                      'nova-scheduler',
                      'nova-conductor',
                      'nova-novncproxy',
                      'nova-compute', ] ],
  }

  file { '/etc/nova/nova.conf':
    ensure  => present,
    owner   => 'nova',
    group   => 'nova',
    mode    => '0644',
    source  => 'puppet:///modules/openstack/nova.conf.controller',
    require => Package['nova-api'],
    notify  => Service[ ['nova-api',
                      'nova-cert',
                      'nova-consoleauth',
                      'nova-scheduler',
                      'nova-conductor',
                      'nova-novncproxy',
                      'nova-compute',
                      'nova-network', ] ],

  }

# workaround to only execute nova-compute db sync once
exec { '/usr/bin/touch /tmp/puppet_once_lock_nova_compute_db_sync':
  creates => '/tmp/puppet_once_lock_nova_compute_db_sync',
  notify  => Exec['/usr/bin/nova-manage db sync'],
}

exec { '/usr/bin/nova-manage db sync':
  user        => 'nova',
  refreshonly => true,
  logoutput   => true,
  require     => Exec['/usr/bin/touch /tmp/puppet_once_lock_nova_compute_db_sync'],
}
  service { [ 'nova-api',
              'nova-cert',
              'nova-consoleauth',
              'nova-scheduler',
              'nova-conductor',
              'nova-novncproxy',
              'nova-compute',
              'nova-network', ]:
    ensure     => running,
    hasstatus  => true,
    hasrestart => true,
    require    => Package[ ['nova-api',
                            'nova-cert',
                            'nova-conductor',
                            'nova-consoleauth',
                            'nova-novncproxy',
                            'nova-scheduler',
                            'python-novaclient',
                            'nova-compute-kvm', ] ],
  }


}
