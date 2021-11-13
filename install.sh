#!/bin/sh


abort() {
  printf "%s\n" "$@"
  exit 1
}

# First check OS.
OS="$(uname)"
if [[ "${OS}" == "Linux" ]]
then
    echo "Detected Linux"
    installLinuxPackages.sh
elif [[ "${OS}" == "Darwin" ]]
then
     echo "Detected MacOS"
    installMacOSpackages.sh
elif [[ "${OS}" != "Darwin" ]]
then
  abort "This script is only supported on macOS and Linux."
fi
