---
name: sync-issue
<<<<<<< HEAD
description: 指定した Epic / Story / Task の issue ファイルを GitHub Issue に同期するスキル。Issue を同期して、Issue を更新して、と言われたときに使うこと。
---

# sync-issue スキル

指定した Issue ファイルを GitHub に同期する。

## 現在の Issue 状況

- Issue ディレクトリ一覧: !`ls issues/`
- マッピング済み Issue 数: !`cat issues/.github-issue-map.json | python3 -c "import json,sys; d=json.load(sys.stdin); print(len(d), 'issues mapped')" 2>/dev/null || echo "mapping file not found"`

## あなたのタスク

# ユーザーが指定した Issue ファイルを GitHub に同期する。

## description: 指定したIssueファイル（epic.md / story.md / [TASK]\*.md）をGitHub Issueに同期する。「Issueを同期して」「GitHubに反映して」「issueを更新して」と言われたとき、またはIssueファイルを編集した後にGitHubへの同期が必要なときに必ずこのスキルを使うこと。

## 現在のIssue状況

- Issueディレクトリ一覧: !`ls docs/issues/`
- マッピング済みIssue数: !`cat docs/issues/.github-issue-map.json | python3 -c "import json,sys; d=json.load(sys.stdin); print(len(d), 'issues mapped')" 2>/dev/null || echo "mapping file not found"`

## あなたのタスク

ユーザーが指定したIssueファイルをGitHubに同期する。

> > > > > > > b7ee0ea2d181f9d93837b642c42a26e677d5eecd

### 引数がある場合（ファイルパス指定）

引数として渡されたファイルパスを使って同期する:

```bash
<<<<<<< HEAD
bash .agents/hooks/update-issues.sh "<指定されたパス>"
=======
bash .claude/hooks/update-issues.sh "<指定されたパス>"
>>>>>>> b7ee0ea2d181f9d93837b642c42a26e677d5eecd
```

### 引数がない場合

ユーザーに以下を確認する:

1. どのレベルを同期するか（Epic / Story / Task）
2. 対象のファイルパス

確認できたら実行:

```bash
<<<<<<< HEAD
bash .agents/hooks/update-issues.sh "<ファイルパス>"
=======
bash .claude/hooks/update-issues.sh "<ファイルパス>"
>>>>>>> b7ee0ea2d181f9d93837b642c42a26e677d5eecd
```

### 複数ファイルを同期する場合

Epic → Story → Task の順で同期すること（親子リンクが依存するため）。

### 注意

<<<<<<< HEAD

- 既存の Issue はスキップされず **本文が更新** される
- 動作確認したい場合は `DRY_RUN=true bash .agents/hooks/update-issues.sh` を使う
- # 同期後に Issue 番号をユーザーに報告すること
- 既存のIssueはスキップされず **本文が更新** される
- 動作確認したい場合は `DRY_RUN=true bash .claude/hooks/update-issues.sh` を使う
- 同期後にIssue番号をユーザーに報告すること
  > > > > > > > b7ee0ea2d181f9d93837b642c42a26e677d5eecd
