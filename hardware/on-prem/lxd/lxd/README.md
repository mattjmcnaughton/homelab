# lxd

## Install

On VM.

```
sudo snap install lxd
cat lxd-init-preseed.yml | sudo lxd init --preseed
```

## Create profiles

```
lxc profile create code
cat lxc-profile/code.yml | lxc profile edit code
```

## Create instances

```
lxc launch --vm ubuntu:24.04 --profile code --config limits.cpu=1 --config limits.memory=2GB code
```

## Notes

- We want to use normal Ext4 filesystem for VM images, and we will manage as a
  default "directory" storage pool. We can create BtrFs subvolume on the host
  and attach as a device for the VM.
