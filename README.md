# Ansible Laptop Provisioning

Automated Linux laptop setup using Ansible. This playbook configures a complete development environment with packages, tools, and personal configurations.

## What It Does

This Ansible playbook automates the setup of a Linux development laptop, including:

- **System Packages**: Installs development tools, utilities, and applications
- **Docker**: Container runtime configuration
- **Flatpak Applications**: Desktop applications via Flatpak
- **GNOME Desktop**: Desktop environment customization
- **Python Environment**: pyenv for Python version management
- **Development Tools**:
  - Neovim with extensive plugin configuration
  - Fish shell with custom configs
  - Tmux terminal multiplexer
  - Kitty terminal emulator
- **CLI Tools**: hub, restic, yq, pup, terraform, and more
- **Git Repositories**: Automatically clones configured repositories
- **User Configuration**: Git settings, shell configs, and dotfiles

## Prerequisites

- A fresh or existing Linux installation (Debian or RedHat-based)
- sudo access
- Internet connection

## Quick Start

### Fresh Installation (Bootstrap)

For a completely new system, run the bootstrap script:

```bash
curl -sSL https://raw.githubusercontent.com/matrixise/ansible-laptop/master/bootstrap.sh | bash
```

This will:
1. Install Ansible and dependencies
2. Clone this repository
3. Install required Ansible Galaxy roles
4. Run the complete playbook

### Manual Installation

If you already have Ansible installed:

```bash
# Clone the repository
git clone https://github.com/matrixise/ansible-laptop
cd ansible-laptop

# Install Ansible Galaxy dependencies
ansible-galaxy install -r requirements.yml --force

# Run the playbook (will prompt for sudo password and vault password)
ansible-playbook -K --ask-vault-pass playbook.yml
```

## Configuration

### User Settings

Edit `vars/main.yml` to customize user-specific settings:

```yaml
user:
  unix: your-username
  name: Your Name
  email: your@email.com
  nickname: your-github-username
  shell: /usr/bin/fish
editor: /usr/bin/nvim
```

### Secrets

Sensitive data is stored in `secrets.yml` (encrypted with Ansible Vault):

```bash
# Edit secrets
ansible-vault edit secrets.yml

# View secrets
ansible-vault view secrets.yml
```

### Git Repositories

Configure repositories to clone in `roles/git_repositories/defaults/main.yml`:

```yaml
code_workspace:
  source_dir: ~/src
  hosts:
    - name: github
      fqdn: github.com
      repositories:
        - owner/repo-name
      forked_as:
        owner/repo-name: "yourname/repo-name"
```

Repositories will be cloned to `~/src/github.com/owner/repo-name`, and fork remotes will be automatically configured.

## Running Specific Parts

Use tags to run only specific roles:

```bash
# Install only system packages
ansible-playbook -K --ask-vault-pass playbook.yml --tags packages

# Configure only Python/pyenv
ansible-playbook -K --ask-vault-pass playbook.yml --tags python,pyenv

# Update shell configuration
ansible-playbook -K --ask-vault-pass playbook.yml --tags fish,config

# Install terminal emulator
ansible-playbook -K --ask-vault-pass playbook.yml --tags kitty
```

Available tags: `packages`, `flatpak`, `python`, `pyenv`, `git`, `fish`, `config`, `kitty`, `terminal-emulator`, `zeal`, `mbsync`, `hub`, `restic`, `yq`, `pup`, `terraform`

## Supported Distributions

- **Debian-based**: Ubuntu, Debian, Linux Mint
- **RedHat-based**: Fedora, CentOS, RHEL

The playbook automatically detects the distribution and uses appropriate package managers and repositories.

## Repository Structure

```
.
├── playbook.yml              # Main playbook
├── requirements.yml          # Ansible Galaxy dependencies
├── vars/main.yml            # User configuration
├── secrets.yml              # Encrypted secrets
├── inventory.ini            # Ansible inventory
├── ansible.cfg              # Ansible configuration
└── roles/
    ├── packages/            # System package installation
    ├── docker/              # Docker setup
    ├── flatpak/             # Flatpak applications
    ├── gnome/               # GNOME configuration
    ├── python/              # Python setup
    ├── user_space/          # User tools and configs
    └── git_repositories/    # Git repository management
```

## Testing Changes

```bash
# Check syntax
ansible-playbook playbook.yml --syntax-check

# Lint YAML files
yamllint playbook.yml roles/

# Dry run (check what would change)
ansible-playbook -K --ask-vault-pass playbook.yml --check
```

## Customization

### Adding Packages

Edit the appropriate file:
- Cross-platform packages: `roles/packages/vars/commons.yml`
- Debian-specific: `roles/packages/vars/vars-Debian.yml`
- RedHat-specific: `roles/packages/vars/vars-RedHat.yml`

### Adding Neovim Plugins

Add plugins to `roles/user_space/defaults/main.yml`:

```yaml
nvim:
  plugins:
    - id: author/plugin-name
    - id: another/plugin
      config:
        do: ':UpdateRemotePlugins'
```

### Adding User-Space Tools

1. Create `roles/user_space/tasks/tool-name.yml`
2. Add the task file to `roles/user_space/tasks/main.yml`:
   ```yaml
   - import_tasks: tool-name.yml
     tags: [tool-name]
   ```

## License

This project is for personal use. Adapt and modify as needed for your own setup.

## Author

Stéphane Wirtel ([@matrixise](https://github.com/matrixise))
