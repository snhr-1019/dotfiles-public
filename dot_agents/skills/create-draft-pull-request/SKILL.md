---
name: create-draft-pull-request
description: 現在のブランチから指定されたベースブランチに対してドラフトpull requestを作成します。引数でベースブランチ名を指定してください（例：「mainに向けてドラフトPR作って」「create-draft-pull-requestでdevelopにPR」）。明示的にPR作成を依頼された場合のみ使用します。
---

# Create Draft Pull Request

## Overview
現在のブランチから指定されたベースブランチに対してドラフトpull requestを作成します。変更内容を分析し、適切なタイトルとボディを自動生成します。

## Workflow
1. `git status`でブランチ状態を確認します。
2. `git log <base-branch>..HEAD`でベースブランチとの差分のコミット履歴を確認します。
3. `git diff <base-branch>...HEAD`でコード変更内容をすべて確認します。
4. ブランチがリモートにプッシュされていなければ、`git push -u origin <current-branch>`でプッシュします。
5. 変更内容に基づいてPRのタイトルとボディを自動生成します。
6. `gh pr create --base <base-branch> --draft`でドラフトPRを作成します。
7. PRのURLを報告します。

## PR Title and Body Guidelines
- タイトルは変更の要約を簡潔に記述（70文字以内）
- ボディには変更の概要をまとめる
- 複数のコミットがある場合は主要な変更点をリストアップ

## Examples
- ユーザー：「mainに向けてドラフトPR作って」
  - mainブランチをベースにドラフトPRを作成。
- ユーザー：「developにPRを作成して」
  - developブランチをベースにドラフトPRを作成。

## Guardrails
- ユーザーが明示的にPR作成を依頼していない場合は実行しません。
- ベースブランチが指定されていない場合は確認を求めます。
- 変更がない場合はその旨を伝えて終了します。
