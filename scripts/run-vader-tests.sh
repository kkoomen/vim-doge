#!/usr/bin/env bash

# For more info about the 'set' command, see
# https://www.gnu.org/software/bash/manual/bash.html#The-Set-Builtin
set -e
set -u

ROOT_DIR=$(cd "$(dirname "$0")/.."; pwd -P)

vim="$1"
tests=${2:-"$ROOT_DIR/test/*.vader $ROOT_DIR/test/commands/*.vader $ROOT_DIR/test/options/*.vader $ROOT_DIR/test/filetypes/*/*.vader"}

red='\033[0;31m'
green='\033[0;32m'
blue='\033[0;34m'
nc='\033[0m'

run_file="$(mktemp)"

function filter-vader-output() {
  local hit_first_vader_line=0

  while read -r; do
    # Search for the first Vader output line.
    if ((!hit_first_vader_line)); then
      if [[ "$REPLY" = *'Starting Vader:'* ]]; then
        hit_first_vader_line=1
      else
        continue;
      fi
    fi

    if [[ "$REPLY" = *'GIVEN'* ]] \
      || [[ "$REPLY" = *'DO'* ]] \
      || [[ "$REPLY" = *'EXECUTE'* ]] \
      || [[ "$REPLY" = *'THEN'* ]] \
      || [[ "$REPLY" = *'EXPECT'* ]] \
      || [[ "$REPLY" = *'BEFORE'* ]] \
      || [[ "$REPLY" = *'AFTER'* ]] \
      || [[ "$REPLY" = *'Starting Vader:'* ]] \
      || [[ "$REPLY" = *'Success/Total'* ]] \
      || [[ "$REPLY" = *'Elapsed time:'* ]]
    then
      echo "$REPLY"
    fi
  done

  # Echo a 1 into the temp file to indicate this (re)try is successful.
  if ((hit_first_vader_line)); then
    echo 1 > "$run_file"
  fi
}

function color-vader-output() {
  while read -r; do
    # Split blocks by echoing an extra white line.
    if [[ "$REPLY" = *'GIVEN'* ]] || [[ "$REPLY" = *'EXECUTE'* ]]; then
      echo
    fi

    if [[ "$REPLY" = *'(X)'* ]]; then
      echo -en "$red"
    elif [[ "$REPLY" = *'Starting Vader:'* ]]; then
      echo -en "$blue"
    else
      echo -en "$nc"
    fi

    if [[ "$REPLY" = *'Success/Total'* ]]; then
      echo

      success="$(echo -n "$REPLY" | grep -o '[0-9]\+/' | head -n 1 | cut -d / -f 1)"
      total="$(echo -n "$REPLY" | grep -o '/[0-9]\+' | head -n 1 | cut -d / -f 2)"

      if [ "$success" -lt "$total" ]; then
        echo -en "$red"
      else
        echo -en "$green"
      fi

      echo "$REPLY"
      echo -en "$nc"
      echo
    else
      echo "$REPLY"
    fi
  done

  echo -en "$nc"
}

echo
echo '================================================================================'
echo "Running tests for $vim"
echo '================================================================================'
echo

max_retries=5
tries=0
exit_code=0

while [ "$tries" -lt $max_retries ]; do
  tries=$((tries + 1))
  echo "($tries/$max_retries) Trying to run tests..."

  set -o pipefail

  "$vim" -u $ROOT_DIR/test/vimrc "+Vader! $tests" 2>&1 | filter-vader-output | color-vader-output || exit_code=$?

  set +o pipefail

  if [ -s "$run_file" ]; then
    break
  fi
done

if [ "$tries" -gt 1 ]; then
  echo
  echo "Tried to run tests $tries times"
fi

rm "$run_file"

echo "vim-doge exited with status code $exit_code"
exit "$exit_code"
