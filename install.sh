#!/usr/bin/env bash

# For more info about the 'set' command, see
# https://www.gnu.org/software/bash/manual/bash.html#The-Set-Builtin
set -e
set -u

ROOT_DIR="`dirname \"$0\"`"
cd $ROOT_DIR

parsers=($*)
packages=()
for lang in "${parsers[@]}"; do
  package_name="tree-sitter-$lang"
  echo "Preparing to install package: $package_name"
  packages+=($package_name)
done

if [[ ! -d ./node_packages ]]; then
  npm i --only=production --no-save
fi

if [[ "${packages[@]}" != "" ]]; then
  npm i --no-save ${packages[@]}
fi

if [[ ! -f ./dist/index.js ]]; then
  npm run build
fi
