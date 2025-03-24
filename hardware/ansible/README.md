# README

# Ansible Homelab

This repository contains Ansible configurations to provision and manage homelab servers and services.

## Overview

The project is organized to provide a flexible framework for managing multiple hosts with shared configurations and host-specific overrides. Common tasks include:

## Directory Structure

```
ansible/
├── ansible.cfg                 # Ansible configuration
├── inventory/                  # Host inventory
│   ├── hosts.yml               # Host definitions
    └── host_vars/              # Host-specific variables
        ├── server1.yml         # Variables for server1
        ├── server2.yml         # Variables for server2
        └── nas1.yml            # Variables for nas1
│   └── group_vars/             # Group variables
│       ├── all.yml             # Vars for all hosts
│       ├── servers.yml         # Server-specific group vars
│       └── storage.yml         # Storage-specific group vars
├── requirements.yaml           # Required Ansible collections
├── pyproject.toml              # Python dependencies configuration
├── .python-version             # Python version specification
├── playbooks/                  # Playbooks directory
│   ├── site.yml                # Main entry point playbook
│   ├── docker.yml              # Docker-specific playbook
│   ├── users.yml               # User management playbook
│   ├── storage.yml             # Storage configuration playbook
├── roles/                      # Ansible roles
│   ├── common/                 # Common configurations for all hosts
│   ├── docker/                 # Docker installation and setup
│   ├── users/                  # User management role
│   └── storage/                # Storage configuration role
```

## Setup

1. Ensure Python is installed and matches the version in `.python-version`
2. Install `uv` package manager is installed.
3. Install dependencies:
   ```bash
   uv sync
   ```

4. Install Ansible collections:
   ```bash
   uv run ansible-galaxy collection install -r requirements.yaml
   ```

## Usage

### Running the Main Playbook

Apply all configurations to all hosts:
```bash
uv run ansible-playbook playbooks/site.yml
```

### Targeting Specific Hosts

Apply configurations to a specific host:
```bash
uv run ansible-playbook playbooks/site.yml -l server1
```

### Running Specific Playbooks

Apply only Docker configurations:
```bash
uv run ansible-playbook playbooks/docker.yml
```

## Configuration

### Adding New Hosts

1. Add the host to `inventory/hosts.yml` under the appropriate group
2. Create a host-specific variable file in `inventory/host_vars/hostname.yml`
3. Add any new group-specific variable files.
4. Run the playbook with the new host specified
