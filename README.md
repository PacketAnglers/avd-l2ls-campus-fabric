# AVD - L2LS Campus Fabric Demo

![Figure: 1](images/campus_topo.svg)

### Build Configs

``` bash
make build
```

### Deploy Configs - eAPI

``` bash
make deploy
```

### Add 802.1x Port Configs

- Uncomment network_ports: in DC1_NETWORK_PORTS.yml
- run `make build` again
- show intended/configs