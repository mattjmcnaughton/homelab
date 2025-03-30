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

### Not-used

#### Compute

- id_: thinkpad-x220
    - type: compute
    - annotation: Thinkpad x220
    - specs: TBD
    - planned-usage: TBD
    - current-usage: TBD
- id_: rasperry-pi-4-{0..2}
    - type: compute
    - specs: TBD
    - planned-usage: TBD
    - current-usage: TBD

#### Storage

- id_: $TBD - m2 SSD

## Notes

- Do not include laptops which are solely used as "terminals".
