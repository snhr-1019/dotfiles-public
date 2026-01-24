#!/bin/bash

# === ツールのインストール ===

# Claude Code (native)
if ! command -v claude &> /dev/null; then
    curl -fsSL https://claude.ai/install.sh | bash
fi

# mise
if ! command -v mise &> /dev/null; then
    curl https://mise.run | sh
fi

# Codex CLI
if ! command -v codex &> /dev/null; then
    npm install -g @openai/codex
fi

# GitHub Copilot CLI
if ! command -v copilot &> /dev/null; then
    curl -fsSL https://gh.io/copilot-install | bash
fi
