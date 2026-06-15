#!/usr/bin/env bash

# Common functions and setup shared between macOS and Linux installation scripts.

# Node.js and Java versions managed by asdf
NODEJS_VERSION="26.1.0"
JAVA_VERSION="temurin-25.0.3+9.0.LTS"

confirm_install() {
  local app="$1"
  printf "Install %s? (y/n) " "$app"
  read -r response
  case "$response" in
    [Yy]) return 0 ;;
    *) return 1 ;;
  esac
}

install_ohmyzsh() {
  echo ""
  echo "##################################"
  echo "            Oh-My-Zsh             "
  echo "##################################"
  if [ -d "$HOME/.oh-my-zsh" ]; then
    echo "oh-my-zsh is already installed"
  else
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
  fi
}

# Activate asdf in the current shell. asdf 0.16+ is a single Go binary that is
# activated by putting its shims directory on PATH (there is no asdf.sh).
activate_asdf() {
  export ASDF_DATA_DIR="${ASDF_DATA_DIR:-$HOME/.asdf}"
  export PATH="$ASDF_DATA_DIR/shims:$PATH"
}

setup_asdf() {
  echo ""
  echo "##################################"
  echo "              asdf                "
  echo "##################################"

  # Persist asdf shims on PATH for future shells (via ~/.profile, which is
  # sourced by both bash and the dotfiles .zshrc).
  if ! grep -q 'asdf/shims' "$HOME/.profile" 2>/dev/null; then
    {
      echo ''
      echo 'export ASDF_DATA_DIR="$HOME/.asdf"'
      echo 'export PATH="$ASDF_DATA_DIR/shims:$PATH"'
    } >> "$HOME/.profile"
  fi

  activate_asdf

  # Add asdf plugins
  asdf plugin add nodejs https://github.com/asdf-vm/asdf-nodejs.git 2>/dev/null || true
  asdf plugin add java https://github.com/halcyon/asdf-java.git 2>/dev/null || true

  # Install Node version
  echo "Installing Node.js $NODEJS_VERSION..."
  asdf install nodejs "$NODEJS_VERSION"
  asdf set --home nodejs "$NODEJS_VERSION"

  echo ""
  echo "Installed Node version:"
  asdf list nodejs

  # Install Java version
  echo ""
  echo "Installing Java $JAVA_VERSION..."
  asdf install java "$JAVA_VERSION"
  asdf set --home java "$JAVA_VERSION"

  echo ""
  echo "Installed Java version:"
  asdf list java
}

print_completion() {
  echo ""
  echo "##################################"
  echo "      Installation complete!      "
  echo "##################################"
}
