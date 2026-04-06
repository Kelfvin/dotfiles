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

