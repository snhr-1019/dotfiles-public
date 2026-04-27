---
name: difit
description: ユーザーが明示的にdifitでの差分確認を依頼した場合に、difit（Git差分のWebビューア）を起動します（例：「difitで見せて」「difitで差分を確認」「difitで起動して」）。明示的な依頼時のみ使用し、通常の差分確認や`git diff`の代替としては起動しません。
---

# difit

## Overview
[difit](https://github.com/yoshiko-pg/difit) は Git の差分を GitHub 風の UI でブラウザ表示するツールです。`npx -y difit` で起動でき、コミット指定や `staged` / `working` / `.` などの特殊引数、PR URL の指定にも対応しています。

## Workflow
1. カレントディレクトリが Git リポジトリであることを確認します（`git rev-parse --is-inside-work-tree`）。
2. ユーザーの依頼内容から起動モードを決定（起動時は必ず `--keep-alive --port 4966` を付与し、起動するポートは 4966 に固定）：
   - 指定なし：`npx -y difit --keep-alive --port 4966`（最新コミット）
   - ステージ済みのみ：`npx -y difit staged --keep-alive --port 4966`
   - 未ステージのみ：`npx -y difit working --keep-alive --port 4966`
   - 未コミットすべて：`npx -y difit . --keep-alive --port 4966`
   - 特定コミット/ブランチ：`npx -y difit <commit> --keep-alive --port 4966`
   - 2リビジョン比較：`npx -y difit <commit1> <commit2> --keep-alive --port 4966`
   - PR：`npx -y difit --pr <PR URL> --keep-alive --port 4966`（`gh` の認証が必要）
   - 任意の diff をパイプ：`git diff ... | npx -y difit --keep-alive --port 4966`
3. 必要に応じて追加オプションを付加：
   - `--mode split|unified`
   - `--clean`（保存済みコメントをリセット）
4. ポート 4966 が既に使用されている場合は、そのプロセスを停止してから difit を起動します。
5. 実行コマンドをユーザーに提示し、バックグラウンド起動が望ましい場合はその旨も伝えます。
6. difit を起動し、表示された URL を共有します。`--keep-alive` によりブラウザを閉じてもサーバは維持されるため、停止したい場合は Ctrl+C を案内します。

## Examples
- ユーザー：「difitで差分を見せて」
  - `npx -y difit . --keep-alive --port 4966` を実行して未コミット差分をブラウザで表示。
- ユーザー：「difitでmainとの差分を見たい」
  - `npx -y difit HEAD main --keep-alive --port 4966` のように2リビジョン比較で起動。
- ユーザー：「difitでこのPRをレビューしたい <URL>」
  - `npx -y difit --pr <URL> --keep-alive --port 4966` を実行（`gh auth status` で事前確認）。

## Guardrails
- ユーザーが明示的に difit の利用を依頼していない場合は起動しません。
- Node.js 21 以上が必要です。未導入や古い場合はその旨を伝えて中断します。
- PR モードでは `gh` CLI の認証が必要です。未認証なら `gh auth login` を案内します。
- 起動ポートは 4966 に固定します。4966 が使用中の場合は、既存のプロセスを停止してから起動します。
- difit はローカルにサーバを立てるため、共有環境では公開範囲に注意するよう促します。
