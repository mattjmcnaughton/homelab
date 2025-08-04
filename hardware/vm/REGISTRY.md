# registry

## Current VMs

### In-use

- id_: vm-docker-compose
    - on-prem-host: op-ampere
    - specs:
        cpu: 2cpu
        mem: 14GB
        base-disk: 80GB
        mounted-disk: @vm-docker-compose-data
        lxd-profile: base
    - name: vm-docker-compose
    - current-usage: Running applications via docker-compose. A "staging"
      ground previous to going on EKS.

### On-deck

- id_: k3s-server-1
- id_: k3s-agent-1
- tbd: id_: postgres
