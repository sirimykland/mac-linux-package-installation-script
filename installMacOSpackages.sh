#!/bin/sh

# HomeBrew
echo "##################################"
echo "            Homebrew              "
echo "##################################"
if test ! "$(which brew)"; then
    echo "Installing homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    (echo; echo 'eval "$(/opt/homebrew/bin/brew shellenv)"') >> /Users/Siri.Mykland/.profile
    eval "$(/opt/homebrew/bin/brew shellenv)"

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
  spotify
  visual-studio-code
  intellij-idea
  vmware-horizon-client
  # Formulae
  tmux
  mosh
)


brew_exist() {
  if brew list -1 | grep $1 &>/dev/null; then 
    return 0
  else
    return 1
  fi
}

brew_install() {
    if brew_exist "$1"; then
        echo "${1} is already installed"
    else
        echo "\nInstalling $1"
        brew install "$1" && echo "\n"
    fi
}

for app in "${apps[@]}"; do
  brew_install "$app"
done

#Docker
brew install --cask docker


# Post brew install
brew cleanup


echo "\n##################################"
echo "              Node                "
echo "##################################"

brew_install nvm

(echo; echo 'export NVM_DIR="$HOME/.nvm"
  [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
  [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion') >> ~/.profile

source ~/.profile


if test "$(which node)" && brew_exist node; then
    echo "Uninstalling Node..."
    brew uninstall --ignore-dependencies node 
    brew uninstall node 
fi

if brew_exist nvm; then
  nvm install 18
  nvm install 22 --default
  echo "\nYou got these versions of node:"
  nvm ls --no-alias
fi



# oh-my-zsh
echo "\n##################################"
echo "            Oh-My-Zsh             "
echo "##################################"
zsh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
if -e ~/.zshrc.pre-oh-my-zsh ; then 
  mv ~/.zshrc.pre-oh-my-zsh  ~/.zshrc 
fi


source ~/.zshrc
