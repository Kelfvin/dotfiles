#!/bin/bash

set -euo pipefail

# SSH archives contain private keys. Require an explicit encryption method
# instead of silently writing plaintext credentials to a sync folder.
if ! command -v gpg >/dev/null 2>&1; then
  echo "Error: gpg is required to encrypt the SSH backup." >&2
  exit 1
fi

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
umask 077

SSH_ARCHIVE="$SSH_BACKUP_DIR/ssh_backup_${TIMESTAMP}.tar.gz.gpg"
RECIPIENT="${DOTFILES_BACKUP_GPG_RECIPIENT:-}"

if [ -z "$RECIPIENT" ]; then
  echo "Error: set DOTFILES_BACKUP_GPG_RECIPIENT to a GPG key before backing up .ssh." >&2
  echo "Example: export DOTFILES_BACKUP_GPG_RECIPIENT='you@example.com'" >&2
  exit 1
fi

# Exclude transient sockets and local caches; encrypt the stream before it is
# written to the synchronized directory.
echo "Encrypting .ssh backup..."
if ! tar --exclude='*.sock' --exclude='known_hosts.old' -czf - -C "$HOME" .ssh \
  | gpg --batch --yes --trust-model always --recipient "$RECIPIENT" --output "$SSH_ARCHIVE"; then
  rm -f "$SSH_ARCHIVE"
  echo "Error: SSH backup failed." >&2
  exit 1
fi

chmod 600 "$SSH_ARCHIVE"
echo ".ssh backup complete: $SSH_ARCHIVE"
