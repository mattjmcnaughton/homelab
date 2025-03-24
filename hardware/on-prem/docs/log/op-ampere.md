# op-ampere

## Post-install log

- We may want to reinstall this machine using some of the new things that we've
  learned (i.e. Ansible playbooks, etc).
- We can consider using bitwarden-cli for the initial copying of the ts auth key.
- We still need to get lxd, k3s, etc... configured.

## Install log (2025-03)

### Install Ubuntu 24.04

- Prepared Ubuntu 24.04.2 ISO.

### Initial OS installation

- Install Ubuntu 24.04.2 ISO
- Steps:
    - Insert USB and select "Try/install Ubuntu Server"
    - Non-default updates/notes:
        - Ensure selecting ethernet.
        - Select "Custom storage configuration".
            - Select the disk and say "Use as Boot Device"
            - Add a GPT partition for boot.
                - 4GB, EXT4, /boot
            - Add an unencrypted btrfs partition for `/`.
                - 100GB; btrfs, /.
                    - 100GB is the amount recommended by Claude. We can
                      grow/shrink if necessary.
            - Later on we will add an encrypted `/fs`.
        - Set username/password.
        - For now, don't install OpenSSH. I can always access locally via the
          console.
        - Reboot (removing the USB).

## Basic software provisioning

POST-INSTALL-NOTE: We should revisit how we do this next time. Likely much of it
could, and should, be simplified with some of the scripts in `tools/scripts`
and/or done via Ansible (or another similar tool) once tailscale is configured.
In particular, we want to avoid the need to set up an openssh-server on the
newly provisioned target host. That said, provisioning the encrypted disk will
likely be manual.

```
# Enable passwordless sudo
echo "mattjmcnaughton ALL=(ALL) NOPASSWD: ALL" | sudo tee /etc/sudoers.d/mattjmcnaughton)
sudo chmod 440 /etc/sudoers.d/mattjmcnaughton

# Update packages
sudo apt update && sudo apt upgrade

# Setup the encrypted disk
sudo apt update && sudo apt install -y btrfs-progs cryptsetup
lsblk  # Identify the disk with the available space.
sudo parted /dev/sda print  # Check for the partitions. We may need to create one.

# If we need to create the blank partition...
sudo parted /dev/sda
mkpart mkpart encrypted-btrfs $END-OF-LAST-PART 100%
print
quit

sudo cryptsetup luksFormat /dev/sda4  # Enter a password (same as OS... may
revisit later).
sudo cryptsetup open /dev/sda4 encrypted_data
sudo mkfs.btrfs -L op-ampere-encrypted-btrfs /dev/mapper/encrypted_data
sudo mkdir -p /encrypted_fs
sudo mount -o compress=zstd,noatime,space_cache=v2 /dev/mapper/encrypted_data
/encrypted_fs
# Will prompt for decryption password at boot.
sudo bash -c 'echo "encrypted_data UUID=$(sudo blkid -s UUID -o value /dev/sda4) none luks" >> /etc/crypttab')
sudo bash -c 'echo "/dev/mapper/encrypted_data /encrypted_fs btrfs defaults,compress=zstd,noatime,space_cache=v2 0 0" >> /etc/fstab'

# Reboot
sudo reboot

# Move `/home` directory to an encrypted subvolume.
sudo btrfs subvolume create /encrypted_fs/@home
sudo rsync -avPHSX /home/ /encrypted_fs/@home/
sudo mv /home /home.old
sudo mkdir /home
sudo bash -c 'echo "/dev/mapper/encrypted_data /home btrfs defaults,subvol=@home,compress=zstd,noatime,space_cache=v2 0 0" >> /etc/fstab'
sudo systemctl daemon-reload
sudo mount /home
sudo btrfs subvolume show /home
rm -rf /home.old

# Create `/encrypted_fs/data` as an encrypted subvolume.
sudo btrfs subvolume create /encrypted_fs/@data
sudo mkdir /encrypted_fs/data
sudo bash -c 'echo "/dev/mapper/encrypted_data /encrypted_fs/data btrfs defaults,subvol=@data,compress=zstd,noatime,space_cache=v2 0 0" >> /etc/fstab'
sudo systemctl daemon-reload
sudo mount /encrypted_fs/data
sudo btrfs subvolume show /encrypted_fs/data
sudo chown -R mattjmcnaughton:mattjmcnaughton /encrypted_fs/data

reboot

# Install tailscale

## Temporarily install openssh with password-less authentication...

sudo su
curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/noble.gpg | apt-key add -
curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/noble.list | tee /etc/apt/sources.list.d/tailscale.list
apt update -y
apt install -y tailscale
systemctl enable --now tailscaled
export AUTH_KEY="..."  # copy from Tailscale UI
tailscale up --ssh --auth-key="$AUTH_KEY" --hostname=$(hostname)
vim /root/.bash_history  # Delete the export key line
su mattjmcnaughton

sudo apt uninstall --purge openssh-server
sudo apt autoremove
# TBD if necessary, but perhaps may help with host key validation errors.
sudo tailscale down && sudo tailscale start --ssh --hostname=$(hostname)
# Enter "Disable Key expiry" for this node so that it never needs to re-auth.

## Exit the openssh session...

## Enter a `tailscale ssh` session (or the physical host)
sudo systemctl stop ssh

## tailscaled ensures that even after reboot, the machine is still on the
tailnet. We don't need to set-up a systemd service, etc.

# (Optional) btrfs subvolumes on non-encrypted portions...
```

## Install LXC/LXD

TODO

## Install k3s (inside LXC VMs)

TODO
