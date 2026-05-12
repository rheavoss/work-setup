#!/bin/bash
# PreToolUse Bash gate: blocks inference execution unless Grok inbox read today

INPUT=$(cat)
COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // ""')

if echo "$COMMAND" | grep -Eiq 'submit_v|runpod|vast|comfyui|python3 submit|bun run submit|LoRA|Flux batch|ComfyUI job'; then
  DATE=$(date +%Y-%m-%d)
  CWD=$(echo "$INPUT" | jq -r '.cwd // "."')
  GATE_FILE="${CWD}/.gates/GROK_INBOX_READ_${DATE}.md"

  if [ ! -f "$GATE_FILE" ]; then
    echo "INFERENCE GATE BLOCKED — Grok inbox not read today." >&2
    echo "Read all Grok inbox docs for this project, then create: ${GATE_FILE}" >&2
    exit 2
  fi
fi

exit 0
