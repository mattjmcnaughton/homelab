# vm-code

## Changelog

### 2025-05-18

- Initial configuration v0.1.0 of workbench!

## Game plan

### Base

Vanilla VM launch. Here's the specific commands.

- `lxc launch --vm ubuntu:24.04 --profile base --config limits.cpu=2 --config limits.memory=4GB vm-code`
- Run the "base provisioning" outlined in the [lxd docs](../lxd/README.md) (i.e.
  install base packages, tailscale, etc).
- Bring `vm-code` under Ansible management via adding
  `vm-code` to `hosts` and running `uv run ansible-playbook site.yml -l vm-code`
  - Create a `@vm-code-data` subvolume on `op-ampere` and then run the `uv run
    ansible-playbook site.yml -l op-ampere`.
- Mount `@vm-code-data` into the VM via: `lxc config device add vm-code btrfs-data disk source=/mnt/vm-code-data path=/mnt/data`

### vm-code specific

- Increase the size of the root disk via `lxc config device override
  vm-code root size=40GiB`.
    - The VM needed to be restarted to recognize the increased disk size.
- Provision via https://github.com/mattjmcnaughton/workbench.
    - Run `./bootstrap/push_secrets.py --limit aws,ssh --target vm-code`
        - We're skipping GPG for now, because we're not going to worry about
          commit signing. May be worth visiting again later, but fine for now.
    - Clone [workbench](https://github.com/mattjmcnaughton/workbench/pull/11)
      onto `vm-code` (specifically to `~/code/workbench`) and clone
      `second-brain` from private repo.
    - `./dotfiles/symlink_manager.py --all --exclude=nvim-no-plugins`
        - IMPT: Update `~/.bash_profile` to add `. ~/.bashrc` to ensure ~/.bashrc is
          installed on SSH.
            - We do _not_ manage `~/.bash_profile` via dotfiles symlink.
        - Ubuntu 24.04 comes with python3 installed, so we don't need to install it
          to run our python scripts.
    - Install Homebrew for Linux. Eventually, could define a `bootstrap` script,
      but not necessary rn.
        - `mkdir /tmp/homebrew-install && pushd /tmp/homebrew-install`
        - `sudo apt update && apt install wget`
        - `wget https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh`
        - `chmod u+x install.sh`
        - `NONINTERACTIVE=1 bash install.sh`
        - `rm install.sh`
        - `popd`
    - Run `./install/ubuntu-2404/install.py`.
    - If we want to connect remote from Coder/VS Code, we need to add the
      following to our SSH config.
      ```
Host vm-code
  HostName vm-code
      ```
    - Initial set-up is complete!
