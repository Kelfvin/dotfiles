#!/bin/bash

set -e

#          ╭──────────────────────────────────────────────────────────╮
#          │                     Backup HomeBrew                      │
#          ╰──────────────────────────────────────────────────────────╯

TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BREW_BACKUP_DIR="$HOME/OneDrive/Backup/brew"
mkdir -p "$BREW_BACKUP_DIR"

echo "Dumping Brewfile..."
brew bundle dump --file="$HOME/Brewfile" --force

echo "Moving Brewfile to backup directory..."
mv "$HOME/Brewfile" "$BREW_BACKUP_DIR/Brewfile_${TIMESTAMP}"

echo "Backup complete: Brewfile_${TIMESTAMP}"

#          ╭──────────────────────────────────────────────────────────╮
#          │                        备份 .ssh                         │
#          ╰──────────────────────────────────────────────────────────╯

echo ""
echo "=== Backing up .ssh ==="
SSH_BACKUP_DIR="$HOME/OneDrive/Backup/ssh"
mkdir -p "$SSH_BACKUP_DIR"

echo "Compressing .ssh directory..."
tar -czf "$SSH_BACKUP_DIR/ssh_backup_${TIMESTAMP}.tar.gz" -C "$HOME" .ssh

echo ".ssh backup complete: ssh_backup_${TIMESTAMP}.tar.gz"
