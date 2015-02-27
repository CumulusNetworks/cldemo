# This class is so that all db sync's can be in the runtime stage after all of the installations have happened
class openstack::controller::db_sync {
  #glance db sync

  exec { '/usr/bin/touch /tmp/puppet_once_lock_glance_db_sync':
    creates => '/tmp/puppet_once_lock_glance_db_sync',
    notify  => Exec['/usr/bin/glance-manage db_sync'],
  }

  exec { '/usr/bin/glance-manage db_sync':
    user        => 'glance',
    refreshonly => true,
    logoutput   => true,
    require     => Exec['/usr/bin/touch /tmp/puppet_once_lock_glance_db_sync'],
  }

  # workaround to only execute keystone db sync once
  exec { '/usr/bin/touch /tmp/puppet_once_lock_keystone_db_sync':
    creates => '/tmp/puppet_once_lock_keystone_db_sync',
    notify  => Exec['/usr/bin/keystone-manage db_sync'],
  }

  exec { '/usr/bin/keystone-manage db_sync':
    user        => 'keystone',
    refreshonly => true,
    require     => Exec['/usr/bin/touch /tmp/puppet_once_lock_keystone_db_sync'],
  }

}
