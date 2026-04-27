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

# GitHub Copilot CLI
if ! command -v copilot &> /dev/null; then
    curl -fsSL https://gh.io/copilot-install | bash
fi
