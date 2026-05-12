#!/usr/bin/env python3
"""UserPromptSubmit hook — calls failure-oracle HTTP server, injects past violations."""
import json, sys, os, urllib.request, urllib.error

try:
    data = json.load(sys.stdin)
    prompt = data.get("prompt", "")
    project = data.get("cwd", "")

    # Inference gate — block if inference keywords detected and gate file missing
    INFERENCE_KEYWORDS = ["inference", "comfyui", "comfy", "lora", "vast.ai", "vastai", "training run", "batch generate"]
    prompt_lower = prompt.lower()
    if any(kw in prompt_lower for kw in INFERENCE_KEYWORDS):
        gate_file = os.path.join(project, ".gates", "INFERENCE_APPROVED.md")
        if not os.path.exists(gate_file):
            print(json.dumps({
                "decision": "block",
                "reason": f"INFERENCE GATE — .gates/INFERENCE_APPROVED.md not found in {project}. Create it with Grok approval before proceeding."
            }))
            sys.exit(0)

    if len(prompt) < 10:
        sys.exit(0)

    payload = json.dumps({"prompt": prompt, "project": project}).encode()
    req = urllib.request.Request(
        "http://localhost:3133",
        data=payload,
        headers={"Content-Type": "application/json"},
        method="POST"
    )
    with urllib.request.urlopen(req, timeout=3) as resp:
        result = json.load(resp)
        context = result.get("additionalContext", "")
        if context:
            print(json.dumps({
                "hookSpecificOutput": {
                    "hookEventName": "UserPromptSubmit",
                    "additionalContext": context
                }
            }))
except (urllib.error.URLError, OSError):
    # Server not running — inject hard Pattern #15 reminder instead of silent fail
    print(json.dumps({
        "hookSpecificOutput": {
            "hookEventName": "UserPromptSubmit",
            "additionalContext": "WARNING: failure-oracle DOWN (port 3133 unreachable). No failure digest available. ENFORCE Pattern #15 manually: Read source files BEFORE any answer. No memory responses allowed. No status claims without tool evidence."
        }
    }))
except Exception:
    pass
