# Findings and claim boundary

## 1. Discovery observation

The discovery recording,
`Blu-Offline-20260921-153748.typescript`, contains the UTF-8 text
`marie is black.`, followed by fifteen `08 20 08` byte triplets, followed by
`stanley is red.`. In terminal control notation those three bytes are:

- `08`: backspace;
- `20`: a literal space;
- `08`: backspace again.

The visual effect is to move backward, overwrite the visible character with a
space, and move backward again. The recorder retained the bytes even though the
first sentence no longer appeared on the final command line.

The model's visible response addressed only `stanley is red.`. That observation
is consistent with ordinary canonical line editing delivering only the final
line to `llama-cli`; it is not a byte-for-byte trace of the model's input.

## 2. Mechanism established from the installed path

The installed llama.cpp build reported commit `b29c606e2`. Its simple-input
path uses `std::getline(std::cin, line)`. With `--simple-io`, llama.cpp does not
itself disable terminal `ICANON` and `ECHO`; the inherited terminal mode decides
which bytes reach `std::getline`.

The outer launcher used:

```sh
/usr/bin/script -q TRANSCRIPT llama-cli ... --simple-io
```

No `script -k` option was used. In the ordinary condition, the terminal echoed
the editing sequence and `script` recorded that output. This is different from
claiming that llama.cpp contained a command to record individual keystrokes.

## 3. Deliberate raw-input condition

The experimental wrapper ran the child pseudo-terminal with:

```sh
/bin/stty -echo -icanon min 1 time 0
```

That mode disabled ordinary echo and canonical line editing before `llama-cli`
read standard input. It was a deliberate diagnostic condition, not a privacy
feature and not the normal launcher behavior.

## 4. Matched six-pair pilot

Six unique synthetic markers were tested in each condition with the same model,
empty system prompt, generation settings, and final question. Chat history was
cleared between trials.

| Declared endpoint | Canonical | Raw input |
| --- | ---: | ---: |
| Exact marker in model answer | 0/6 | 6/6 |
| Marker-plus-backspace input echo in transcript | 6/6 | 0/6 |
| `NONE` in model answer | 6/6 | 0/6 |
| Confirmed `/clear` transitions | 5/5 | 5/5 |

The raw transcript contains each marker because the model repeated it in the
answer. Three raw answers also contained Delete (`0x7f`) bytes after the marker;
that observation was noticed after scoring and was not a preregistered endpoint.

## 5. Corrections preserved

- The relevant erase triplet is `08 20 08`, not `08 02 08`.
- The experiment used `llama-cli`, not Ollama.
- `--verbose-prompt` was not a byte-for-byte prompt dump; the model's answer
  supplied the response-based evidence.
- The terminal recording retaining erased text is not proof that the model
  received that erased text.
- Apple's manual documents terminal-output recording and backspaces in the log,
  but does not state the combined user-facing consequence: bytes representing
  text later erased from the screen can remain recoverable in the sequential
  typescript. This is a documentation-to-behavior gap, not evidence that the
  terminal mechanism itself was previously unknown.
- The raw mode demonstrates a possible and measured input path only under the
  deliberately altered terminal settings.

## 6. Unsupported claims

These observations do not establish that:

- OpenAI, ChatGPT, Codex, Ollama, or another application receives deleted drafts;
- a network service received any experimental text;
- the same rates generalize beyond these six repeated turns in one process;
- the model's complete internal token sequence is recoverable from its answer;
- any claim about consciousness or continuous subjective identity follows.

This repository therefore treats terminal echo, recorder output, process input,
model response, and cloud telemetry as separate evidentiary layers.
