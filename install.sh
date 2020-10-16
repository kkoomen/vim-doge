#!/usr/bin/env bash

# For more info about the 'set' command, see
# https://www.gnu.org/software/bash/manual/bash.html#The-Set-Builtin
set -e
set -u

[[ -e ./bin/vim-doge ]] && exit 0

ROOT_DIR="`dirname \"$0\"`"
cd $ROOT_DIR
mkdir ./bin

os="$(uname)"
outfile="./bin/vim-doge"

if [[ $os == "Darwin" ]]; then
  echo "TODO: macos"
  # curl "macos" > $outfile
elif [[ $os == "Linux" ]]; then
  echo "TODO: linux"
  # curl "linux" > $outfile
else
  echo "TODO: windows"
  # curl "windows" > $outfile
fi
