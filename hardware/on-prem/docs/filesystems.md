# filesystems

## Servers (non-NAS/backup)

- Use Ext4 for the boot disk (i.e. operating system)
    - Encrypted
    - Contains
        - Apt packages
        - VM images
        - Docker "fundamentals" (i.e. images, runtime)
- Use BtrFS for any data
    - Mounted subvolumes for
        - Home
        - Data
        - Logs
        - Snapshots
    - Create btrfs subvolumes on the host (from data) and then mount into the VM
        - `lxc.mount.entry = /path/to/encrypted/btrfs/@data data none bind 0 0`
        - Have an `@lxc-vm` subvolume, and then create vm specific sub-volumes within there.
            - `@lxc-vm/@code`.
                - Should never call btrfs within the VM.
- Always use uid + gid 1000. Possible to control via `cloud-init`.
