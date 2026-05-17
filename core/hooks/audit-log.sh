#!/usr/bin/env bash
# PostToolUse hook — YAMTAM ENGINE v1.2 Local Audit Log
# Logs tool, agent, timestamp, and a short input preview. No secrets parsing,
# no remote sending, no token estimates.

set -uo pipefail
command -v jq >/dev/null 2>&1 || exit 0

INPUT=$(cat)
TOOL_NAME=$(printf '%s' "$INPUT" | jq -r '.tool_name // ""' 2>/dev/null || true)
AGENT_NAME=$(printf '%s' "$INPUT" | jq -r '.agent_name // "manual"' 2>/dev/null || true)
TOOL_INPUT=$(printf '%s' "$INPUT" | jq -c '.tool_input // {}' 2>/dev/null || echo '{}')
TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
STATE_DIR="${CLAUDE_PROJECT_DIR:-$(pwd)}/.claude/state"
mkdir -p "$STATE_DIR" 2>/dev/null || true
printf '%s | agent=%s | tool=%s | input=%s\n' "$TIMESTAMP" "$AGENT_NAME" "$TOOL_NAME" "${TOOL_INPUT:0:300}" >> "$STATE_DIR/audit.log"
exit 0
