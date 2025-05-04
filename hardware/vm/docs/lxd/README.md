# lxd

## Description

We use lxd/lxc as our VM provider of choice.

We predominantly use containers via EKS (and docker-compose) for
experimentation, but will spin up VMs for dedicated, long-lasted use cases.

For example, our k3s nodes will run on VMs.

## Install lxd/lxc

On our on-prem hardware.

```
sudo snap install lxd
sudo lxd init
    - All default settings, with the exception of using `dir` as the storage
      backend, instead of `zfs`.
```

We do NOT try and generate a preseed file. I'm not sure why, but when using the
preseed file, we had issues with network connectivity.

## Create profiles

```
lxc profile create base
cat lxc-profile/base.yml | lxc profile edit base
```

## Create instances

```
lxc launch --vm ubuntu:24.04 --profile base --config limits.cpu=1 --config limits.memory=2GB $VM-NAME
```

For VM name, our standard is `vm-$NAME`. For example, `vm-docker-compose`,
`vm-postgres`, etc.

## Manually configure instance

### On target VM

Connect to the VM via `lxc exec --user=1000 $VM /bin/bash`

Execute the following:

```
mkdir /tmp/bootstrap-scripts && cd /tmp/bootstrap-scripts

wget https://raw.githubusercontent.com/mattjmcnaughton/homelab/refs/heads/main/tools/scripts/install-base-packages-ubuntu-2404.sh
chmod u+x install-base-packages-ubuntu-2404.sh
sudo ./install-base-packages-ubuntu-2404.sh

wget https://raw.githubusercontent.com/mattjmcnaughton/homelab/refs/heads/main/tools/scripts/install-tailscale-ubuntu-2404.sh
chmod u+x install-tailscale-ubuntu-2404.sh
sudo ./install-tailscale-ubuntu-2404.sh

# The `mattjmcnaughton` user already exists, so unlike EC2, we don't need to run
# the `create-user-linux.sh` script.

# Using "Add device" from the tailscale UI, create an auth key. Do not add tags.
# Do _not_ enable for re-use. We could use bitwarden, but bc we have access to
# the UI, let's just copy and paste. Since it's a single use key, there's no risk
# to it being an env variable.
export TS_AUTH_KEY_ONE_OFF=<TS_KEY_HERE>

curl -O https://raw.githubusercontent.com/mattjmcnaughton/homelab/refs/heads/main/tools/scripts/launch-tailscale.sh
chmod u+x launch-tailscale.sh
sudo ./launch-tailscale.sh ${TS_AUTH_KEY_ONE_OFF} $HOSTNAME
# Be sure to delete "Node Expiry" via the Tailscale UI.

rm -rf /tmp/bootstrap-scripts
```

### On host

We can now configure the VM via ansible.

- Update `inventory/hosts.yml` and `inventory/host_vars/$VM-HOSTNAME`.
    - As of 2025-05, we manage btrfs on `op-ampere` and then mount into VMs. We do not do
      any btrfs operations within our VMs.

### Mount btrfs storage

`lxc config device add $VM-NAME $DEVICE-NAME disk source=/path/on/host path=/path/on/target`

For example, to mount in the `@vm-docker-compose-data` BtrFS subvolume, we would do the following:

`lxc config device add vm-docker-compose btrfs-data disk source=/mnt/vm-docker-compose-data path=/mnt/data`

## Manage instances

```
lxc start $VM-NAME
lxc stop $VM-NAME
lxc delete $VM-NAME --force
```

## Notes

- We want to use normal Ext4 filesystem for VM images, and we will manage as a
  default "directory" storage pool. We can create BtrFs subvolume on the host
  and attach as a device for the VM.
