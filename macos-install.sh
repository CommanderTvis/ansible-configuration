#!/bin/bash
set -euo pipefail

if [[ "$(uname -s)" != Darwin || "$(uname -m)" != arm64 ]]; then
    echo "Error: This setup requires Apple Silicon macOS."
    exit 1
fi

if [[ "$(id -u)" == 0 ]]; then
    echo "Error: Run this script as your normal user, without sudo."
    exit 1
fi

# Keep installer and playbook prompts connected to Terminal,
# including when the script itself is downloaded through a pipe.
exec </dev/tty

CHECKOUT="$HOME/ansible-configuration"
if [[ -e "$CHECKOUT" || -L "$CHECKOUT" ]]; then
    echo "Error: $CHECKOUT already exists. To apply an existing checkout, run:"
    printf '  cd "%s" && ./build.sh\n' "$CHECKOUT"
    exit 1
fi

if [[ ! -x /opt/homebrew/bin/brew ]]; then
    echo "Installing Homebrew and Apple Command Line Tools if needed..."
    INSTALLER="$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    /bin/bash -c "$INSTALLER"
    unset INSTALLER
fi

eval "$(/opt/homebrew/bin/brew shellenv)"
export HOMEBREW_NO_ASK=1
brew install git

git clone https://github.com/CommanderTvis/ansible-configuration.git "$CHECKOUT"
cd "$CHECKOUT"
exec /bin/bash ./build.sh "$@"
