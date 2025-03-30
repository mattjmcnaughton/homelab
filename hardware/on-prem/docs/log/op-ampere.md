# op-ampere

## Game plan

- We want to install Ubuntu 24.04 server.
- For storage:
    - Our 256GB Samsung disk will be an encrypted LVM ext4 system with the main
      install.
      - The Ubuntu installer can manage this entirely.
        - This is for the base OS and VM images.
    - We will also provision/mount a 500GB Western Digital SSD as an encrypted
      btrfs filesystem.
        - This is for data storage (both on host and for mounting into the VMs).
- We do a "bare essentials" install manually (relying on our existing scripts
  which we can download from GitHub). Then, we can use Ansible for the rest.

## Install log

### Install Ubuntu 24.04

- Prepared Ubuntu 24.04.2 ISO.

### Initial OS installation

- Install Ubuntu 24.04.2 ISO
- Steps:
    - Insert USB and select "Try/install Ubuntu Server"
    - Non-default updates/notes:
        - For "Guided storage configuration"
            - Select "Use an entire disk" > "Set up this disk as an LVM group" >
              "Encrypt the LVM group w/ LUKS"
                - Do NOT create a recovery key.
            - We will create the encrypted btrfs volume after.
        - Set username/password.
        - For now, don't install OpenSSH. I can always access locally via the
          console.
        - We do not want to preinstall any snaps.
        - Reboot (removing the USB).

## Generic host provisioning

```
echo "mattjmcnaughton ALL=(ALL) NOPASSWD: ALL" | sudo tee /etc/sudoers.d/mattjmcnaughton
sudo chmod 440 /etc/sudoers.d/mattjmcnaughton

sudo apt update && apt upgrade

mkdir /tmp/bootstrap-scripts && cd /tmp/bootstrap-scripts

wget https://raw.githubusercontent.com/mattjmcnaughton/homelab/refs/heads/main/tools/scripts/install-base-packages-ubuntu-2404.sh
chmod u+x install-base-packages-ubuntu-2404.sh
sudo ./install-base-packages-ubuntu-2404.sh

wget https://raw.githubusercontent.com/mattjmcnaughton/homelab/refs/heads/main/tools/scripts/install-tailscale-ubuntu-2404.sh
chmod u+x install-tailscale-ubuntu-2404.sh
sudo ./install-tailscale-ubuntu-2404.sh

# The `mattjmcnaughton` user already exists, so unlike EC2, we don't need to run
# the `create-user-linux.sh` script.

# Auth to bitwarden
export BW_SESSION=$(bw login --raw)

# This assumes that we've already uploaded a tailscale auth key to our homelab bitwarden.
# Do NOT attach tags to the key or else SSH won't work. Not sure why, but can
# investigate later.
wget https://raw.githubusercontent.com/mattjmcnaughton/homelab/refs/heads/main/tools/scripts/launch-tailscale.sh
chmod u+x launch-tailscale.sh
sudo ./launch-tailscale.sh $(bw get password $hostname) $HOSTNAME

# Ensure that we disable node expiry from the tailscale console. Also, verify
# that ssh via tailscale works.
```

## Machine-specific (i.e. provisioning data disk)

```
# In this case, we want to wipe /dev/sdb (which was already encrypted) and use
# it as a btrfs encrypted data dir.

sudo umount /dev/sdb

# Overwrite early bytes w/ random to destroy existing filesystem.
sudo dd if=/dev/urandom of=/dev/sdb bs=4M count=10 status=progress

# Enter password when prompted...
sudo cryptsetup luksFormat --type luks2 /dev/sdb

# Verify encryption worked successfully
sudo cryptsetup open /dev/sdb encrypted_disk

# Set-up btrfs
sudo mkfs.btrfs -L encrypted_btrfs /dev/mapper/encrypted_disk

# Get the UUID
sudo cryptsetup luksUUID /dev/sdb

# Append the following line to `/etc/crypttab` (using Vim)
# You should already see one for the base OS install disk.
# Note, you will need to enter two passwords to unlock the disks when rebooting
# the system.
# "encrypted_disk UUID=your-uuid-here none luks,discard"

# Append the following line to `/etc/fstab` (using Vim)
# "/dev/mapper/encrypted_disk /mnt/encrypted_btrfs btrfs defaults 0 0"

# Create the mount directory
sudo mkdir -p /mnt/encrypted_btrfs

# Test the mount setup
sudo systemctl daemon-reload
sudo mount -a

# Ensure LUKS modules installed in initramfs
sudo update-initramfs -u

# Can manage the rest of the subvolumes via ansible.
```

## Ansible set-up

We can now run ansible targeted at `op-ampere`.

- Update `inventory/hosts.yml` and create an
  `inventory/host_vars/$TARGET_HOSTNAME.yml`.
- `uv run ansible-playbook playbooks/site.yml -l $TARGET_HOSTNAME`

## Install LXC/LXD

TODO

## Install k3s (inside LXC VMs)

TODO
