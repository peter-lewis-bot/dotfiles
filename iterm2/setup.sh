#!/bin/bash
# iTerm2 configuration setup
# Configures iTerm2 to load preferences from dotfiles

DOTFILES_DIR="$HOME/dev/dotfiles"

echo "Setting up iTerm2 configuration..."

# Tell iTerm2 to use custom preferences folder
defaults write com.googlecode.iterm2 PrefsCustomFolder -string "$DOTFILES_DIR/iterm2"
defaults write com.googlecode.iterm2 LoadPrefsFromCustomFolder -bool true

# Set font directly in iTerm2 defaults to ensure it takes effect immediately
# (custom prefs folder is only read on launch and may not override cached bookmarks)
/usr/libexec/PlistBuddy -c "Set ':New Bookmarks:0:Normal Font' 'MesloLGSNerdFontMono-Regular 13'" ~/Library/Preferences/com.googlecode.iterm2.plist 2>/dev/null
/usr/libexec/PlistBuddy -c "Set ':New Bookmarks:0:Non Ascii Font' 'MesloLGSNerdFontMono-Regular 12'" ~/Library/Preferences/com.googlecode.iterm2.plist 2>/dev/null

echo "   ✅ iTerm2 configured to load preferences from $DOTFILES_DIR/iterm2"
echo "   Note: Restart iTerm2 for changes to take effect"
