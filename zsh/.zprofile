# Kiro CLI pre block. Keep at the top of this file.
[[ -f "${HOME}/Library/Application Support/kiro-cli/shell/zprofile.pre.zsh" ]] && builtin source "${HOME}/Library/Application Support/kiro-cli/shell/zprofile.pre.zsh"

# Add Homebrew to shell PATH
eval "$(/opt/homebrew/bin/brew shellenv)"

# Java (if installed via Homebrew)
if [[ -d "/opt/homebrew/opt/openjdk" ]]; then
  export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"
  export JAVA_HOME="/opt/homebrew/opt/openjdk"
fi

# Kiro CLI post block. Keep at the bottom of this file.
[[ -f "${HOME}/Library/Application Support/kiro-cli/shell/zprofile.post.zsh" ]] && builtin source "${HOME}/Library/Application Support/kiro-cli/shell/zprofile.post.zsh"
