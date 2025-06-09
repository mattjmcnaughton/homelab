# nas

Do 64-bit Raspberry Pi Lite.

- Set hostname to `op-$TBD`.
- Do configuration with username/password, do not enable SSH.

## Install

Configure wifi.

```
# Enable WiFi radio
nmcli radio wifi on

# List available WiFi networks
nmcli device wifi list

# Connect to a WiFi network (prompts for password)
nmcli device wifi connect <SSID> --ask

# OR: Connect to a WiFi network (provide password directly)
nmcli device wifi connect <SSID> password <wifi_password>

# Show active connections
nmcli connection show --active

# Show device status
nmcli device status

# Disconnect from a WiFi network
nmcli connection down <SSID>
```

Set-up tailscale

```
wget https://tailscale.com/install.sh
chmod u+x install.sh
./install.sh
sudo tailscale up --ssh
# Disable the key expiry for this new node
```

## Install ZFS

```
sudo apt update
sudo apt install gdisk zfsutils-linux  # this is going to take a while

lsblk  # identify disk
sudo sgdisk --zap-all /dev/sdX  # delete any partitions

sudo zpool create tank /dev/sda  # assuming only a single device... if more, can think about RAID
    - If you have two devices that you want mirrored, you can do `zpool create
      poolname mirror /dev/sda /dev/sdb`.
    - To add a disk later, you can use `zpool attach tank existing-disk new-disk`.
sudo zfs create tank/backup   # or any other dataset

sudo chown mattjmcnaughton:mattjmcnaughton /tank/backup

# We can test via `rsync`.
```

## Configure Samba

### Server

```
sudo apt install samba samba-common-bin

# Add the following text snippet to the bottom of `sudo nvim
/etc/samba/smb.conf`.
# Additionally, delete all "Share definitions" except for the ones we added.
[backup]
path = /tank/backup
browseable = yes
writable = yes
only guest = no
create mask = 0644
directory mask = 0755
public = no

# Final steps
sudo smbpasswd -a mattjmcnaughton # Enter password when prompted
sudo systemctl restart smbd
sudo systemctl enable smbd
```

### Client

- Verified working successfuly via:
    - Nautilus (i.e. smb//op-blueberry/backup).
    - `smbclient`
- Experiment remaining:
    - Automount via `/etc/fstab` and `cifs-utils`

## Next steps

- Experiment with different solutions for making storage network accessible...
    - Samba? NFS?
    - What would work well with Jellyfin?
- Currently, we do not encrypt the /dev/sdX... do we care?
    - Likely not when we're on USB only...
