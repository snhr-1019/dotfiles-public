#!/bin/bash

# === ツールのインストール ===

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

# git-worktree-runner (git-gtr)
if ! command -v git-gtr &> /dev/null; then
    git clone https://github.com/coderabbitai/git-worktree-runner.git "$XDG_DATA_HOME/git-worktree-runner"
    ln -s "$XDG_DATA_HOME/git-worktree-runner/bin/git-gtr" "$HOME/.local/bin/git-gtr"
fi
