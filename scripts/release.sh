#!/usr/bin/env bash

# For more info about the 'set' command, see
# https://www.gnu.org/software/bash/manual/bash.html#The-Set-Builtin
set -e
set -u

if [[ -n $(git status -s) ]]; then
  echo "There are uncommitted changes in the current directory, please commit them first."
  exit 1
fi

read -p "Enter the next version (format: X.X.X): " next_version

echo "$next_version" > .version

# Replace the current version in helper/Cargo.toml with the new version
sed -E -i '' "s/^version = \"[0-9]+\.[0-9]+\.[0-9]+\"$/version = \"$next_version\"/" helper/Cargo.toml

# Run vimdoc if it's installed to make sure all documentation is generated.
if command -v vimdoc >/dev/null 2>&1; then
  "Running vimdoc..."
  vimdoc .
fi

echo "Done"
