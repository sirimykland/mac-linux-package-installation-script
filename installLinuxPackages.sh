#!/usr/bin/env bash

set -e

# Source common functions
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common.sh"

# Apps to install Globally (apt/snap packages)
apps=(
  # Essential CLI tools
  tmux
  mosh
  curl
  git
  zsh
  maven
  docker.io
  # Desktop applications (via snap)
  postman
  google-chrome
  spotify
  code
  intellij-idea-ultimate
)

apt_exist() {
  if dpkg -l | grep -q "^ii.*$1"; then 
    return 0
  else
    return 1
  fi
}

snap_exist() {
  if snap list | grep -q "^$1 "; then
    return 0
  else
    return 1
  fi
}

apt_install() {
    if apt_exist "$1"; then
        echo "${1} is already installed"
    else
        echo "Installing $1"
        sudo apt-get install -y "$1"
    fi
}

# Snaps that require the --classic confinement flag
classic_snaps=("code" "intellij-idea-ultimate")

snap_install() {
    if snap_exist "$1"; then
        echo "${1} is already installed"
    else
        echo "Installing $1 via snap"
        if [[ " ${classic_snaps[*]} " =~ " $1 " ]]; then
            sudo snap install "$1" --classic
        else
            sudo snap install "$1"
        fi
    fi
}

# Update package manager
echo "##################################"
echo "        Package Manager           "
echo "##################################"
echo "Updating apt package lists..."
sudo apt-get update

# Apps to install
echo ""
echo "##################################"
echo "       Available packages         "
echo "##################################"

# Ask for confirmation on all apps first
selected_apt_apps=()
selected_snap_apps=()

# Separate snap-only apps
snap_only_apps=("postman" "google-chrome" "spotify" "code" "intellij-idea-ultimate")

for app in "${apps[@]}"; do
  # Check if this is a snap-only app
  if [[ " ${snap_only_apps[*]} " =~ " ${app} " ]]; then
    if snap_exist "$app"; then
      echo "$app is already installed, skipping"
      continue
    fi
    if confirm_install "$app"; then
      selected_snap_apps+=("$app")
    fi
  else
    if apt_exist "$app"; then
      echo "$app is already installed, skipping"
      continue
    fi
    if confirm_install "$app"; then
      selected_apt_apps+=("$app")
    fi
  fi
done

# Install selected apt packages
if [ ${#selected_apt_apps[@]} -gt 0 ]; then
  echo ""
  echo "##################################"
  echo "    Installing apt packages      "
  echo "##################################"
  for app in "${selected_apt_apps[@]}"; do
    apt_install "$app"
  done
fi

# Install selected snap packages
if [ ${#selected_snap_apps[@]} -gt 0 ]; then
  echo ""
  echo "##################################"
  echo "    Installing snap packages     "
  echo "##################################"
  for app in "${selected_snap_apps[@]}"; do
    snap_install "$app"
  done
fi

# Clean up apt cache
sudo apt-get clean

# Install asdf dependencies
echo ""
echo "Installing asdf dependencies..."
sudo apt-get install -y curl git build-essential libssl-dev libffi-dev

# Install asdf (single Go binary as of asdf 0.16+)
echo ""
echo "Installing asdf..."
if [ ! -x "$HOME/.local/bin/asdf" ]; then
    ASDF_VERSION="v0.19.0"
    case "$(uname -m)" in
        x86_64) ASDF_ARCH="amd64" ;;
        aarch64|arm64) ASDF_ARCH="arm64" ;;
        i386|i686) ASDF_ARCH="386" ;;
        *) echo "Unsupported architecture: $(uname -m)" >&2; exit 1 ;;
    esac

    mkdir -p "$HOME/.local/bin"
    tarball="asdf-${ASDF_VERSION}-linux-${ASDF_ARCH}.tar.gz"
    curl -fsSL -o "/tmp/$tarball" \
        "https://github.com/asdf-vm/asdf/releases/download/${ASDF_VERSION}/${tarball}"
    tar -xzf "/tmp/$tarball" -C "$HOME/.local/bin" asdf
    rm -f "/tmp/$tarball"

    # Ensure ~/.local/bin (where the asdf binary lives) is on PATH
    if ! grep -q '.local/bin' "$HOME/.profile" 2>/dev/null; then
        (echo; echo 'export PATH="$HOME/.local/bin:$PATH"') >> "$HOME/.profile"
    fi
    export PATH="$HOME/.local/bin:$PATH"
fi

# Common setup
install_ohmyzsh
setup_asdf

# Set zsh as default shell on Linux
if [ -x "$(command -v zsh)" ]; then
    echo ""
    echo "##################################"
    echo "      Setting zsh as default      "
    echo "##################################"
    if [ "$SHELL" != "$(command -v zsh)" ]; then
        echo "Changing default shell to zsh..."
        chsh -s "$(command -v zsh)"
        echo "Default shell changed to zsh. You may need to log out and back in."
    else
        echo "zsh is already the default shell"
    fi
fi

print_completion
