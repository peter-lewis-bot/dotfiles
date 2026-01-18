#!/bin/bash
# Dock configuration script
# Called by bootstrap.sh

echo "Configuring Dock..."

# NOTE: This script does NOT clear your Dock apps - it only adjusts behavior settings

# Set Dock to auto-hide
defaults write com.apple.dock autohide -bool true

# Remove auto-hide delay
defaults write com.apple.dock autohide-delay -float 0

# Faster auto-hide animation
defaults write com.apple.dock autohide-time-modifier -float 0.3

# Set Dock icon size (36 is a reasonable small size, 16 is minimum)
defaults write com.apple.dock tilesize -int 36

# Enable magnification on hover
defaults write com.apple.dock magnification -bool true

# Set magnification size
defaults write com.apple.dock largesize -int 80

# Don't show recent apps in Dock
defaults write com.apple.dock show-recents -bool false

# Restart Dock to apply changes
killall Dock

echo "Dock configured (auto-hide enabled, smaller icons, your apps preserved)."
