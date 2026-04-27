---
name: difit-review
description: ユーザーがdifit上で差分レビュー結果やコード説明をコメント付きで見たい場合に使用します。ブランチ差分、コミット差分、GitHub PR、未コミット差分などを確認し、レビュー指摘や説明を`--comment`でdifitにプリロードして起動します。
---

# difit-review

## Overview
[difit](https://github.com/yoshiko-pg/difit) の `--comment` オプションを使い、対象差分にレビューコメントやコード説明を付けた状態でWebビューアを起動します。

このスキルは、単に差分を表示するだけでなく、エージェントが先に差分をレビューし、その結果をdifit上の行コメントとしてユーザーに見せるために使います。

## Workflow
1. カレントディレクトリが Git リポジトリであることを確認します（`git rev-parse --is-inside-work-tree`）。
2. `difit` コマンドを決定します。
   - `command -v difit` が成功する場合は `difit` を使います。
   - それ以外は `npx -y difit` を使います。
   - サンドボックス環境で `npx -y difit` のダウンロードが必要になりそうな場合は、実行前に権限昇格をリクエストします。
3. ユーザーが指定した対象差分を確認します。
   - ローカルのリビジョン、ブランチ比較、コミット、GitHub PR URL、パッチファイル、未コミット差分などを対象にできます。
   - 必要に応じて周辺コードも読み、通常のコードレビューとしてバグ、リグレッション、設計上のリスク、テスト不足を優先して確認します。
   - PRレビューの場合も、リモートGitHubへレビューやコメントを投稿しません。結果はdifitの起動コメントに限定します。
4. difitに付与するコメントを作成します。
   - 各コメントは `type: "thread"` を使います。
   - コメント本文はユーザーが使っている言語に合わせます。
   - 追加・変更後の行には `position.side: "new"` を使います。
   - 削除された行には `position.side: "old"` を使います。
   - 複数行にまたがる指摘は range comment を使います。
   - secret、token、password、API key、private key などの認証情報らしい文字列を、`--comment` の本文やコマンドライン引数にコピーしません。
5. `--comment` を付けてdifitを起動し、URLを共有します。
   - 起動時は `--keep-alive --port 4966` を付与し、ポートは4966に固定します。
   - ポート4966が既に使われている場合は、既存プロセスを確認してから停止または別対応を判断します。
   - コメントがない場合は、コメントなしで起動したことを明示します。
   - 起動後のページを手動検証する必要はありません。

## Target Arguments
- 指定なしの最新コミット: `<difit-command> --keep-alive --port 4966`
- ステージ済みのみ: `<difit-command> staged --keep-alive --port 4966`
- 未ステージのみ: `<difit-command> working --keep-alive --port 4966`
- 未コミットすべて: `<difit-command> . --keep-alive --port 4966`
- 特定コミット/ブランチ: `<difit-command> <target> --keep-alive --port 4966`
- 2リビジョン比較: `<difit-command> <target> <compare-with> --keep-alive --port 4966`
- PR: `<difit-command> --pr <PR URL> --keep-alive --port 4966`
- 任意のdiffをパイプ: `git diff ... | <difit-command> --keep-alive --port 4966`

未コミット差分で未追跡ファイルも表示する必要がある場合は `--include-untracked` を追加します。

## Comment Examples
単一行コメント:

```bash
<difit-command> <target> --keep-alive --port 4966 \
  --comment '{"type":"thread","filePath":"src/foobar.ts","position":{"side":"new","line":42},"body":"この条件だと空配列のケースで例外になります。"}'
```

削除行へのコメント:

```bash
<difit-command> <target> --keep-alive --port 4966 \
  --comment '{"type":"thread","filePath":"src/legacy.ts","position":{"side":"old","line":102},"body":"この削除により既存の呼び出し元が戻り値を受け取れなくなります。"}'
```

複数行コメント:

```bash
<difit-command> <target> --keep-alive --port 4966 \
  --comment '{"type":"thread","filePath":"src/example.ts","position":{"side":"new","line":{"start":36,"end":39}},"body":"この範囲は同じ検証を2回行っているため、片方に集約できます。"}'
```

## Guardrails
- ユーザーがdifit上でレビューコメントや説明を見たい意図を示した場合に使います。通常のコードレビューや通常の差分確認だけなら、まずローカルの差分確認で対応します。
- Node.js 21 以上が必要です。未導入や古い場合はその旨を伝えて中断します。
- PRモードでは `gh` CLI の認証が必要です。未認証なら `gh auth login` を案内します。
- difitはローカルにサーバを立てるため、共有環境では公開範囲に注意するよう促します。
- difitのコメントはレビュー結果の表示用です。GitHubやリモートサービスへ投稿してはいけません。
