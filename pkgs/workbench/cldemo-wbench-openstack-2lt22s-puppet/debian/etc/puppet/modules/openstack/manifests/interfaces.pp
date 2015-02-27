class openstack::interfaces {
  file { '/etc/network/interfaces':
    ensure => present,
    mode   => '0644',
    owner  => 'root',
    group  => 'root',
    source => "puppet:///modules/openstack/interfaces_${::hostname}"
  }

  if $::operatingsystem == 'CumulusLinux' {
    exec { '/sbin/ifreload -a':
        subscribe   => File['/etc/network/interfaces'],
        refreshonly => true,
    }
  }
  else {
    exec { "/sbin/ifdown --exclude=lo -a && /sbin/ifup --exclude=lo -a":
        subscribe   => File['/etc/network/interfaces'],
        refreshonly => true,
    }

    exec { '/sbin/ip link set dev eth2 up; /sbin/ip link set dev eth3 up':
        require   => File['/etc/network/interfaces/'],
        logoutput => on_failure,
        }

    exec { '/sbin/ifup bond0':
        logoutput => on_failure,
        require   => Exec['/sbin/ip link set dev eth2 up; /sbin/ip link set dev eth3 up']
        }

  }
}
