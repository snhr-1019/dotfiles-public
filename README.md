# dotfiles-public

新しい端末の初期セットアップ用スクリプト。

## Apple Silicon Mac の初期セットアップ

次のコマンドで Homebrew、GitHub CLI、mise、chezmoi をインストールし、
GitHub の HTTPS 認証を設定する。

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/snhr-1019/dotfiles-public/main/install.sh)"
```

スクリプトは `chezmoi init` や `chezmoi apply` を実行しない。
続きは利用する dotfiles リポジトリのセットアップ手順を参照する。
