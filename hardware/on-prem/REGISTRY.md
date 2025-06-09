# registry

## Current physical hardware

Tracking what I've got and what it's being used for.

### In-use

- id_: system-76-wild-dog-pro
    - type: compute
    - annotation: System 76 Wild Dog Pro Desktop
    - specs: 4 CPUs (Intel I5 @ 3.5GHz) w/ Intel QuickSync, 16GB Ram, 256GB Samsung SSD Harddrive
    - name: op-ampere
    - current-usage: Server for running VMs (LXD) / multi-node k3s (within VMs) for homelab applications.
- id_: 512gb-western-digital-blue-hd
    - type: storage
    - attached_to: op-ampere
    - specs: 512 GB SSD
    - previous-usage: NixOS (cow) install. Verified not singular data store.
    - current-usage: Attached as btrfs storage to `op-ampere`.
- id_: rasp-pi-4-0
    - type: compute
    - specs: 4 CPUs (1.5 GHz), 4GB Ram, 32GB Micro SSD
    - name: n-a
    - current-usage: Using as a Home Assistant appliance (see
      [docs](../../software/apps/home-assistant/README.md) for full instructions).
- id_: rasp-pi-4-1
    - type: compute
    - specs: 4 CPUs (1.5 GHz), 4GB Ram, 32GB Micro SSD; attachted 1 128GB USB
    - name: op-apple
    - current-usage: nas. See [docs](../../software/apps/nas/README.md).
- id_: rasp-pi-4-2
    - type: compute
    - specs: 4 CPUs (1.5 GHz), 4GB Ram, 32GB Micro SSD; attached 2 32GB USB
    - name: op-blueberry
    - current-usage: nas (focused specifically on backup server). See [docs](../../software/apps/nas/README.md).

### WIP

- id_: thinkpad-x220
    - type: compute
    - annotation: Thinkpad x220
    - specs: TBD
    - current-usage: TBD
    - pending-upgrades: Upgrade to 16GB Ram, SSD(s)
    - notes:
        - Attempted to install ubuntu 24.04, but it failed repeatedly.

### Not-used

#### Compute

- id_: thinkpad-x220
    - type: compute
    - annotation: Thinkpad x220
    - specs: TBD
    - planned-usage: TBD
    - current-usage: TBD

#### Storage

- id_: $TBD - m2 SSD

## Notes

- Do not include laptops which are solely used as "terminals".
