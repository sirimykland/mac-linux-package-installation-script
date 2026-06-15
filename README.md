# Installation script for Mac and Linux

This script automates the installation of development tools and applications. On
macOS it uses [Homebrew](https://brew.sh); on Linux it uses `apt` and `snap`.
Run `./install.sh` and it detects your OS and runs the matching installer.

## Packages installed

### macOS (Homebrew)

**Casks (UI Applications):**
- iterm2
- rectangle
- postman
- google-chrome
- spotify
- visual-studio-code
- intellij-idea
- bambu-studio

**Formulae (CLI Tools):**
- tmux
- mosh
- asdf
- maven

### Linux (apt + snap)

**apt (CLI tools):**
- tmux
- mosh
- curl
- git
- zsh
- maven
- docker.io

**snap (desktop apps):**
- postman
- google-chrome
- spotify
- code
- intellij-idea-ultimate

On Linux the script also installs `zsh` and sets it as the default shell.

### Version Managers & Runtimes (both platforms)

**asdf** manages language runtimes (installed as a single binary; activated via
its shims directory on `PATH`):
- Node.js 26.1.0
- Java (Temurin) 25.0.3 LTS

**oh-my-zsh** is installed for shell management.

More Brew packages available at [formulae.brew.sh](https://formulae.brew.sh/).

## How to use

### Prerequisites
- macOS or Linux
- An internet connection (Homebrew / apt / snap and oh-my-zsh are fetched online)

### Installation

```bash
./install.sh
```

The script will:
1. Install/update the package manager (Homebrew on macOS, `apt` on Linux)
2. Prompt you to confirm each package (`y/n`) before installing anything
3. Install the selected packages
4. Set up oh-my-zsh
5. Install asdf and configure Node.js and Java
6. Clean up the package manager cache

Each package is confirmed individually, so it is safe to decline anything you
already have.

### Post-installation: Link dotfiles

After running the installation script, set up your shell configuration:

```bash
git clone https://github.com/sirimykland/dotfiles.git ~/.dotfiles
~/.dotfiles/makesymlinks.sh zsh
```

This will symlink your shell config files (`.zshrc`, `.zsh_omz`, `.zsh_aliases`) to your home directory.

## Shell configuration

For complete shell setup including zsh config, aliases, and local settings, see the [dotfiles repository](https://github.com/sirimykland/dotfiles).

