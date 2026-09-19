#!/bin/bash

set -euo pipefail

if [[ "$(uname -s)" != "Darwin" || "$(uname -m)" != "arm64" ]]; then
    echo "このスクリプトは Apple Silicon Mac 専用です。" >&2
    exit 1
fi

if [[ ! -x /opt/homebrew/bin/brew ]]; then
    echo "Homebrew をインストールします。"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

eval "$(/opt/homebrew/bin/brew shellenv)"

if ! brew list --formula gh >/dev/null 2>&1; then
    echo "GitHub CLI をインストールします。"
    brew install gh
fi

if ! gh auth status --hostname github.com >/dev/null 2>&1; then
    echo "GitHub にログインします。"
    gh auth login --hostname github.com --git-protocol https --web
fi
gh auth setup-git

if [[ ! -x "${HOME}/.local/bin/mise" ]]; then
    echo "mise をインストールします。"
    curl -fsSL https://mise.run | sh
fi

MISE="${HOME}/.local/bin/mise"
eval "$("${MISE}" activate bash)"
"${MISE}" settings set github.credential_command \
    "gh auth token --hostname \"\${MISE_CREDENTIAL_HOST}\""

echo "chezmoi をインストールします。"
MISE_GITHUB_TOKEN="$(gh auth token --hostname github.com)" \
    "${MISE}" use --global chezmoi@latest

echo
echo "初期セットアップが完了しました。"
brew --version
gh --version
"${MISE}" --version
"${MISE}" exec -- chezmoi --version
gh auth status --hostname github.com
echo
echo "続きは利用する dotfiles リポジトリのセットアップ手順を参照してください。"
