#!/bin/zsh

set -eu

[[ -t 0 ]] || {
  print -u2 -- 'Raw-input test requires an interactive terminal.'
  exit 72
}

# This changes only script(1)'s child PTY. The parent Terminal keeps its mode.
# Keep signals enabled so Control+C remains the normal exit path.
/bin/stty -echo -icanon min 1 time 0

exec "$@"
