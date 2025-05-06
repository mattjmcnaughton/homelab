# vm-docker-compose

## Changelog

- 2025-05-06
    - Upgraded to 6GB mem and 2CPU via `lxc config set vm-docker-compose
      limits.memory 6GB` and `lxc config set vm-docker-compose limits.cpu 2`
      respectively.
        - The machine needed to be stopped to make this change.
    - Increased the size of the root disk via `lxc config device override
      vm-docker-compose root size=40GiB`.
        - The VM needed to be restarted to recognize the increased disk size.

## Game plan

Vanilla VM launch. Here's the specific commands.

- `lxc launch --vm ubuntu:24.04 --profile base --config limits.cpu=1 --config limits.memory=4GB vm-docker-compose`
- Run the "base provisioning" outlined in the [lxd docs](../lxd/README.md) (i.e.
  install base packages, tailscale, etc).
- Bring `vm-docker-compose` under Ansible management via adding
  `vm-docker-compose` to `hosts`.
  - Create a `@vm-docker-compose-data` subvolume on `op-ampere`.
- Mount `@vm-docker-compose-data` into the VM via: `lxc config device add vm-docker-compose btrfs-data disk source=/mnt/vm-docker-compose-data path=/mnt/data`
