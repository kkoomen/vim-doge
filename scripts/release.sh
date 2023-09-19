#!/usr/bin/env bash

# For more info about the 'set' command, see
# https://www.gnu.org/software/bash/manual/bash.html#The-Set-Builtin
set -e
set -u

if [[ -n $(git status -s) ]]; then
  echo "There are uncommitted changes in the current directory, please commit them first."
  exit 1
fi

current_version="$(cat helper/Cargo.toml | grep -E '^version = \"[0-9]+\.[0-9]+\.[0-9]+\"$' | sed -E 's/version = \"([0-9]+\.[0-9]+\.[0-9]+)\"/\1/g')"

echo "Current version: $current_version"
read -p "Enter the next version (format: X.X.X): " next_version

current_branch="$(git rev-parse --abbrev-ref HEAD)"
release_branch="release/v$next_version"
if [[ "$current_branch" != "$release_branch" ]]; then
  echo "Checking out to $release_branch"
  git checkout -b release/v$next_version
fi

echo "$next_version" > .version

# Replace the current version in helper/Cargo.toml with the new version.
sed -E -i '' "s/^version = \"[0-9]+\.[0-9]+\.[0-9]+\"$/version = \"$next_version\"/" helper/Cargo.toml

# Trigger a build so that the version will be applied to the Cargo.lock as well.
cd helper
cargo build
cd ..

# Run vimdoc if it's installed to make sure all documentation is generated.
if command -v vimdoc >/dev/null 2>&1; then
  echo "Running vimdoc..."
  vimdoc .
fi

git diff .version helper/Cargo.toml helper/Cargo.lock doc/doge.txt

echo "Committing the above changes..."
git add .version helper/Cargo.toml helper/Cargo.lock doc/doge.txt
git commit -m "chore(release): v$next_version :tada:"

echo "Done, make sure to push the above changes."
