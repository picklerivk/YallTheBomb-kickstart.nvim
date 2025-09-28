# Linux Configuration Files

## Introduction

A centralized repository for managing Linux configuration files stored in `$XDG_CONFIG_HOME` (typically `~/.config/`).

Features:
* Organized directory structure for different applications
* Setup script for easy deployment and management
* Backup functionality to preserve existing configurations
* Symlink-based installation for easy updates

## Directory Structure

```
├── config/                 # Configuration files directory
│   ├── alacritty/         # Alacritty terminal emulator
│   ├── bash/              # Bash shell configuration  
│   ├── git/               # Git configuration
│   ├── gtk-3.0/           # GTK 3.0 theming
│   ├── i3/                # i3 window manager
│   ├── kitty/             # Kitty terminal emulator
│   ├── nvim/              # Neovim editor (includes kickstart.nvim)
│   ├── tmux/              # tmux terminal multiplexer
│   ├── vim/               # Vim editor
│   └── zsh/               # Zsh shell
├── setup.sh               # Configuration management script
└── README.md              # This file
```

## Quick Start

1. **Clone this repository:**
   ```bash
   git clone <your-repo-url> ~/.dotfiles
   cd ~/.dotfiles
   ```

2. **Check current status:**
   ```bash
   ./setup.sh status
   ```

3. **Backup existing configurations (recommended):**
   ```bash
   ./setup.sh backup
   ```

4. **Install configurations:**
   ```bash
   ./setup.sh install
   ```

## Usage

### Configuration Management

The `setup.sh` script provides several commands for managing your configurations:

- `./setup.sh status` - Show which configurations are installed
- `./setup.sh install` - Install/symlink configurations to your system
- `./setup.sh backup` - Create backup of existing configurations
- `./setup.sh help` - Show usage information

### Adding New Configurations

1. Create a new directory under `config/` for your application
2. Add your configuration files to that directory
3. Run `./setup.sh install` to deploy the new configurations

### Environment Variables

- `XDG_CONFIG_HOME` - Base directory for configurations (defaults to `~/.config`)

## Configuration Details

### Neovim (kickstart.nvim)

The `config/nvim/` directory contains a complete Neovim configuration based on kickstart.nvim:
- Single-file configuration in `init.lua`
- Completely documented
- Plugin management with lazy.nvim
- LSP support and completion

### Other Applications

Configuration templates are provided for common Linux applications:
- **Bash**: Shell configuration and aliases
- **Git**: Global git configuration  
- **tmux**: Terminal multiplexer settings

## Notes

- Configurations are symlinked, so changes to files in this repository immediately affect your system
- Always backup your existing configurations before installing
- Some applications may require additional setup beyond configuration files

## License

MIT License - See LICENSE.md for details.