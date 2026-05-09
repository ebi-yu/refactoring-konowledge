---
name: bug-triage
description: implements-orchestrator から呼ばれるバグ整理用スキル。バグ、リグレッション、失敗するテスト、想定外のUI/API結果、production defect を見つけたときに、再現、分類、既存Issue確認、Epic/Story/Task配置、local issues/作成、GitHub Issue作成、親子紐づけ、AIアサインまで行う。実装はしない。
---

# bug-triage

このスキルは、見つかったバグを作業可能な Issue に変換する。
実装は行わず、Issue 化、親子紐づけ、GitHub 同期、AIアサインまでを担当する。

## 入力

`implements-orchestrator` から次を受け取る。

- バグの概要
- 発見場所
- 再現できる操作または失敗しているテスト
- 期待結果
- 実際結果
- 関連しそうな Epic / Story / Task
- 既知の制約や緊急度

情報が不足していても、分かる範囲で Issue 化する。再現不能または情報不足の場合は `status:blocked` にする。

## トリアージ手順

1. 再現手順を整理する。
2. 期待結果と実際結果を分けて書く。
3. 影響範囲を整理する。
4. 既存 Issue と重複していないか確認する。
5. severity / priority を仮決めする。
6. 既存 Story に属するか判断する。
7. 必ず Epic / Story / Task の3階層に配置する。
8. local `issues/` に Bug Task を作る。
9. Epic -> Story -> Bug Task の順で GitHub Issue に同期する。
10. GitHub 上で親子関係を紐づける。
11. 原則 `cloud-github-codex-implementation` にアサインする。
12. 大きい場合は User Story 作成を検討し、`implements-orchestrator` に確認を戻す。

## 階層ルール

バグも必ず Epic / Story / Task の3階層に入れる。

既存 Story に属する場合:

```text
issues/<epic>/<story>/[BUG] <bug title>.md
```

既存 Story に属さない場合:

- 固定の Maintenance / Bugfix 親は作らない。
- その都度、最も意味のある Epic / Story を作る。
- バグが大きい、複数の修正が必要、仕様整理が必要な場合は Bug Task ではなく User Story 作成を検討する。

## Bug Task ファイル名

Bug Task は `[BUG] ... .md` 形式にする。

```text
[BUG] ログイン失敗時に500になる.md
```

## Bug Task テンプレート

```markdown
# [BUG] <バグ名>

## 概要

<何が壊れているかを1-2文で説明する>

## 親 STORY

- STORY: (<US-N>) <ストーリー名>

## 再現手順

1. <操作>
2. <操作>
3. <結果>

## 期待結果

- <本来起きるべき結果>

## 実際結果

- <実際に起きている結果>

## 影響範囲

- <影響するユーザー、画面、API、機能>

## severity / priority

- severity: <critical | high | medium | low>
- priority: <high | medium | low>

## 作業内容

- [ ] 再現テストを追加する
- [ ] 原因を特定する
- [ ] 修正する
- [ ] 回帰確認する

## 完了の定義（DoD）

- [ ] 再現テスト、または代替検証がある
- [ ] バグが修正されている
- [ ] 必要なテスト・ビルド・lint / format が通る
- [ ] GitHub Issue が更新されている
```

## GitHub Issue 作成

`issues/` を一次情報として作成・更新してから、GitHub Issue に同期する。

```bash
bash .agents/hooks/update-issues.sh "issues/<epic>/epic.md"
bash .agents/hooks/update-issues.sh "issues/<epic>/<story>/story.md"
bash .agents/hooks/update-issues.sh "issues/<epic>/<story>/[BUG] <bug title>.md"
```

GitHub Issue には次を付ける。

- `type:bug`
- `status:ready` または `status:blocked`
- `severity:*`
- 親 Story / Epic に対応する階層ラベル

## AIアサイン

バグ修正は原則 `cloud-github-codex-implementation` にアサインする。
GitHub Issue 本文またはコメントに Handoff block を含める。

ただし、次の場合はアサイン前に `implements-orchestrator` へ戻す。

- Large 変更になりそう
- 複数 Story / 複数 Issue にまたがる
- DB schema、auth、permission、secret、dependency、build/deploy/CI config に触りそう
- ローカル専用の再現環境が必要
- 仕様判断またはUX判断が必要
- Bug Task ではなく User Story として扱うべき可能性がある

## 完了出力

`implements-orchestrator` に次を返す。

```text
Bug: <title>
Local issue: <path>
GitHub Issue: <url or number>
Parent Story: <path or issue>
Parent Epic: <path or issue>
Status: <ready | blocked>
Severity: <critical | high | medium | low>
Suggested lane: cloud-github-codex-implementation
Needs human decision: <yes | no>
Reason: <details>
```

## よくある間違い

- バグを見つけてすぐ実装しない。
- 軽微なバグでも Issue 化を省略しない。
- 親 Story / Epic のない Bug Issue を作らない。
- 固定の Maintenance 親に機械的に入れない。
- 大きいバグを無理に Bug Task 1件に押し込まない。
