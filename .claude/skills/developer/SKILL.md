---
name: developer
description: AIがタスクを進めるときの開発フロー全体を管理するスキル。新機能を実装するとき、エピック・ストーリー・タスクを選ぶとき、ブランチを作成するとき、「Issueを作って」「実装を始めて」「次のタスクに進んで」と言われたときに必ずこのスキルを使うこと。
---

# developer スキル

このプロジェクトの開発フローは **ブランチ作成 → 実装 → PR** の流れで進む。
GitHub Issues とローカルの `docs/issues/` を連携し、Epic → Story → Task の3層でタスクを管理する。

---

## 開発の進め方

### 前提

- GitHub Issue とローカルの `docs/issues/` の内容を連携させている
- 連携には `.claude/hooks/update-issues.sh` を使用する
- フロントエンドの実装フローは `frontend-workflow` スキルを参照すること
- バックエンドの実装フローは `backend-workflow` スキルを参照すること

---

### Step 0. ブランチの作成（実装前に必ず行う）

`.claude/references/branch-strategy.md` を参照し、**上位ブランチから順に**作成する。

```bash
# 1. Epic ブランチ（main から）
git checkout main
git checkout -b epic/<epic-name>

# 2. Story ブランチ（epic から）
git checkout -b us/<story-name>

# 3. Task ブランチ（us から）
git checkout -b task/<task-name>
```

既に Epic・Story ブランチが存在する場合は、そこから切る。

---

### Step 1. エピックの決定

`docs/issues/` 配下のディレクトリ一覧からエピックをユーザーに確認する。

```bash
ls docs/issues/
```

---

### Step 2. ユーザーストーリーの確認

エピックに紐づくストーリー（`[US-N]` ディレクトリ）を確認し、実装するストーリーを選ぶ。
ストーリー内のタスク（`[TASK]*.md`）を洗い出し、依存関係を整理する。

**Issueファイルが存在しない場合**は「Issue ファイル作成手順」セクションでファイルを作成・同期してから進む。

---

### Step 3. タスクの並列実行

依存関係のないタスクは**サブエージェントで並列実行**する。

```
タスクA ──► サブエージェント1
タスクB ──► サブエージェント2  （同時起動）
タスクC ──► サブエージェント3
```

各サブエージェントには以下を明示して渡す:

- 対象の `[TASK]*.md` ファイルパス
- 使用するスキル（フロントなら `frontend-workflow`、バックなら `backend-workflow`）
- 完了時に `[TASK]*.md` のチェックリストを更新すること

---

### Step 4. タスク完了時の必須手順

各タスクが完了したら**必ず**以下を実行する:

1. `[TASK]*.md` の完了した作業項目を `[x]` に更新する
2. GitHub に同期する:
   ```bash
   bash .claude/hooks/update-issues.sh "<タスクファイルパス>"
   ```
3. コミットを作成する

すべてのタスクが完了したら、`story.md` の作業内容も更新してコミットする。

---

### Step 5. PR の作成とマージ

各ステップ完了後、PR を作成してユーザーにマージを依頼する（マージされてから次のステップへ進む）。

```
task/<name>  →  us/<story-name>   （タスク完了時）
us/<name>    →  epic/<epic-name>  （ストーリー完了時）
epic/<name>  →  main              （Epic完了時）
```

---

## Issue ファイル作成手順

**ファイルは必ず Epic → Story → Task の順で作成する（GitHub の親子リンクがこの順序に依存するため）。**

### Epic の確認・作成

既存の Epic に追加する場合はそのまま使う。新規 Epic が必要な場合のみ作成する。
ディレクトリ番号は既存の最大番号 + 1。

`docs/issues/<N>. <エピック名>/epic.md`:

```markdown
# [EPIC] <エピック名>

## 概要

<!-- この EPIC が扱う機能グループの目的・価値を 2〜3 文で説明する -->

## EPIC ストーリー

**〈Who〉** として、**〈What〉** がしたい。なぜなら **〈Why〉** だからだ。

## スコープ（STORY 一覧）

| 優先度 | #   | ストーリー（一文）                                       | Issue |
| ------ | --- | -------------------------------------------------------- | ----- |
| `Must` | 1   | 〈Who〉として、〈What〉がしたい。なぜなら〈Why〉だから。 | -     |

## 受け入れ基準（EPIC 完了の定義）

- [ ] 配下のすべての `Must` STORY が Done になっている
```

### Story の作成

ディレクトリ名: `[US-N] <ストーリー名>`（N はそのEpic内の既存ストーリー数 + 1）

```markdown
## 概要

<!-- このストーリーで何を実現するかを 1〜2 文で説明する -->

## 親 EPIC

- EPIC: (<N>) <エピック名>

## ユーザーストーリー

**〈Who〉** として、**〈What〉** がしたい。なぜなら **〈Why〉** だからだ。

## 作業内容

- [ ] TASK 1: <タスク名>

## 受け入れ基準

- [ ] **Given** <前提条件> **When** <操作> **Then** <結果>

## 完了の定義（DoD）

- [ ] 配下のすべての Task が完了している
- [ ] ビルドが通る
- [ ] セルフレビュー済み（lint / format エラーなし）
```

### Task の作成（Story 作成後に必ず実行）

ファイル名: `[TASK] <タスク名>.md`

```markdown
## 概要

<!-- この TASK で何を実装するかを 1〜2 文で説明する -->

## 親 STORY

- STORY: (<US-N>) <ストーリー名>

## 作業内容

- [ ] <具体的な実装ステップ>

## 完了の定義（DoD）

- [ ] コードが実装されている
- [ ] ビルドが通る
- [ ] セルフレビュー済み（lint / format エラーなし）
```

### GitHub への同期

```bash
# Epic → Story → Task の順で同期する
bash .claude/hooks/update-issues.sh "docs/issues/<N>. <エピック名>/epic.md"
bash .claude/hooks/update-issues.sh "docs/issues/<epic>/[US-N] <ストーリー名>/story.md"
bash .claude/hooks/update-issues.sh "docs/issues/<epic>/[US-N] <ストーリー名>/[TASK] <タスク名>.md"
```
