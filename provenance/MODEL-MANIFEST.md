# Model manifest

## Selected artifact

- Publisher: Mistral AI
- Repository: `mistralai/Ministral-3-14B-Instruct-2512-GGUF`
- Repository URL: <https://huggingface.co/mistralai/Ministral-3-14B-Instruct-2512-GGUF>
- Filename: `Ministral-3-14B-Instruct-2512-Q5_K_M.gguf`
- Quantization: Q5_K_M
- Exact size: 9,621,091,904 bytes
- Published SHA-256: `f16fef77021df0d4c22e69140a2038478370492f51867b6237699918ae711000`
- Locally computed SHA-256: `f16fef77021df0d4c22e69140a2038478370492f51867b6237699918ae711000`
- License: Apache 2.0
- Downloaded and verified: 2026-09-20
- Modality installed: text only; the optional multimodal projector was not downloaded

The official model card and Apache 2.0 license text are preserved under
`offline/provenance/` for offline inspection.

## Runner

- Runner: llama.cpp via the official Homebrew formula
- Installed formula version: 0.4.1
- Reported build during smoke test: `b10964-b29c606e2`
- Formula license: MIT
- Executable: `/opt/homebrew/bin/llama-cli`
- Interaction mode: direct foreground terminal process, not the persistent
  `llama-server` program

## Selection rationale

This is an official, ungated, Apache-2.0 GGUF at the requested 14B scale. Q5_K_M
uses more precision than Q4 while fitting comfortably on the observed 24 GB
Apple M5 system.

## Initial observed test

- Context allocated: 8,192 tokens
- GPU offload request: 99 layers
- Wall time for load plus a 2-line response: approximately 5.1 seconds
- Maximum resident set size reported by macOS: 11,030,839,296 bytes
- Swap events reported: 0
- Result: the model followed the two-line Blu Offline identity instruction exactly

These are local observations from one smoke test, not general performance claims.

An interactive socket audit found one ephemeral listener bound only to
`127.0.0.1`; there was no LAN-facing or outbound socket. The listener and model
process disappeared on `/exit`. Current `llama-cli` uses this loopback transport
internally even though the user interacts through the terminal.
