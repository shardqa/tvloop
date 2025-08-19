#!/bin/bash

BASHCOV_PATH="$HOME/.local/share/gem/ruby/3.4.0/gems/bashcov-3.2.0/bin"
SHELL_CONFIG=""

if [[ -f "$HOME/.zshrc" ]]; then
    SHELL_CONFIG="$HOME/.zshrc"
elif [[ -f "$HOME/.bashrc" ]]; then
    SHELL_CONFIG="$HOME/.bashrc"
elif [[ -f "$HOME/.bash_profile" ]]; then
    SHELL_CONFIG="$HOME/.bash_profile"
else
    echo "No shell configuration file found. Please add this line to your shell config:"
    echo "export PATH=\"$BASHCOV_PATH:\$PATH\""
    exit 1
fi

if grep -q "bashcov" "$SHELL_CONFIG"; then
    echo "bashcov PATH already configured in $SHELL_CONFIG"
else
    echo "" >> "$SHELL_CONFIG"
    echo "# bashcov coverage tool" >> "$SHELL_CONFIG"
    echo "export PATH=\"$BASHCOV_PATH:\$PATH\"" >> "$SHELL_CONFIG"
    echo "Added bashcov to PATH in $SHELL_CONFIG"
    echo "Please restart your shell or run: source $SHELL_CONFIG"
fi

echo "bashcov setup complete!"
echo "You can now run: make test-coverage"
