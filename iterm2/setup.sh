#!/bin/bash
# iTerm2 configuration setup
# Configures iTerm2 to load preferences from dotfiles

DOTFILES_DIR="$HOME/dev/dotfiles"

echo "Setting up iTerm2 configuration..."

# Tell iTerm2 to use custom preferences folder
defaults write com.googlecode.iterm2 PrefsCustomFolder -string "$DOTFILES_DIR/iterm2"
defaults write com.googlecode.iterm2 LoadPrefsFromCustomFolder -bool true

echo "   ✅ iTerm2 configured to load preferences from $DOTFILES_DIR/iterm2"
echo "   Note: Restart iTerm2 for changes to take effect"
