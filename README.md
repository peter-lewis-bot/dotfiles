# Dotfiles

Personal dotfiles for macOS, managed with [GNU Stow](https://www.gnu.org/software/stow/).

## Features

- **Zinit** - Fast, flexible Zsh plugin manager
- **Powerlevel10k** - Beautiful, fast Zsh prompt
- **fnm** - Fast Node Manager (replaces nvm, ~40x faster)
- **Corepack** - Automatic package manager version management (pnpm, yarn)
- **Modern CLI tools** - eza, bat, fd, fzf, zoxide, delta, lazygit
- **Git integration** - Delta for syntax-highlighted diffs, Cursor as diff/merge tool
- **macOS configuration** - Sensible defaults for Dock, Finder, keyboard, etc.

## Quick Start

```bash
# Clone the repo
git clone https://github.com/YOUR_USERNAME/dotfiles.git ~/dev/dotfiles

# Run the bootstrap script
cd ~/dev/dotfiles
./bootstrap.sh
```

## What Gets Installed

### CLI Tools
| Tool | Description |
|------|-------------|
| `bat` | Better `cat` with syntax highlighting |
| `eza` | Better `ls` with icons and git status |
| `fd` | Better `find` |
| `fnm` | Fast Node Manager |
| `fzf` | Fuzzy finder |
| `gh` | GitHub CLI |
| `git-delta` | Better git diff |
| `lazygit` | Terminal UI for git |
| `zoxide` | Smarter `cd` command |
| `stow` | Symlink manager |
| `uv` | Fast Python package manager |

### Apps
- **Productivity**: 1Password, Notion, Raycast, Rectangle, Zoom
- **Development**: Cursor, DataGrip, Docker Desktop, GitHub Desktop, iTerm2, Postman, ngrok
- **AI**: Claude, ChatGPT
- **Browsers**: Google Chrome, Helium Browser
- **Utilities**: Logi Options+

## Structure

```
dotfiles/
├── zsh/                    # Shell configuration
│   ├── .zshrc              # Main config (Zinit, plugins, integrations)
│   ├── .zshenv             # Environment variables, secrets sourcing
│   ├── .zprofile           # Login shell (Homebrew, Java)
│   ├── .p10k.zsh           # Powerlevel10k theme
│   ├── .zsh_custom_aliases # Aliases
│   ├── .zsh_custom_functions # Custom functions
│   └── .secrets            # Tokens (gitignored)
├── git/                    # Git configuration
│   ├── .gitconfig          # Git config with delta
│   └── .gitmessage         # Commit message template
├── npm/                    # NPM configuration
│   └── .npmrc
├── macos/                  # macOS preference scripts
│   ├── dock.sh
│   ├── finder.sh
│   ├── keyboard.sh
│   ├── screenshots.sh
│   ├── spotlight.sh
│   └── system.sh
├── Brewfile                # Homebrew dependencies
├── bootstrap.sh            # Setup script
└── README.md
```

## Symlinks

Stow creates these symlinks in your home directory:

| Source | Target |
|--------|--------|
| `zsh/.zshrc` | `~/.zshrc` |
| `zsh/.zshenv` | `~/.zshenv` |
| `zsh/.zprofile` | `~/.zprofile` |
| `zsh/.p10k.zsh` | `~/.p10k.zsh` |
| `zsh/.zsh_custom_aliases` | `~/.zsh_custom_aliases` |
| `zsh/.zsh_custom_functions` | `~/.zsh_custom_functions` |
| `zsh/.secrets` | `~/.secrets` |
| `git/.gitconfig` | `~/.gitconfig` |
| `git/.gitmessage` | `~/.gitmessage` |
| `npm/.npmrc` | `~/.npmrc` |

## Custom Functions

| Function | Description |
|----------|-------------|
| `aws-profile` | Interactive AWS profile selector with fzf |
| `envit [file]` | Load .env file into shell environment |
| `findport <port>` | Find process on a port |
| `kill-process-by-port <port>` | Kill process on a port |
| `vpnstart` / `vpnstop` | GLG WireGuard VPN |
| `myip` | Display public IP |
| `generatesecret [length]` | Generate random string |
| `mkcd <dir>` | Create directory and cd into it |
| `serve [port]` | Quick HTTP server |
| `extract <file>` | Extract any archive |

## Aliases

### Modern CLI
```bash
ls    → eza --icons --group-directories-first
ll    → eza -la --icons --group-directories-first --git
cat   → bat --paging=never
find  → fd
```

### Git
```bash
g, gs, gd, ga, gc, gcm, gp, gl, gco, gcb, gb, glog, gst, gstp, lg
```

### pnpm
```bash
p, pi, pa, pad, prm, px, pd, pb, pt, pex
```

### Docker
```bash
d, dc, dcu, dcd, dcr, dps, dpsa
```

## Secrets

Create `zsh/.secrets` with your tokens (this file is gitignored):

```bash
export GITHUB_TOKEN=ghp_xxxx
export GITHUB_ACCESS_TOKEN=ghp_xxxx
export GLG_GITHUB_TOKEN=ghp_xxxx
export GITHUB_PACKAGE_REGISTRY_TOKEN=ghp_xxxx
export GH_PACKAGE_REGISTRY_READ_TOKEN=ghp_xxxx
```

## Manual Steps After Bootstrap

1. **Add your secrets** to `~/dev/dotfiles/zsh/.secrets`
2. **Restart terminal** or run `exec zsh`
3. **Reconfigure prompt** (optional): `p10k configure`
4. **Sign into apps**: 1Password, GitHub Desktop, Docker, etc.

## Updating

```bash
cd ~/dev/dotfiles
git pull
brew bundle
```

## Removing a Stow Package

```bash
cd ~/dev/dotfiles
stow -D zsh  # Removes zsh symlinks
```

## Credits

Inspired by [chrishuman0923/dotfiles](https://github.com/chrishuman0923/dotfiles).
