node 'spine1.lab.local' {
    $int_enabled = true
    $int_loopback = '10.2.1.3'
    $int_layer3 = {
        swp49  => { 'address' => '10.1.1.2', 'netmask' => '255.255.255.252', 'cidr_netmask' => 30 },
        swp50  => { 'address' => '10.1.1.6', 'netmask' => '255.255.255.252', 'cidr_netmask' => 30 },
        swp51  => { 'address' => '10.1.1.50', 'netmask' => '255.255.255.252', 'cidr_netmask' => 30 },
        swp52  => { 'address' => '10.1.1.54', 'netmask' => '255.255.255.252', 'cidr_netmask' => 30 }
    }
    $int_bridges = { }
    $bgp = {
        myasn => 65000,
        peergroupv4 => [ {
          name  => 'leafs',
          asn   => 65000,
          peers => [ '10.1.1.1','10.1.1.5','10.1.1.49','10.1.1.53' ]
        } ]
    }

    include ibgp::role::switchbase
}

node 'spine2.lab.local' {
    $int_enabled = true
    $int_loopback = '10.2.1.4'
    $int_layer3 = {
        swp49 => { 'address' => '10.1.1.18', 'netmask' => '255.255.255.252', 'cidr_netmask' => 30 },
        swp50 => { 'address' => '10.1.1.22', 'netmask' => '255.255.255.252', 'cidr_netmask' => 30 },
        swp51 => { 'address' => '10.1.1.34', 'netmask' => '255.255.255.252', 'cidr_netmask' => 30 },
        swp52 => { 'address' => '10.1.1.38', 'netmask' => '255.255.255.252', 'cidr_netmask' => 30 }
    }
    $int_bridges = { }
    $bgp = {
        myasn => 65000,
        peergroupv4 => [ {
          name  => 'leafs',
          asn   => 65000,
          peers => [ '10.1.1.17','10.1.1.21','10.1.1.33','10.1.1.37' ]
        } ]
    }

    include ibgp::role::switchbase
}

node 'leaf1.lab.local' {
    $int_enabled = true
    $int_loopback = '10.2.1.1'
    $int_layer3 = {
        swp1s0 => { 'address' => '10.1.1.1', 'netmask' => '255.255.255.252', 'cidr_netmask' => 30 },
        swp1s1 => { 'address' => '10.1.1.5', 'netmask' => '255.255.255.252', 'cidr_netmask' => 30 },
        swp1s2 => { 'address' => '10.1.1.33', 'netmask' => '255.255.255.252', 'cidr_netmask' => 30 },
        swp1s3 => { 'address' => '10.1.1.37', 'netmask' => '255.255.255.252', 'cidr_netmask' => 30 }
    }
    $int_bridges = {
        br0 => { 'address' => '10.4.1.1', 'netmask' => '255.255.255.128', 'cidr_netmask' => 25 , 'members' => ['swp32s0'] },
        br1 => { 'address' => '10.4.1.129', 'netmask' => '255.255.255.128', 'cidr_netmask' => 25, 'members' => ['swp32s1'] }
    }
    $bgp = {
        myasn => 65000,
        peergroupv4 => [ {
          name  => 'spines',
          asn   => 65000,
          peers => [ '10.1.1.2','10.1.1.6','10.1.1.34','10.1.1.38' ]
        } ]
    }

    include ibgp::role::switchbase
    class { 'portsconf' :
      switchtype => '40G',
      stage      => 'setup',
    }
}

node 'leaf2.lab.local' {
    $int_enabled = true
    $int_loopback = '10.2.1.2'
    $int_layer3 = {
        swp1s0 => { 'address' => '10.1.1.17', 'netmask' => '255.255.255.252', 'cidr_netmask' => 30 },
        swp1s1 => { 'address' => '10.1.1.21', 'netmask' => '255.255.255.252', 'cidr_netmask' => 30 },
        swp1s2 => { 'address' => '10.1.1.49', 'netmask' => '255.255.255.252', 'cidr_netmask' => 30 },
        swp1s3 => { 'address' => '10.1.1.53', 'netmask' => '255.255.255.252', 'cidr_netmask' => 30 }
    }
    $int_bridges = {
        br0 => { 'address' => '10.4.2.1', 'netmask' => '255.255.255.128', 'cidr_netmask' => 25, 'members' => ['swp32s0'] },
        br1 => { 'address' => '10.4.2.129', 'netmask' => '255.255.255.128', 'cidr_netmask' => 25, 'members' => ['swp32s1'] }
    }
    $bgp = {
        myasn => 65000,
        peergroupv4 => [ {
          name  => 'spines',
          asn   => 65000,
          peers => [ '10.1.1.18','10.1.1.22','10.1.1.50','10.1.1.54']
        } ]
    }

    include ibgp::role::switchbase
    class { 'portsconf' :
      switchtype => '40G',
      stage      => 'setup',
    }
}
