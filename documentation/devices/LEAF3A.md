# LEAF3A
# Table of Contents

- [Management](#management)
  - [Management Interfaces](#management-interfaces)
  - [Name Servers](#name-servers)
  - [NTP](#ntp)
  - [Management API HTTP](#management-api-http)
- [Authentication](#authentication)
  - [Local Users](#local-users)
  - [AAA Authorization](#aaa-authorization)
- [Monitoring](#monitoring)
- [MLAG](#mlag)
  - [MLAG Summary](#mlag-summary)
  - [MLAG Device Configuration](#mlag-device-configuration)
- [Spanning Tree](#spanning-tree)
  - [Spanning Tree Summary](#spanning-tree-summary)
  - [Spanning Tree Device Configuration](#spanning-tree-device-configuration)
- [Internal VLAN Allocation Policy](#internal-vlan-allocation-policy)
  - [Internal VLAN Allocation Policy Summary](#internal-vlan-allocation-policy-summary)
  - [Internal VLAN Allocation Policy Configuration](#internal-vlan-allocation-policy-configuration)
- [VLANs](#vlans)
  - [VLANs Summary](#vlans-summary)
  - [VLANs Device Configuration](#vlans-device-configuration)
- [Interfaces](#interfaces)
  - [Ethernet Interfaces](#ethernet-interfaces)
  - [Port-Channel Interfaces](#port-channel-interfaces)
  - [VLAN Interfaces](#vlan-interfaces)
- [Routing](#routing)
  - [Service Routing Protocols Model](#service-routing-protocols-model)
  - [IP Routing](#ip-routing)
  - [IPv6 Routing](#ipv6-routing)
  - [Static Routes](#static-routes)
- [Multicast](#multicast)
  - [IP IGMP Snooping](#ip-igmp-snooping)
- [Filters](#filters)
- [ACL](#acl)
- [VRF Instances](#vrf-instances)
  - [VRF Instances Summary](#vrf-instances-summary)
  - [VRF Instances Device Configuration](#vrf-instances-device-configuration)
- [Quality Of Service](#quality-of-service)

# Management

## Management Interfaces

### Management Interfaces Summary

#### IPv4

| Management Interface | description | Type | VRF | IP Address | Gateway |
| -------------------- | ----------- | ---- | --- | ---------- | ------- |
| Management0 | oob_management | oob | MGMT | 172.100.100.106/24 | 172.100.100.1 |
| Vlan10 | L2LEAF_INBAND_MGMT | inband | default | 10.10.10.9/24 | 10.10.10.1 |

#### IPv6

| Management Interface | description | Type | VRF | IPv6 Address | IPv6 Gateway |
| -------------------- | ----------- | ---- | --- | ------------ | ------------ |
| Management0 | oob_management | oob | MGMT | - | - |
| Vlan10 | L2LEAF_INBAND_MGMT | inband | default | - | - |

### Management Interfaces Device Configuration

```eos
!
interface Management0
   description oob_management
   no shutdown
   vrf MGMT
   ip address 172.100.100.106/24
!
interface Vlan10
   description L2LEAF_INBAND_MGMT
   no shutdown
   mtu 1500
   ip address 10.10.10.9/24
```

## Name Servers

### Name Servers Summary

| Name Server | Source VRF |
| ----------- | ---------- |
| 8.8.4.4 | MGMT |
| 8.8.8.8 | MGMT |

### Name Servers Device Configuration

```eos
ip name-server vrf MGMT 8.8.4.4
ip name-server vrf MGMT 8.8.8.8
```

## NTP

### NTP Summary

#### NTP Servers

| Server | VRF | Preferred | Burst | iBurst | Version | Min Poll | Max Poll | Local-interface | Key |
| ------ | --- | --------- | ----- | ------ | ------- | -------- | -------- | --------------- | --- |
| pool.ntp.org | MGMT | - | - | - | - | - | - | - | - |
| time.google.com | MGMT | True | - | - | - | - | - | - | - |

### NTP Device Configuration

```eos
!
ntp server vrf MGMT pool.ntp.org
ntp server vrf MGMT time.google.com prefer
```

## Management API HTTP

### Management API HTTP Summary

| HTTP | HTTPS | Default Services |
| ---- | ----- | ---------------- |
| False | True | - |

### Management API VRF Access

| VRF Name | IPv4 ACL | IPv6 ACL |
| -------- | -------- | -------- |
| MGMT | - | - |

### Management API HTTP Configuration

```eos
!
management api http-commands
   protocol https
   no shutdown
   !
   vrf MGMT
      no shutdown
```

# Authentication

## Local Users

### Local Users Summary

| User | Privilege | Role |
| ---- | --------- | ---- |
| admin | 15 | network-admin |

### Local Users Device Configuration

```eos
!
username admin privilege 15 role network-admin secret sha512 $6$zMFtJNDCdXNd5rQ9$2.P8pfwopGK6NmRYubumSRhgT.ee6vcqaDfvN9VFyFIGhewx3uAVxE4n.M8wvlN3SSkjYtRLO8XLklr5R/nAg/
```

## AAA Authorization

### AAA Authorization Summary

| Type | User Stores |
| ---- | ----------- |
| Exec | local |

Authorization for configuration commands is disabled.

### AAA Authorization Device Configuration

```eos
aaa authorization exec default local
!
```

# Monitoring

# MLAG

## MLAG Summary

| Domain-id | Local-interface | Peer-address | Peer-link |
| --------- | --------------- | ------------ | --------- |
| IDF3_AGG | Vlan4094 | 192.168.0.11 | Port-Channel983 |

Dual primary detection is disabled.

## MLAG Device Configuration

```eos
!
mlag configuration
   domain-id IDF3_AGG
   local-interface Vlan4094
   peer-address 192.168.0.11
   peer-link Port-Channel983
   reload-delay mlag 300
   reload-delay non-mlag 330
```

# Spanning Tree

## Spanning Tree Summary

STP mode: **mstp**

### MSTP Instance and Priority

| Instance(s) | Priority |
| -------- | -------- |
| 0 | 16384 |

### Global Spanning-Tree Settings

- Spanning Tree disabled for VLANs: **4094**

## Spanning Tree Device Configuration

```eos
!
spanning-tree mode mstp
no spanning-tree vlan-id 4094
spanning-tree mst 0 priority 16384
```

# Internal VLAN Allocation Policy

## Internal VLAN Allocation Policy Summary

| Policy Allocation | Range Beginning | Range Ending |
| ------------------| --------------- | ------------ |
| ascending | 1006 | 1199 |

## Internal VLAN Allocation Policy Configuration

```eos
!
vlan internal order ascending range 1006 1199
```

# VLANs

## VLANs Summary

| VLAN ID | Name | Trunk Groups |
| ------- | ---- | ------------ |
| 10 | L2LEAF_INBAND_MGMT | - |
| 310 | IDF3-Data | - |
| 320 | IDF3-Voice | - |
| 330 | IDF3-Guest | - |
| 4094 | MLAG_PEER | MLAG |

## VLANs Device Configuration

```eos
!
vlan 10
   name L2LEAF_INBAND_MGMT
!
vlan 310
   name IDF3-Data
!
vlan 320
   name IDF3-Voice
!
vlan 330
   name IDF3-Guest
!
vlan 4094
   name MLAG_PEER
   trunk group MLAG
```

# Interfaces

## Ethernet Interfaces

### Ethernet Interfaces Summary

#### L2

| Interface | Description | Mode | VLANs | Native VLAN | Trunk Group | Channel-Group |
| --------- | ----------- | ---- | ----- | ----------- | ----------- | ------------- |
| Ethernet97/1 | SPINE1_Ethernet50/1 | *trunk | *10,310,320,330 | *- | *- | 971 |
| Ethernet97/2 | SPINE2_Ethernet50/1 | *trunk | *10,310,320,330 | *- | *- | 971 |
| Ethernet97/3 | LEAF3C_Ethernet97/1 | *trunk | *10,310,320,330 | *- | *- | 973 |
| Ethernet97/4 | LEAF3D_Ethernet97/1 | *trunk | *10,310,320,330 | *- | *- | 974 |
| Ethernet98/1 | LEAF3E_Ethernet97/1 | *trunk | *10,310,320,330 | *- | *- | 981 |
| Ethernet98/3 | MLAG_PEER_LEAF3B_Ethernet98/3 | *trunk | *2-4094 | *- | *['MLAG'] | 983 |
| Ethernet98/4 | MLAG_PEER_LEAF3B_Ethernet98/4 | *trunk | *2-4094 | *- | *['MLAG'] | 983 |

*Inherited from Port-Channel Interface

### Ethernet Interfaces Device Configuration

```eos
!
interface Ethernet97/1
   description SPINE1_Ethernet50/1
   no shutdown
   channel-group 971 mode active
!
interface Ethernet97/2
   description SPINE2_Ethernet50/1
   no shutdown
   channel-group 971 mode active
!
interface Ethernet97/3
   description LEAF3C_Ethernet97/1
   no shutdown
   channel-group 973 mode active
!
interface Ethernet97/4
   description LEAF3D_Ethernet97/1
   no shutdown
   channel-group 974 mode active
!
interface Ethernet98/1
   description LEAF3E_Ethernet97/1
   no shutdown
   channel-group 981 mode active
!
interface Ethernet98/3
   description MLAG_PEER_LEAF3B_Ethernet98/3
   no shutdown
   channel-group 983 mode active
!
interface Ethernet98/4
   description MLAG_PEER_LEAF3B_Ethernet98/4
   no shutdown
   channel-group 983 mode active
```

## Port-Channel Interfaces

### Port-Channel Interfaces Summary

#### L2

| Interface | Description | Type | Mode | VLANs | Native VLAN | Trunk Group | LACP Fallback Timeout | LACP Fallback Mode | MLAG ID | EVPN ESI |
| --------- | ----------- | ---- | ---- | ----- | ----------- | ------------| --------------------- | ------------------ | ------- | -------- |
| Port-Channel971 | SPINES_Po501 | switched | trunk | 10,310,320,330 | - | - | - | - | 971 | - |
| Port-Channel973 | LEAF3C_Po971 | switched | trunk | 10,310,320,330 | - | - | - | - | 973 | - |
| Port-Channel974 | LEAF3D_Po971 | switched | trunk | 10,310,320,330 | - | - | - | - | 974 | - |
| Port-Channel981 | LEAF3E_Po971 | switched | trunk | 10,310,320,330 | - | - | - | - | 981 | - |
| Port-Channel983 | MLAG_PEER_LEAF3B_Po983 | switched | trunk | 2-4094 | - | ['MLAG'] | - | - | - | - |

### Port-Channel Interfaces Device Configuration

```eos
!
interface Port-Channel971
   description SPINES_Po501
   no shutdown
   switchport
   switchport trunk allowed vlan 10,310,320,330
   switchport mode trunk
   mlag 971
!
interface Port-Channel973
   description LEAF3C_Po971
   no shutdown
   switchport
   switchport trunk allowed vlan 10,310,320,330
   switchport mode trunk
   mlag 973
!
interface Port-Channel974
   description LEAF3D_Po971
   no shutdown
   switchport
   switchport trunk allowed vlan 10,310,320,330
   switchport mode trunk
   mlag 974
!
interface Port-Channel981
   description LEAF3E_Po971
   no shutdown
   switchport
   switchport trunk allowed vlan 10,310,320,330
   switchport mode trunk
   mlag 981
!
interface Port-Channel983
   description MLAG_PEER_LEAF3B_Po983
   no shutdown
   switchport
   switchport trunk allowed vlan 2-4094
   switchport mode trunk
   switchport trunk group MLAG
```

## VLAN Interfaces

### VLAN Interfaces Summary

| Interface | Description | VRF |  MTU | Shutdown |
| --------- | ----------- | --- | ---- | -------- |
| Vlan4094 | MLAG_PEER | default | 1500 | False |

#### IPv4

| Interface | VRF | IP Address | IP Address Virtual | IP Router Virtual Address | VRRP | ACL In | ACL Out |
| --------- | --- | ---------- | ------------------ | ------------------------- | ---- | ------ | ------- |
| Vlan4094 |  default  |  192.168.0.10/31  |  -  |  -  |  -  |  -  |  -  |

### VLAN Interfaces Device Configuration

```eos
!
interface Vlan4094
   description MLAG_PEER
   no shutdown
   mtu 1500
   no autostate
   ip address 192.168.0.10/31
```

# Routing
## Service Routing Protocols Model

Multi agent routing protocol model enabled

```eos
!
service routing protocols model multi-agent
```

## IP Routing

### IP Routing Summary

| VRF | Routing Enabled |
| --- | --------------- |
| default | True |
| MGMT | false |

### IP Routing Device Configuration

```eos
!
ip routing
no ip routing vrf MGMT
```
## IPv6 Routing

### IPv6 Routing Summary

| VRF | Routing Enabled |
| --- | --------------- |
| default | False |
| MGMT | false |

## Static Routes

### Static Routes Summary

| VRF | Destination Prefix | Next Hop IP             | Exit interface      | Administrative Distance       | Tag               | Route Name                    | Metric         |
| --- | ------------------ | ----------------------- | ------------------- | ----------------------------- | ----------------- | ----------------------------- | -------------- |
| MGMT | 0.0.0.0/0 | 172.100.100.1 | - | 1 | - | - | - |
| default | 0.0.0.0/0 | 10.10.10.1 | - | 1 | - | - | - |

### Static Routes Device Configuration

```eos
!
ip route vrf MGMT 0.0.0.0/0 172.100.100.1
ip route 0.0.0.0/0 10.10.10.1
```

# Multicast

## IP IGMP Snooping

### IP IGMP Snooping Summary

| IGMP Snooping | Fast Leave | Interface Restart Query | Proxy | Restart Query Interval | Robustness Variable |
| ------------- | ---------- | ----------------------- | ----- | ---------------------- | ------------------- |
| Enabled | - | - | - | - | - |

### IP IGMP Snooping Device Configuration

```eos
```

# Filters

# ACL

# VRF Instances

## VRF Instances Summary

| VRF Name | IP Routing |
| -------- | ---------- |
| MGMT | disabled |

## VRF Instances Device Configuration

```eos
!
vrf instance MGMT
```

# Quality Of Service
