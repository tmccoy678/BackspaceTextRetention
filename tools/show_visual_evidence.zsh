#!/bin/zsh

set -eu

readonly repo='/Users/taylor/Blu-Workbench/backspace-gate'
readonly transcript='evidence/transcripts/Blu-Offline-20260921-153748.typescript'

cd "$repo"
clear
print -r -- 'BACKSPACE GATE — PRIMARY BYTE EVIDENCE'
print -r -- 'Read-only inspection of the untouched discovery transcript'
print -r -- ''
/usr/bin/python3 tools/inspect_typescript.py "$transcript"
print -r -- ''
print -r -- 'INDEPENDENT macOS cat -v RENDERING OF SOURCE LINE 28:'
LC_ALL=C /usr/bin/sed -n '28p' "$transcript" | /bin/cat -v
print -r -- ''
print -r -- 'NOTE: ^H and hexadecimal digits are viewer representations; the source contains byte 08.'
print -r -- 'This window may be closed without changing the evidence file.'
