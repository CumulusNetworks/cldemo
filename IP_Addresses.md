# Demo IP Addressing

All demos should use these IP assignments, the same as the [Cumulus CL101](https://support.cumulusnetworks.com/hc/en-us/articles/201956333-Cumulus-Linux-101) lab guide.

### Assignments

Various [RFC1918](http://tools.ietf.org/html/rfc1918) allocations.

IPv6 using the [RFC3849](http://tools.ietf.org/html/rfc3849) assigned IPv6 address prefix reserved for documentation: 2001:db8::/32


| Network               | IPv4                 | IPv6                 |
|-----------------------|----------------------|----------------------|
| Management            | 192.168.0.0/24       | 2001:db8:1::/48      |
| Production / underlay | 10.0.0.0/12          | 2001:db8:2::/48      |
| Overlays              | 172.16.0.0/16        | 2001:db8:3::/48      |


## Management network

192.168.0.0/24

2001:db8:1::/48

DHCP Pool - 192.168.0.100 - 192.168.0.200

| Device  | Interface | IPv4           | IPv6             | Type             |
|---------|-----------|----------------|------------------|------------------|
| wbench  | eth1      | 192.168.0.1    |                  | Static           |
| server1 | IPMI      | 192.168.0.3    |                  | Static           |
| server2 | IPMI      | 192.168.0.4    |                  | Static           |
| leaf1   | eth1      | 192.168.0.11   |                  | DHCP Reservation |
| spine1  | eth1      | 192.168.0.12   |                  | DHCP Reservation |
| leaf2   | eth1      | 192.168.0.13   |                  | DHCP Reservation |
| spine2  | eth1      | 192.168.0.14   |                  | DHCP Reservation |
| server1 | eth0      | 192.168.0.201  |                  | DHCP Reservation |
| server2 | eth0      | 192.168.0.201  |                  | DHCP Reservation |

## Production / underlay

10.0.0.0/12

2001:db8:2::/48

| Network                   | IPv4        | IPv6                 |
|---------------------------|-------------|----------------------|
| Loopbacks                 | 10.2.0.0/16 | 2001:db8:2:2000::/52 |
| Host facing bridges/VLANs | 10.4.0.0/16 | 2001:db8:2:4000::/52 |
| Points to points          | 10.1.0.0/16 | 2001:db8:2:1000::/52 |


## Production / underlay

10.0.0.0/12

2001:db8:2::/48

| Network                   | IPv4        | IPv6                 |
|---------------------------|-------------|----------------------|
| Loopbacks                 | 10.2.0.0/16 | 2001:db8:2:2000::/52 |
| Host facing bridges/VLANs | 10.4.0.0/16 | 2001:db8:2:4000::/52 |
| Points to points          | 10.1.0.0/16 | 2001:db8:2:1000::/52 |


### Loopbacks

10.2.0/16, all /32's

2001:db8:2:2000::/52, all /128s

#### Management loopbacks

10.2.1.0/24

2001:db8:2:2000:1::/80

| Device  | Interface | IPv4           | IPv6                   |
|---------|-----------|----------------|------------------------|
| leaf1   | lo        | 10.2.1.1/32    | 2001:db8:2:2000:1::1/128 |
| leaf2   | lo        | 10.2.1.2/32    | 2001:db8:2:2000:1::2/128 |
| spine1  | lo        | 10.2.1.3/32    | 2001:db8:2:2000:1::3/128 |
| spine2  | lo        | 10.2.1.4/32    | 2001:db8:2:2000:1::4/128 |
| server1 | lo        | 10.2.1.5/32    | 2001:db8:2:2000:1::5/128 |
| server2 | lo        | 10.2.1.6/32    | 2001:db8:2:2000:1::6/128 |

#### Service loopbacks

10.2.2.0/24

2001:db8:2:2000:2::/80

| Device(s)         | Interface | IPv4           | IPv6                     |
|-------------------|-----------|----------------|--------------------------|
| LNV anycast       | lo        | 10.2.2.1/32    | 2001:db8:2:2000:2::1/128 |
| Host anycast VIP1 | lo        | 10.2.2.2/32    | 2001:db8:2:2000:2::2/128 |
| Host anycast VIP1 | lo        | 10.2.2.2/32    | 2001:db8:2:2000:2::3/128 |



### Host facing bridges/VLANs

10.4.0.0/16, normally /25s

2001:db8:2:4000::/52, all /64s

`2001:0db8:0002:4000:0000:0000:0000:0000`

`2001:0db8:0002:4fff:ffff:ffff:ffff:ffff`

| Device  | Interface | IPv4           | IPv6                  |
|---------|-----------|----------------|-----------------------|
| leaf1   | br0       | 10.4.1.0/25    | 2001:db8:2:4001::1/64 |
| leaf2   | br1       | 10.4.1.128/25  | 2001:db8:2:4002::1/64 |
| leaf1   | br0       | 10.4.2.0/25    | 2001:db8:2:4003::1/64 |
| leaf2   | br1       | 10.4.2.128/25  | 2001:db8:2:4004::1/64 |

### Point to points

10.1.1.0/16, /30's

2001:db8:2:1000::/52, all /112s

`2001:0db8:0002:1000:0000:0000:0000:0000`

`2001:0db8:0002:1fff:ffff:ffff:ffff:ffff`

| Topology | IPv4 subnet  | IPv6 subnet | Device A | Device B | Interface A | Interface B |
|----------|--------------|-------------|----------|----------|-------------|-------------|
| 2s       | 10.1.1.0/30  |             | leaf1    | leaf2    | swp1        | swp1        |
| 2s       | 10.1.1.4/30  |             | leaf1    | leaf2    | swp2        | swp2        |
| 2s       | 10.1.1.8/30  |             | leaf1    | leaf2    | swp3        | swp3        |
| 2s       | 10.1.1.12/30 |             | leaf1    | leaf2    | swp4        | swp4        |
| 2lt22s   | 10.1.1.0/30  |             | leaf1    | spine1   | swp1s0      | swp49       |
| 2lt22s   | 10.1.1.4/30  |             | leaf1    | spine1   | swp1s1      | swp50       |
| 2lt22s   | 10.1.1.8/30  |             | leaf2    | spine2   | swp1s0      | swp49       |
| 2lt22s   | 10.1.1.12/30 |             | leaf2    | spine2   | swp1s1      | swp50       |
| 2lt22s   | 10.1.1.16/30 |             | leaf1    | spine2   | swp1s2      | swp51       |
| 2lt22s   | 10.1.1.20/30 |             | leaf1    | spine2   | swp1s3      | swp52       |
| 2lt22s   | 10.1.1.24/30 |             | leaf2    | spine1   | swp1s2      | swp51       |
| 2lt22s   | 10.1.1.28/30 |             | leaf2    | spine1   | swp1s3      | swp52       |
| 2lt22s   | 10.1.1.32/30 |             | leaf1    | leaf2    | swp17       | swp17       |
| 2lt22s   | 10.1.1.36/30 |             | leaf2    | leaf2    | swp18       | swp18       |
| 2lt22s   | 10.1.1.40/30 |             | spine1   | spine1   | swp17       | swp17       |
| 2lt22s   | 10.1.1.44/30 |             | spine2   | spine22  | swp18       | swp18       |
| 2lt22s   | 10.1.1.48/30 |             | leaf1    | server1  | swp32s0     | eth3        |
| 2lt22s   | 10.1.1.52/30 |             | leaf1    | server2  | swp32s1     | eth2        |
| 2lt22s   | 10.1.1.56/30 |             | leaf2    | server2  | swp32s0     | eth3        |
| 2lt22s   | 10.1.1.60/30 |             | leaf2    | server1  | swp32s1     | eth2        |


## Overlays

172.16.0.0/16

2001:db8:3::/48

| Topology | IPv4 subnet  | IPv6 subnet | Device A | Device B | Interface A | Interface B | IPv4 A    | IPv4 B    | IPv6 A | IPv6 B |
|----------|--------------|-------------|----------|----------|-------------|-------------|-----------|-----------|--------|--------|
| VXLAN demo| 172.16.0.0/25|             | server1  | server2  | ethX        | ethX        | 172.16.0.1| 172.16.0.2|        |        |





