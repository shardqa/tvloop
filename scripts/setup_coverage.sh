#!/bin/bash

export PATH="$HOME/.local/share/gem/ruby/3.4.0/gems/bashcov-3.2.0/bin:$PATH"

if command -v bashcov >/dev/null 2>&1; then
    echo "bashcov is available at: $(which bashcov)"
    echo "You can now run: make test-coverage"
else
    echo "bashcov not found. Install with: gem install --user-install bashcov"
    exit 1
fi
