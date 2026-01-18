#!/bin/bash
# Spotlight configuration script
#
# NOTE: This script is a no-op since you already use Raycast on ⌘Space.
# Keeping this file for documentation purposes.
#
# If you ever need to rebind Spotlight to ⌥Space, uncomment the lines below.

echo "Spotlight: No changes needed (you already use Raycast on ⌘Space)."

# Uncomment below to rebind Spotlight to ⌥Space:
# /usr/libexec/PlistBuddy ~/Library/Preferences/com.apple.symbolichotkeys.plist \
#   -c "Delete :AppleSymbolicHotKeys:64" 2>/dev/null
#
# /usr/libexec/PlistBuddy ~/Library/Preferences/com.apple.symbolichotkeys.plist \
#   -c "Add :AppleSymbolicHotKeys:64:enabled bool true" \
#   -c "Add :AppleSymbolicHotKeys:64:value:parameters array" \
#   -c "Add :AppleSymbolicHotKeys:64:value:parameters: integer 32" \
#   -c "Add :AppleSymbolicHotKeys:64:value:parameters: integer 49" \
#   -c "Add :AppleSymbolicHotKeys:64:value:parameters: integer 524288" \
#   -c "Add :AppleSymbolicHotKeys:64:value:type string standard"
