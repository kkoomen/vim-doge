#!/usr/bin/env bash

# For more info about the 'set' command, see
# https://www.gnu.org/software/bash/manual/bash.html#The-Set-Builtin
set -e
set -u

if [[ ! -d ./node_modules ]]; then
  npm install --only=production --no-save
fi

if [[ ! -f ./dist/index.js ]]; then
  npm run build:webpack
fi
