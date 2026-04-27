#!/bin/bash

# === ツールのインストール ===

# mise
if ! command -v mise &> /dev/null; then
    curl https://mise.run | sh
fi

# Starship
if ! command -v starship &> /dev/null; then
    curl -sS https://starship.rs/install.sh | sh
fi

# Codex CLI
if ! command -v codex &> /dev/null; then
    rm -rf "$(npm root -g)/@openai/.codex-"*
    npm install -g @openai/codex@latest
fi

# GitHub Copilot CLI
if ! command -v copilot &> /dev/null; then
    curl -fsSL https://gh.io/copilot-install | bash
fi
