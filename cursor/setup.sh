#!/bin/bash
# Cursor configuration setup
# Links settings and keybindings to Cursor's User directory

DOTFILES_DIR="$HOME/dev/dotfiles"
CURSOR_USER_DIR="$HOME/Library/Application Support/Cursor/User"

echo "Setting up Cursor configuration..."

# Create Cursor User directory if it doesn't exist
mkdir -p "$CURSOR_USER_DIR"

# Backup existing settings if they exist and aren't symlinks
if [[ -f "$CURSOR_USER_DIR/settings.json" && ! -L "$CURSOR_USER_DIR/settings.json" ]]; then
  mv "$CURSOR_USER_DIR/settings.json" "$CURSOR_USER_DIR/settings.json.backup"
  echo "   Backed up existing settings.json"
fi

if [[ -f "$CURSOR_USER_DIR/keybindings.json" && ! -L "$CURSOR_USER_DIR/keybindings.json" ]]; then
  mv "$CURSOR_USER_DIR/keybindings.json" "$CURSOR_USER_DIR/keybindings.json.backup"
  echo "   Backed up existing keybindings.json"
fi

# Create symlinks
ln -sf "$DOTFILES_DIR/cursor/User/settings.json" "$CURSOR_USER_DIR/settings.json"
ln -sf "$DOTFILES_DIR/cursor/User/keybindings.json" "$CURSOR_USER_DIR/keybindings.json"

echo "   ✅ Cursor settings and keybindings linked"
