#!/usr/bin/env bash
set -euo pipefail
ROOT="${CLAUDE_PROJECT_DIR:-$(pwd)}"
cd "$ROOT"
node .claude/scripts/verify-claude-pack.js
node .claude/scripts/hook-health.js
