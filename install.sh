#!/usr/bin/env bash

# For more info about the 'set' command, see
# https://www.gnu.org/software/bash/manual/bash.html#The-Set-Builtin
set -e
set -u

[[ -e ./bin/vim-doge ]] && exit 0

ROOT_DIR="$(cd "$(dirname "$0")"; pwd -P)"
cd $ROOT_DIR
mkdir ./bin

OS="$(uname)"
OUTFILE="./bin/vim-doge"

if [[ "$OS" == 'Linux' ]]; then
  SED_EXTENDED='-r'
elif [[ "$OS" == 'Darwin' ]]; then
  SED_EXTENDED='-E'
fi;
PKG_VERSION=$(grep -m 1 "\"version\"" $ROOT_DIR/package.json | sed ${SED_EXTENDED} 's/^ *//;s/.*: *"//;s/",?//')
RELEASE_URL="https://github.com/kkoomen/vim-doge/releases/download/$PKG_VERSION"
echo "$RELEASE_URL"

if [[ $OS == 'Darwin' ]]; then
  VIM_DOGE_EXECUTABLE_URL="$RELEASE_URL/vim-doge-macos"
elif [[ $OS == 'Linux' ]]; then
  VIM_DOGE_EXECUTABLE_URL="$RELEASE_URL/vim-doge-linux"
else
  VIM_DOGE_EXECUTABLE_URL="$RELEASE_URL/vim-doge-win.exe"
fi

echo "Downloading $VIM_DOGE_EXECUTABLE_URL..."
curl -L -s $VIM_DOGE_EXECUTABLE_URL > $OUTFILE
echo "[Done] downloading $VIM_DOGE_EXECUTABLE_URL"

"Setting permissions"
chmod +x $OUTFILE
"[Done] Setting permissions"
