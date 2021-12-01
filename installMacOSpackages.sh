#!/bin/sh

# HomeBrew
echo "##################################"
echo "            Homebrew              "
echo "##################################"
if test ! $(which brew); then
    echo "Installing homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
else
    # Update homebrew
    echo "Updating homebrew..." && brew update
fi

# Apps to install Globally
echo "\n##################################"
echo "          Brew packages           "
echo "##################################"
apps=(
  # Casks - UI-based apps
  iterm2
  rectangle
  postman
  google-chrome
  slack
  spotify
  visual-studio-code
  intellij-idea
  intellij-idea-ce
  microsoft-teams
  microsoft-outlook
  1password
  # Formulae
  kotlin
  docker
  tmux
  nvm
  jenv
  mosh
  awscli
  AdoptOpenJDK/openjdk/adoptopenjdk{8,11,14}
)

brew_exist() {
  if brew list -1 | grep $1 &>/dev/null; then 
    return 0
  else
    return 1
  fi
}

brew_install() {
    if brew_exist $1; then
        echo "${1} is already installed"
    else
        echo "\nInstalling $1"
        brew install $1 && echo "\n"
    fi
}

for app in ${apps[@]}; do
  brew_install $app
done

# Post brew install
brew cleanup

# npm and node
echo "\n##################################"
echo "              Node                "
echo "##################################"

if test $(which node) && brew_exist node; then
    echo "Uninstalling Node..."
    brew uninstall --ignore-dependencies node 
    brew uninstall node 
fi
if test brew_exist nvm; then
  nvm install-latest-npm && echo "Installed npm ${npm -v}"
  nvm install 12 && echo "Installed node ${nvm list | grep v12 -m1}"
  nvm install 14 && echo "Installed node ${nvm list | grep v14 -m1}"
fi

# java
echo "\n##################################"
echo "              Java                "
echo "##################################"
if brew_exist jenv ; then 
  jenv add /Library/Java/JavaVirtualMachines/adoptopenjdk-14.jdk/Contents/Home
  jenv add /Library/Java/JavaVirtualMachines/adoptopenjdk-11.jdk/Contents/Home
  jenv add /Library/Java/JavaVirtualMachines/adoptopenjdk-8.jdk/Contents/Home
fi

# oh-my-zsh
echo "\n##################################"
echo "            Oh-My-Zsh             "
echo "##################################"
zsh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
if -e ~/.zshrc.pre-oh-my-zsh ; then mv ~/.zshrc.pre-oh-my-zsh  ~/.zshrc fi
source ~/.zshrc
