#!/usr/bin/env bash

set -e

# Source common functions
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common.sh"

# Apps to install Globally
apps=(
  # Casks - UI-based apps
  iterm2
  rectangle
  postman
  google-chrome
  spotify
  visual-studio-code
  intellij-idea
  bambu-studio
  # Formulae
  tmux
  mosh
  asdf
  maven
)

brew_exist() {
  if brew list -1 | grep -qx "$1"; then 
    return 0
  else
    return 1
  fi
}

brew_install() {
    if brew_exist "$1"; then
        echo "${1} is already installed"
    else
        echo "Installing $1"
        brew install "$1"
    fi
}

# HomeBrew
echo "##################################"
echo "            Homebrew              "
echo "##################################"

# Homebrew's prefix differs by architecture:
#   Apple Silicon -> /opt/homebrew, Intel -> /usr/local
if [ "$(uname -m)" = "arm64" ]; then
    BREW_PREFIX="/opt/homebrew"
else
    BREW_PREFIX="/usr/local"
fi

if test ! "$(which brew)"; then
    echo "Installing homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    (echo; echo "eval \"\$($BREW_PREFIX/bin/brew shellenv)\"") >> "$HOME/.profile"
    eval "$("$BREW_PREFIX/bin/brew" shellenv)"

else
    # Update homebrew
    echo "Updating homebrew..." && brew update
fi

# Apps to install
echo ""
echo "##################################"
echo "          Brew packages           "
echo "##################################"

# Ask for confirmation on apps that are not already installed
selected_apps=()
for app in "${apps[@]}"; do
  if brew_exist "$app"; then
    echo "$app is already installed, skipping"
    continue
  fi
  if confirm_install "$app"; then
    selected_apps+=("$app")
  fi
done

# Install all selected apps
echo ""
echo "##################################"
echo "        Installing packages       "
echo "##################################"
for app in "${selected_apps[@]}"; do
  brew_install "$app"
done

# Post brew install
brew cleanup

# Common setup
install_ohmyzsh
setup_asdf

print_completion
