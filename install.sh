#!/usr/bin/env bash

set -e

abort() {
  printf "%s\n" "$@"
  exit 1
}

# Directory this script lives in, so the OS-specific scripts can be found
# regardless of where this script is invoked from.
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Detect OS and run the matching installer.
OS="$(uname)"
if [ "${OS}" = "Linux" ]; then
    echo "Detected Linux"
    "$SCRIPT_DIR/installLinuxPackages.sh"
elif [ "${OS}" = "Darwin" ]; then
    echo "Detected macOS"
    "$SCRIPT_DIR/installMacOSpackages.sh"
else
    abort "This script is only supported on macOS and Linux."
fi
