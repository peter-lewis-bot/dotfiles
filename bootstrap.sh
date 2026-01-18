#!/bin/bash
set -e

echo "🚀 Bootstrapping dotfiles..."

# Check for macOS
if [[ "$(uname)" != "Darwin" ]]; then
  echo "❌ This script is for macOS only"
  exit 1
fi

DOTFILES_DIR="$HOME/dev/dotfiles"

# Check if we're running from the right directory
if [[ ! -d "$DOTFILES_DIR" ]]; then
  echo "❌ Dotfiles directory not found at $DOTFILES_DIR"
  echo "   Please clone or move your dotfiles there first."
  exit 1
fi

cd "$DOTFILES_DIR"

# Install Homebrew if not present
if ! command -v brew &> /dev/null; then
  echo "📦 Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Install dependencies via Brewfile
echo "📦 Installing apps and tools from Brewfile..."
brew bundle --file="$DOTFILES_DIR/Brewfile"

# Backup existing dotfiles
BACKUP_DIR="$HOME/.dotfiles_backup_$(date +%Y%m%d_%H%M%S)"
echo "📁 Backing up existing dotfiles to $BACKUP_DIR..."
mkdir -p "$BACKUP_DIR"

# List of files to backup
backup_files=(
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
)

for file in "${backup_files[@]}"; do
  if [[ -f "$HOME/$file" || -L "$HOME/$file" ]]; then
    cp -L "$HOME/$file" "$BACKUP_DIR/" 2>/dev/null || true
    echo "   Backed up $file"
  fi
done

# Remove existing files that would conflict with stow
echo "🔗 Preparing for symlinks..."
for file in "${backup_files[@]}"; do
  rm -f "$HOME/$file"
done

# Create secrets file if it doesn't exist
if [[ ! -f "$DOTFILES_DIR/zsh/.secrets" ]]; then
  echo "🔐 Creating secrets file..."
  cat > "$DOTFILES_DIR/zsh/.secrets" << 'EOF'
# Secrets file - DO NOT COMMIT TO GIT
# This file is gitignored and should contain sensitive tokens

# GitHub tokens
# export GITHUB_TOKEN=ghp_xxxx
# export GITHUB_ACCESS_TOKEN=ghp_xxxx
# export GLG_GITHUB_TOKEN=ghp_xxxx
# export GITHUB_PACKAGE_REGISTRY_TOKEN=ghp_xxxx
# export GH_PACKAGE_REGISTRY_READ_TOKEN=ghp_xxxx

# Other secrets
# export AWS_ACCESS_KEY_ID=xxxx
# export AWS_SECRET_ACCESS_KEY=xxxx
EOF
  chmod 600 "$DOTFILES_DIR/zsh/.secrets"
  echo "   Created $DOTFILES_DIR/zsh/.secrets"
  echo "   ⚠️  Remember to add your tokens to this file!"
fi

# Run stow to create symlinks
echo "🔗 Creating symlinks with stow..."
stow -t ~ zsh git npm
echo "   ✅ Symlinks created"

# Setup fnm and Node
echo "📦 Setting up Node.js with fnm..."
eval "$(fnm env)"
fnm install --lts
fnm default lts-latest
echo "   ✅ Node.js $(node --version) installed"

# Enable corepack
echo "📦 Enabling corepack..."
if ! command -v corepack &> /dev/null; then
  npm install -g corepack
fi
corepack enable
echo "   ✅ Corepack enabled"

# Configure apps
echo "🔧 Configuring apps..."
"$DOTFILES_DIR/cursor/setup.sh"
"$DOTFILES_DIR/iterm2/setup.sh"
# Note: Raycast config contains tokens and syncs via cloud - not included in dotfiles
echo "   ✅ Apps configured"

# Ask about macOS configuration
echo ""
read -p "🖥️  Would you like to configure macOS settings? (y/n) " -n 1 -r
echo ""
if [[ $REPLY =~ ^[Yy]$ ]]; then
  echo "🖥️  Configuring macOS settings..."
  "$DOTFILES_DIR/macos/system.sh"
  "$DOTFILES_DIR/macos/dock.sh"
  "$DOTFILES_DIR/macos/finder.sh"
  "$DOTFILES_DIR/macos/keyboard.sh"
  "$DOTFILES_DIR/macos/screenshots.sh"
  "$DOTFILES_DIR/macos/spotlight.sh"
  echo "   ✅ macOS configured"
fi

echo ""
echo "✅ Bootstrap complete!"
echo ""
echo "Next steps:"
echo "  1. Add your secrets to: $DOTFILES_DIR/zsh/.secrets"
echo "     (Your old tokens were backed up to $BACKUP_DIR/.zshrc if they existed)"
echo "  2. Restart your terminal or run: exec zsh"
echo "  3. Run 'p10k configure' if you want to reconfigure your prompt"
echo ""
echo "Verification commands:"
echo "  zinit zstatus     # Check Zinit plugins"
echo "  fnm --version     # Check fnm"
echo "  node --version    # Check Node.js"
echo "  bat --version     # Check bat"
echo ""
