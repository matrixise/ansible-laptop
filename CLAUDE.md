# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is an Ansible playbook repository for provisioning and configuring a Linux development laptop. It automates the installation of packages, development tools, user configurations, and git repositories.

## Running the Playbook

### Bootstrap (Fresh Install)
```bash
# Bootstrap script installs Ansible and runs the playbook
./bootstrap.sh
```

This will:
- Install python3-pip and git via apt
- Install Ansible via pipx
- Clone the repository
- Install required Ansible Galaxy roles
- Run the playbook with sudo and vault password prompts

### Standard Playbook Execution
```bash
# Install Ansible Galaxy dependencies first
ansible-galaxy install -r requirements.yml --force

# Run the full playbook
ansible-playbook -K --ask-vault-pass playbook.yml

# Run specific roles using tags
ansible-playbook -K --ask-vault-pass playbook.yml --tags packages
ansible-playbook -K --ask-vault-pass playbook.yml --tags python,pyenv
ansible-playbook -K --ask-vault-pass playbook.yml --tags fish,config
```

Available tags: `packages`, `flatpak`, `python`, `pyenv`, `git`, `fish`, `config`, `kitty`, `terminal-emulator`, `zeal`, `mbsync`, `hub`, `restic`, `yq`, `pup`, `terraform`

### Testing Changes
```bash
# Syntax check
ansible-playbook playbook.yml --syntax-check

# Lint YAML files
yamllint playbook.yml roles/

# Dry-run (check mode)
ansible-playbook -K --ask-vault-pass playbook.yml --check
```

## Architecture

### Role Structure
Roles execute in the following order (from playbook.yml):

1. **packages** (requires sudo) - Installs system packages via apt/dnf
   - OS-specific package lists in `vars/vars-Debian.yml` and `vars/vars-RedHat.yml`
   - Common packages in `vars/commons.yml`
   - Installs snap packages (e.g., bitwarden)

2. **docker** (requires sudo) - Docker installation and configuration

3. **flatpak** - Flatpak applications installation

4. **gnome** - GNOME desktop environment configuration

5. **python** - Python-specific setup

6. **user_space** - User-level configurations and tools:
   - pyenv (Python version management)
   - neovim with extensive plugin list
   - git configuration
   - fish shell
   - tmux
   - kitty terminal
   - zeal (offline documentation)
   - mbsync (email sync)
   - CLI tools: hub, restic, yq, pup, terraform

7. **git_repositories** - Clones configured repositories to `~/src`
   - Automatically adds fork remotes based on `forked_as` mappings

### Configuration Files

- **vars/main.yml** - User-specific settings (name, email, shell, editor)
- **secrets.yml** - Ansible Vault encrypted secrets (use `--ask-vault-pass`)
- **ansible.cfg** - Ansible configuration:
  - Uses local inventory (inventory.ini)
  - Fact caching enabled (.ansible_cache directory)
  - Enhanced callbacks: timer, profile_tasks, profile_roles
  - YAML stdout callback

### Multi-Distribution Support

The playbook supports both Debian and RedHat-based distributions:
- OS detection via `ansible_os_family` variable
- OS-specific tasks in `roles/packages/tasks/setup-Debian.yml` and `setup-RedHat.yml`
- OS-specific package lists in `roles/packages/vars/`

### Git Repository Management

The `git_repositories` role clones repositories based on `code_workspace` structure in `roles/git_repositories/defaults/main.yml`:
- Repositories are organized by host (e.g., github.com)
- Destination: `~/src/{host.fqdn}/{repository}`
- Automatically configures fork remotes where specified

### Neovim Plugin Management

Neovim plugins are defined in `roles/user_space/defaults/main.yml` under `nvim.plugins`. Each plugin entry includes:
- `id`: Repository path (e.g., `junegunn/fzf.vim`)
- `config` (optional): Additional configuration like post-install commands

## Working with Secrets

```bash
# Edit encrypted secrets file
ansible-vault edit secrets.yml

# View encrypted file
ansible-vault view secrets.yml

# Encrypt a new file
ansible-vault encrypt filename.yml
```

## Adding New Packages

1. For cross-distribution packages, add to `roles/packages/vars/commons.yml`
2. For Debian-only packages, add to `roles/packages/vars/vars-Debian.yml`
3. For RedHat-only packages, add to `roles/packages/vars/vars-RedHat.yml`

## Adding New User-Space Tools

1. Create a new task file in `roles/user_space/tasks/{tool}.yml`
2. Import it in `roles/user_space/tasks/main.yml`
3. Add appropriate tags for selective execution

## External Dependencies

Required Ansible Galaxy roles (from requirements.yml):
- jaredhocutt.gnome_extensions - GNOME Shell extensions management
- avanov.pyenv - Python version management via pyenv
