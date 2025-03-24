# isos

## Ubuntu $LTS server

- Currently, latest LTS is 24.04. We want to use the server edition.
- We can create the ISO via the following
  commands:

```
wget https://releases.ubuntu.com/24.04.2/ubuntu-24.04.2-live-server-amd64.iso
echo "d6dab0c3a657988501b4bd76f1297c053df710e06e0c3aece60dead24f270b4d *ubuntu-24.04.2-live-server-amd64.iso" | shasum -a 256 --check
lsblk  # Show disks ... identify the USB ...
sudo umount /dev/sdX*  # Replace sdX w/ the device (i.e. `/dev/sdb`)
sudo dd bs=4M if=ubuntu-24.04.2-live-server-amd64.iso of=/dev/sdX status=progress oflag=sync
sudo sync
```

- The USB is now ready!

## NixOS $LATEST

TODO
