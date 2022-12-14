# AVD - L2LS Campus Fabric Demo

## Summary

This repository is a fully functioning Campus Fabric running on cEOS nodes deployed via ContainerLab.  All the AVD input variable files are pre-defined to make it easy to build and deploy configs to the topology.

![Figure: 1](images/campus_topo.svg)

## Requirements

- Linux Host (Ubuntu 20.04 recommended)
- Docker installed
- [Containerlab](https://containerlab.dev/install/) installed
- make installed (optional)
- 8 vCPUs and 32GB RAM (recommended)
- AVD installed - docs [here](https://avd.sh/en/stable/docs/installation/collection-installation.html) - install the latest devel branch
- 4.28.3M cEOS imported to Docker
  - You can use a different version by updating image name in campus-l2ls.yml containerlab topology file. To import a cEOS image into docker, run example command: `docker import cEOS-lab-4.27.3F.tar ceos:4.27.3F`

## Documentation

[Campus Fabric Example](https://avd.sh/en/devel/examples/campus-fabric/index.html)

## Clone Repo

``` bash
git clone https://github.com/PacketAnglers/avd-l2ls-campus-fabric.git
```

## Start Lab

``` bash
make start-lab

# or

sudo clab deploy -t clab/campus-l2ls.yml --reconfigure
```

You should see something like this:

``` bash
+----+--------+--------------+--------------+------+---------+--------------------+--------------+
| #  |  Name  | Container ID |    Image     | Kind |  State  |    IPv4 Address    | IPv6 Address |
+----+--------+--------------+--------------+------+---------+--------------------+--------------+
|  1 | LEAF1A | 941d984af66c | ceos:4.28.3M | ceos | running | 172.100.100.103/24 | N/A          |
|  2 | LEAF1B | b8a0ccfa8688 | ceos:4.28.3M | ceos | running | 172.100.100.104/24 | N/A          |
|  3 | LEAF2A | 98322340fb52 | ceos:4.28.3M | ceos | running | 172.100.100.105/24 | N/A          |
|  4 | LEAF3A | 28cf73f28f11 | ceos:4.28.3M | ceos | running | 172.100.100.106/24 | N/A          |
|  5 | LEAF3B | 64b118acf67c | ceos:4.28.3M | ceos | running | 172.100.100.107/24 | N/A          |
|  6 | LEAF3C | 055e20e156f4 | ceos:4.28.3M | ceos | running | 172.100.100.108/24 | N/A          |
|  7 | LEAF3D | 577b91ee07a5 | ceos:4.28.3M | ceos | running | 172.100.100.109/24 | N/A          |
|  8 | LEAF3E | 963d1cf9ae52 | ceos:4.28.3M | ceos | running | 172.100.100.110/24 | N/A          |
|  9 | SPINE1 | a2c7fb24c846 | ceos:4.28.3M | ceos | running | 172.100.100.101/24 | N/A          |
| 10 | SPINE2 | fd312eaa81c4 | ceos:4.28.3M | ceos | running | 172.100.100.102/24 | N/A          |
| 11 | WAN1   | ee0ac8154676 | ceos:4.28.3M | ceos | running | 172.100.100.111/24 | N/A          |
| 12 | WAN2   | 0ec907103384 | ceos:4.28.3M | ceos | running | 172.100.100.112/24 | N/A          |
+----+--------+--------------+--------------+------+---------+--------------------+--------------+
```

## Review group_vars

Review the content of the individual `group_vars` files.

- CAMPUS.yml (global settings)
- CAMPUS_FABRIC.yml (links, IP pool, mlag, varp, etc...)
- CAMPUS_FABRIC_SERVICES.yml (vlans/svis/vrfs)
- CAMPUS_FABRIC_PORTS.yml (port profiles)

## Build Configs

``` bash
make build

# or

ansible-playbook playbooks/build.yml
```

> View the configs and docs generated.  `intended/configs` and `documentation/devices`.

## Deploy Configurations - 2 Methods

### Deploy via CVaaS

- Register Devices to www.cv-staging.corp.arista.io

> Update registration token file in `group_vars/CVAAS` if needed.

``` bash
make onboard-lab

# or

ansible-playbook playbooks/onboard_to_cvaas.yml
```

- Deploy Configurations via CVaaS

``` bash
make deploy-cvaas

# or

ansible-playbook playbooks/deploy-cvaas.yml
```

Finish by building a Change Control in CVaaS to execute tasks.

### Deploy via eAPI

``` bash
make deploy

# or

ansible-playbook playbooks/deploy.yml
```

## Connect to Switches

SSH to SPINE1

- username: admin
- password: admin

``` bash
ssh admin@172.100.100.101
```

Or connect to SPINE1 via Docker exec.

``` bash
sudo docker exec -it SPINE1 Cli
```

## Update Leaf Port Configs

Add individual 802.1x port configuration to the LEAF switches.

- IDF1 LEAFs - ports Ethernet1-48
- IDF2 LEAF - ports Ethernet3/1-48-Ethernet7/1-48 (5 modules - 240 ports)
- IDF3 LEAFs - ports Ethernet1-96

Add the following example 802.1x port config to each port above.  We use Port Profiles and Networkjs Ports feature to accomplish this with a small data model per IDF.

### Example 802.1x Port Config

``` bash
interface Ethernet1
   description IDF1 Standard Port
   no shutdown
   switchport trunk native vlan 110
   switchport phone vlan 120
   switchport phone trunk untagged
   switchport mode trunk phone
   switchport
   dot1x pae authenticator
   dot1x authentication failure action traffic allow vlan 130
   dot1x reauthentication
   dot1x port-control auto
   dot1x host-mode multi-host authenticated
   dot1x mac based authentication
   dot1x timeout tx-period 3
   dot1x timeout reauth-period server
   dot1x reauthorization request limit 3
   spanning-tree portfast
   spanning-tree bpduguard enable
```

- Uncomment network_ports: section in **group_vars/CAMPUS_NETWORK_PORTS.yml**
- run `make build` again
- show intended/configs

> _You will not be able to deploy the additional ports as they do not exist on the LEAF nodes._

## Stop and Cleanup Lab

``` bash
make stop-lab

# or

sudo clab destroy -t clab/campus-l2ls.yml --cleanup
```
