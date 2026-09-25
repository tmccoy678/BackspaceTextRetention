#!/bin/zsh

set -eu
umask 077

readonly offline_root='/Users/taylor/Blu-Workbench/offline'
readonly runner='/opt/homebrew/bin/llama-cli'
readonly raw_tty_wrapper="${offline_root}/bin/blu-offline-raw-tty"
readonly model="${offline_root}/models/Ministral-3-14B-Instruct-2512-Q5_K_M.gguf"
readonly model_size='9621091904'
readonly model_sha256='f16fef77021df0d4c22e69140a2038478370492f51867b6237699918ae711000'
readonly system_prompt="${offline_root}/config/BLU-OFFLINE-SYSTEM.md"
readonly transcript_dir="${offline_root}/transcripts"
readonly lock_dir="${offline_root}/.runtime-lock"

stop() {
  print -u2 -- 'BLU OFFLINE: STOPPED'
  print -u2 -- "$1"
  exit "${2:-64}"
}

check_components() {
  [[ -x "$runner" ]] || stop "Local runner is unavailable: ${runner}" 72
  [[ -r "$model" ]] || stop "Verified model is unavailable: ${model}" 72
  [[ -r "$system_prompt" ]] || stop "Offline operating prompt is unavailable: ${system_prompt}" 72
  [[ -d "$transcript_dir" ]] || stop "Transcript directory is unavailable: ${transcript_dir}" 72

  local actual_size
  actual_size=$(/usr/bin/stat -f '%z' "$model")
  [[ "$actual_size" == "$model_size" ]] || stop \
    "Model size mismatch. Expected ${model_size}; found ${actual_size}." 74
}

verify_model() {
  check_components
  local actual_sha256
  actual_sha256=$(/usr/bin/shasum -a 256 "$model" | /usr/bin/awk '{print $1}')
  [[ "$actual_sha256" == "$model_sha256" ]] || stop \
    "Model SHA-256 mismatch. Expected ${model_sha256}; found ${actual_sha256}." 74
  print -r -- 'BLU OFFLINE MODEL VERIFY: PASS'
  print -r -- "size: ${model_size} bytes"
  print -r -- "sha256: ${model_sha256}"
}

release_lock() {
  if [[ -d "$lock_dir" && -r "$lock_dir/pid" ]]; then
    local recorded_pid
    IFS= read -r recorded_pid < "$lock_dir/pid" || true
    if [[ "$recorded_pid" == "$$" ]]; then
      /bin/rm -f "$lock_dir/pid"
      /bin/rmdir "$lock_dir" 2>/dev/null || true
    fi
  fi
}

acquire_lock() {
  if /bin/mkdir -m 700 "$lock_dir" 2>/dev/null; then
    print -r -- "$$" > "$lock_dir/pid"
    return
  fi

  if [[ -r "$lock_dir/pid" ]]; then
    local recorded_pid
    IFS= read -r recorded_pid < "$lock_dir/pid" || true
    if [[ "$recorded_pid" == <-> ]] && /bin/kill -0 "$recorded_pid" 2>/dev/null; then
      stop "A Blu Offline session is already running as PID ${recorded_pid}." 75
    fi
  fi

  stop 'A stale Blu Offline lock may remain after an interrupted exit. Nothing was launched; ask Blu Private to inspect it safely.' 75
}

raw_input_test=0
canonical_control=0

case "${1-}" in
  '')
    ;;
  --check)
    (( $# == 1 )) || stop 'The --check mode accepts no other arguments.'
    exec "${offline_root}/bin/blu-offline-check"
    ;;
  --verify)
    (( $# == 1 )) || stop 'The --verify mode accepts no other arguments.'
    verify_model
    exit 0
    ;;
  --raw-input-test)
    (( $# == 1 )) || stop 'The --raw-input-test mode accepts no other arguments.'
    [[ -r "$raw_tty_wrapper" ]] || stop "Raw-input test wrapper is unavailable: ${raw_tty_wrapper}" 72
    raw_input_test=1
    ;;
  --canonical-input-control)
    (( $# == 1 )) || stop 'The --canonical-input-control mode accepts no other arguments.'
    canonical_control=1
    ;;
  *)
    stop 'Blu Offline accepts no arbitrary options. Use no arguments, --check, --verify, --raw-input-test, or --canonical-input-control.'
    ;;
esac

check_components

if /usr/bin/pgrep -f '/llama-server([[:space:]]|$)' >/dev/null 2>&1; then
  stop 'A llama.cpp server is running. Blu Offline uses only a direct local terminal process.' 75
fi

if /usr/bin/pgrep -f "${runner}.*--model[[:space:]]+${model}" >/dev/null 2>&1; then
  stop 'A Blu Offline model process is already running. Nothing else was launched.' 75
fi

acquire_lock

# In zsh, an EXIT trap installed inside acquire_lock would run when that
# function returns. Install signal handling at top level so the lock persists
# for the lifetime of this launcher process.
trap release_lock EXIT
trap 'exit 129' HUP
trap 'exit 130' INT
trap 'exit 143' TERM

timestamp=$(/bin/date '+%Y%m%d-%H%M%S')
if (( raw_input_test )); then
  transcript="${transcript_dir}/Blu-Offline-RawTest-${timestamp}.typescript"
  script_command=(/bin/zsh "$raw_tty_wrapper" "$runner")
  launch_prompt=/dev/null
  prompt_display=(--no-display-prompt --verbose-prompt)
elif (( canonical_control )); then
  transcript="${transcript_dir}/Blu-Offline-CanonicalControl-${timestamp}.typescript"
  script_command=("$runner")
  launch_prompt=/dev/null
  prompt_display=(--no-display-prompt --verbose-prompt)
else
  transcript="${transcript_dir}/Blu-Offline-${timestamp}.typescript"
  script_command=("$runner")
  launch_prompt="$system_prompt"
  prompt_display=()
fi

print -r -- ''
print -r -- 'BLU OFFLINE'
print -r -- 'Runtime: local Ministral 3 14B Instruct Q5_K_M'
print -r -- 'External network: none; the foreground runner may use temporary localhost transport'
print -r -- 'Turn Wi-Fi off for a physical no-internet guarantee.'
if (( raw_input_test )); then
  print -r -- 'RAW INPUT TEST: child PTY uses no echo and noncanonical input.'
  print -r -- 'Use synthetic text only. The diagnostic transcript may contain every input byte.'
  print -r -- 'The normal personal system prompt is replaced with an empty one for this test.'
  print -r -- 'Typed text will not appear while you enter it; Control+C still exits.'
elif (( canonical_control )); then
  print -r -- 'CANONICAL CONTROL: ordinary terminal line editing remains enabled.'
  print -r -- 'Use synthetic text only. The transcript may retain erased input as terminal echo.'
  print -r -- 'The normal personal system prompt is replaced with an empty one for this control.'
fi
print -r -- "Transcript: ${transcript}"
print -r -- 'Exit safely by pressing Control+C once.'
print -r -- ''

set +e
/usr/bin/script -q "$transcript" "${script_command[@]}" \
  --model "$model" \
  --gpu-layers 99 \
  --ctx-size 16384 \
  --jinja \
  --system-prompt-file "$launch_prompt" \
  --temperature 0.05 \
  --top-k 20 \
  --top-p 0.90 \
  --min-p 0.0 \
  --reasoning off \
  --no-context-shift \
  --no-show-timings \
  --color auto \
  "${prompt_display[@]}" \
  --simple-io \
  --log-disable
exit_status=$?
set -e

if [[ -e "$transcript" ]]; then
  /bin/chmod 600 "$transcript"
  print -r -- ''
  print -r -- "Blu Offline transcript saved: ${transcript}"
fi

exit "$exit_status"
