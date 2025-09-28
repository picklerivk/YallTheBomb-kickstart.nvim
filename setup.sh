#!/bin/bash

# Configuration Management Script
# This script helps manage your Linux configuration files

set -e

CONFIG_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/config"
XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"

usage() {
    echo "Usage: $0 [command]"
    echo ""
    echo "Commands:"
    echo "  install    - Install/symlink configurations to your system"
    echo "  backup     - Backup existing configurations"
    echo "  status     - Show status of configurations"
    echo "  help       - Show this help message"
    echo ""
    echo "Environment:"
    echo "  XDG_CONFIG_HOME: $XDG_CONFIG_HOME"
    echo "  Config source:   $CONFIG_DIR"
}

backup_configs() {
    echo "Creating backup of existing configurations..."
    BACKUP_DIR="$HOME/.config-backup-$(date +%Y%m%d-%H%M%S)"
    mkdir -p "$BACKUP_DIR"
    
    for config_app in "$CONFIG_DIR"/*; do
        if [ -d "$config_app" ]; then
            app_name=$(basename "$config_app")
            if [ -d "$XDG_CONFIG_HOME/$app_name" ]; then
                echo "Backing up $app_name..."
                cp -r "$XDG_CONFIG_HOME/$app_name" "$BACKUP_DIR/"
            fi
        fi
    done
    
    # Special cases for files in home directory
    for file in .bashrc .gitconfig .tmux.conf; do
        if [ -f "$HOME/$file" ]; then
            echo "Backing up $file..."
            cp "$HOME/$file" "$BACKUP_DIR/"
        fi
    done
    
    echo "Backup created at: $BACKUP_DIR"
}

install_configs() {
    echo "Installing configuration files..."
    
    # Ensure XDG_CONFIG_HOME exists
    mkdir -p "$XDG_CONFIG_HOME"
    
    for config_app in "$CONFIG_DIR"/*; do
        if [ -d "$config_app" ]; then
            app_name=$(basename "$config_app")
            target_dir="$XDG_CONFIG_HOME/$app_name"
            
            echo "Installing $app_name configuration..."
            
            # Create target directory if it doesn't exist
            mkdir -p "$target_dir"
            
            # Copy or symlink configuration files
            for config_file in "$config_app"/*; do
                if [ -f "$config_file" ] && [ ! "$(basename "$config_file")" = "README.md" ]; then
                    filename=$(basename "$config_file")
                    echo "  Linking $filename"
                    ln -sf "$config_file" "$target_dir/$filename"
                fi
            done
        fi
    done
    
    # Handle special cases for files that go in home directory
    if [ -f "$CONFIG_DIR/bash/bashrc" ]; then
        echo "Linking .bashrc..."
        ln -sf "$CONFIG_DIR/bash/bashrc" "$HOME/.bashrc"
    fi
    
    if [ -f "$CONFIG_DIR/git/gitconfig" ]; then
        echo "Linking .gitconfig..."
        ln -sf "$CONFIG_DIR/git/gitconfig" "$HOME/.gitconfig"
    fi
    
    if [ -f "$CONFIG_DIR/tmux/tmux.conf" ]; then
        echo "Linking .tmux.conf..."
        ln -sf "$CONFIG_DIR/tmux/tmux.conf" "$HOME/.tmux.conf"
    fi
    
    echo "Configuration installation complete!"
}

show_status() {
    echo "Configuration Status:"
    echo "====================="
    echo "XDG_CONFIG_HOME: $XDG_CONFIG_HOME"
    echo "Config source:   $CONFIG_DIR"
    echo ""
    
    for config_app in "$CONFIG_DIR"/*; do
        if [ -d "$config_app" ]; then
            app_name=$(basename "$config_app")
            target_dir="$XDG_CONFIG_HOME/$app_name"
            
            if [ -d "$target_dir" ]; then
                echo "✓ $app_name - Installed"
            else
                echo "✗ $app_name - Not installed"
            fi
        fi
    done
    
    # Check special files
    for file in .bashrc .gitconfig .tmux.conf; do
        if [ -L "$HOME/$file" ] && [ -e "$HOME/$file" ]; then
            echo "✓ $file - Linked"
        elif [ -f "$HOME/$file" ]; then
            echo "~ $file - File exists (not linked)"
        else
            echo "✗ $file - Not found"
        fi
    done
}

case "${1:-help}" in
    install)
        install_configs
        ;;
    backup)
        backup_configs
        ;;
    status)
        show_status
        ;;
    help|--help|-h)
        usage
        ;;
    *)
        echo "Unknown command: $1"
        echo ""
        usage
        exit 1
        ;;
esac