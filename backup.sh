#!/bin/bash
# Backup current dotfiles before running bootstrap
# Run this BEFORE bootstrap.sh if you want to preserve your current config

set -e

BACKUP_ROOT="$HOME/.dotfiles"
BACKUP_DIR="$BACKUP_ROOT/backup_$(date +%Y%m%d_%H%M%S)"

echo "🔒 Backing up current dotfiles to $BACKUP_DIR..."
mkdir -p "$BACKUP_DIR"

# Create a convenience symlink to the latest backup
ln -sfn "$BACKUP_DIR" "$BACKUP_ROOT/latest"

# Files to backup
files=(
  ".zshrc"
  ".zshenv"
  ".zprofile"
  ".p10k.zsh"
  ".zsh_custom_aliases"
  ".zsh_custom_functions"
  ".gitconfig"
  ".gitmessage"
  ".npmrc"
  ".secrets"
  ".bash_profile"
  ".bashrc"
)

# Backup individual dotfiles
for file in "${files[@]}"; do
  if [[ -f "$HOME/$file" || -L "$HOME/$file" ]]; then
    cp -L "$HOME/$file" "$BACKUP_DIR/" 2>/dev/null && echo "   ✅ $file"
  fi
done

# Backup .ssh directory
if [[ -d "$HOME/.ssh" ]]; then
  echo "   📁 Backing up .ssh..."
  cp -R "$HOME/.ssh" "$BACKUP_DIR/" 2>/dev/null && echo "   ✅ .ssh"
fi

# Backup .oh-my-zsh (exclude cache)
if [[ -d "$HOME/.oh-my-zsh" ]]; then
  echo "   📁 Backing up .oh-my-zsh (excluding cache)..."
  mkdir -p "$BACKUP_DIR/.oh-my-zsh"
  rsync -a --exclude='cache' --exclude='.git' "$HOME/.oh-my-zsh/" "$BACKUP_DIR/.oh-my-zsh/" 2>/dev/null && echo "   ✅ .oh-my-zsh"
fi

# Backup .nvm (only config and alias, not installed versions or cache)
if [[ -d "$HOME/.nvm" ]]; then
  echo "   📁 Backing up .nvm config (excluding installed versions and cache)..."
  mkdir -p "$BACKUP_DIR/.nvm"
  # Only backup the essential files, not the huge versions directory
  for item in alias default-packages .npmrc; do
    if [[ -e "$HOME/.nvm/$item" ]]; then
      cp -R "$HOME/.nvm/$item" "$BACKUP_DIR/.nvm/" 2>/dev/null
    fi
  done
  echo "   ✅ .nvm (config only - Node versions can be reinstalled)"
fi

# Backup your custom tools
if [[ -d "$HOME/dev/tools" ]]; then
  echo "   📁 Backing up ~/dev/tools..."
  cp -R "$HOME/dev/tools" "$BACKUP_DIR/dev_tools" 2>/dev/null && echo "   ✅ dev/tools"
fi

# Create a restore script in the backup directory
cat > "$BACKUP_DIR/restore.sh" << 'RESTORE_EOF'
#!/bin/bash
# Restore script - run this to revert to your backed up dotfiles
# Usage: ./restore.sh

BACKUP_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "⚠️  This will restore your dotfiles from $BACKUP_DIR"
echo "   This will OVERWRITE your current dotfiles."
read -p "Are you sure? (y/n) " -n 1 -r
echo ""

if [[ ! $REPLY =~ ^[Yy]$ ]]; then
  echo "Cancelled."
  exit 0
fi

echo "🔄 Restoring dotfiles..."

# Remove stow symlinks first (if they exist)
if command -v stow &> /dev/null && [[ -d "$HOME/dev/dotfiles" ]]; then
  cd "$HOME/dev/dotfiles"
  stow -D zsh git npm 2>/dev/null || true
fi

# Restore files
for file in "$BACKUP_DIR"/.*; do
  filename=$(basename "$file")
  if [[ "$filename" != "." && "$filename" != ".." && -f "$file" ]]; then
    cp "$file" "$HOME/" && echo "   ✅ Restored $filename"
  fi
done

# Restore .ssh
if [[ -d "$BACKUP_DIR/.ssh" ]]; then
  rm -rf "$HOME/.ssh"
  cp -R "$BACKUP_DIR/.ssh" "$HOME/" && echo "   ✅ Restored .ssh"
fi

# Restore .oh-my-zsh
if [[ -d "$BACKUP_DIR/.oh-my-zsh" ]]; then
  rm -rf "$HOME/.oh-my-zsh"
  cp -R "$BACKUP_DIR/.oh-my-zsh" "$HOME/" && echo "   ✅ Restored .oh-my-zsh"
fi

# Restore .nvm config (will need to reinstall Node versions)
if [[ -d "$BACKUP_DIR/.nvm" ]]; then
  mkdir -p "$HOME/.nvm"
  cp -R "$BACKUP_DIR/.nvm/"* "$HOME/.nvm/" 2>/dev/null && echo "   ✅ Restored .nvm config"
  echo "   ⚠️  Note: You'll need to reinstall Node versions with 'nvm install <version>'"
fi

# Restore dev/tools
if [[ -d "$BACKUP_DIR/dev_tools" ]]; then
  rm -rf "$HOME/dev/tools"
  cp -R "$BACKUP_DIR/dev_tools" "$HOME/dev/tools" && echo "   ✅ Restored dev/tools"
fi

echo ""
echo "✅ Restore complete! Run 'exec zsh' to reload your shell."
RESTORE_EOF

chmod +x "$BACKUP_DIR/restore.sh"

echo ""
echo "✅ Backup complete!"
echo ""
echo "Backup location: $BACKUP_DIR"
echo "Latest symlink:  $BACKUP_ROOT/latest"
echo ""
echo "To restore later, run:"
echo "   ~/.dotfiles/latest/restore.sh"
echo ""
echo "You can now safely run ./bootstrap.sh"
