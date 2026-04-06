#!/bin/bash

# === Git のグローバル設定 ===

# グローバル gitignore の設定
git config --global core.excludesfile "${HOME}/.config/git/ignore"

# 共有 git config の読み込み
git config --global include.path "${HOME}/.config/git/config"
