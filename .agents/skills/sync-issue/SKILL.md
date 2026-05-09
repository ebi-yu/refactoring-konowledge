---
name: sync-issue
description: 指定した Epic / Story / Task の issue ファイルを GitHub Issue に同期するスキル。Issue を同期して、Issue を更新して、と言われたときに使うこと。
---

# sync-issue スキル

指定した Issue ファイルを GitHub に同期する。

## 現在の Issue 状況

- Issue ディレクトリ一覧: !`ls issues/`
- マッピング済み Issue 数: !`cat issues/.github-issue-map.json | python3 -c "import json,sys; d=json.load(sys.stdin); print(len(d), 'issues mapped')" 2>/dev/null || echo "mapping file not found"`

## あなたのタスク

ユーザーが指定した Issue ファイルを GitHub に同期する。

### 引数がある場合（ファイルパス指定）

引数として渡されたファイルパスを使って同期する:

```bash
bash .agents/hooks/update-issues.sh "<指定されたパス>"
```

### 引数がない場合

ユーザーに以下を確認する:

1. どのレベルを同期するか（Epic / Story / Task）
2. 対象のファイルパス

確認できたら実行:

```bash
bash .agents/hooks/update-issues.sh "<ファイルパス>"
```

### 複数ファイルを同期する場合

Epic → Story → Task の順で同期すること（親子リンクが依存するため）。

### 注意

- 既存の Issue はスキップされず **本文が更新** される
- 動作確認したい場合は `DRY_RUN=true bash .agents/hooks/update-issues.sh` を使う
- 同期後に Issue 番号をユーザーに報告すること
