node 'wbench.lab.local' {

}

# controller and computer node
# TODO make into a role class

node 'server1.lab.local' {

  include openstack::role::controller

  class { 'openstack::interfaces':
    stage => 'setup',
  }
}

node 'server2.lab.local' {

  include openstack::role::compute

  class { 'openstack::interfaces':
    stage => 'setup',
  }
}

node 'spine1.lab.local' {

    include base::role::switch,
    openstack::interfaces,
    base::ptm

  class { 'openstack::mlag':
    peer_ip => '169.254.99.2',
    sys_mac => '44:38:39:ff:00:01',
  }
}

node 'spine2.lab.local' {

    include base::role::switch,
    openstack::interfaces,
    base::ptm

  class { 'openstack::mlag':
    peer_ip => '169.254.99.1',
    sys_mac => '44:38:39:ff:00:01',
  }
}

node 'leaf1.lab.local' {

    include base::role::switch,
    openstack::interfaces,
    base::ptm

  class { 'openstack::mlag':
    peer_ip => '169.254.99.2',
    sys_mac => '44:38:39:ff:00:02',
  }

  class { 'openstack::portsconf':
    switchtype => '40G',
    stage      => 'setup',
  }
}

node 'leaf2.lab.local' {

  include base::role::switch,
  openstack::interfaces,
  base::ptm

  class { 'openstack::mlag':
    peer_ip => '169.254.99.1',
    sys_mac => '44:38:39:ff:00:02',
  }

  class { 'openstack::portsconf':
    switchtype => '40G',
    stage      => 'setup',
  }
}
