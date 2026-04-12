---
name: issue-management
description: AIがタスクを進めるときのIssue作成・更新・GitHub連携を管理するスキル。新機能を実装するとき、タスクを分解するとき、「Issueを作って」「Epicを追加して」「GitHubに同期して」と言われたとき、実装計画を立てるとき、タスクの進捗を更新するときに必ずこのスキルを使うこと。実装を始める前にIssueファイルが存在しない場合は必ずこのスキルで作成してから着手すること。
---

# Issue Management スキル

このプロジェクトはGitHub IssuesとローカルMarkdownファイルを連携して開発を進める。
Epic → Story → Task の3層でタスクを管理し、`update-issues.sh` でGitHubに同期する。

## ディレクトリ構造

```
docs/issues/
├── .github-issue-map.json     # GitHub Issue番号のマッピング（自動管理）
├── template/                  # テンプレートファイル
└── <N>. <エピック名>/         # 例: "0. 初期環境構築"
    ├── epic.md
    └── [US-N] <ストーリー名>/ # 例: "[US-1] デザイントークンを設定したい"
        ├── story.md
        └── [TASK] <タスク名>.md
```

## Issue の種類と役割

| 種類  | ファイル名         | 粒度                        | ラベル  |
| ----- | ------------------ | --------------------------- | ------- |
| Epic  | `epic.md`          | 機能グループ（複数Sprint）  | `epic`  |
| Story | `story.md`         | ユーザーが価値を感じる1機能 | `story` |
| Task  | `[TASK] <名前>.md` | 数時間〜1日の実装単位       | `task`  |

## ファイル作成手順

**必ずこの順序で作成すること（GitHubの親子リンクがこの順序に依存するため）:**

1. Epic → 2. Story → 3. Task

Storyを作成したら **必ず** 対応するTaskファイルも同じディレクトリに作成する。Task なしの Story はこのプロジェクトでは不完全とみなされる。

### Step 1. Epic の確認・作成

まず既存のEpicを確認する:

```bash
ls docs/issues/
```

**既存のEpicに追加する場合はそのまま使う。新規Epicが必要な場合のみ作成する。**
ディレクトリ番号は既存の最大番号 + 1 とする。

`docs/issues/<N>. <エピック名>/epic.md`:

```markdown
# [EPIC] <エピック名>

## 概要

<!-- この EPIC が扱う機能グループの目的・価値を 2〜3 文で説明する -->

## EPIC ストーリー

**〈Who〉** として、**〈What〉** がしたい。なぜなら **〈Why〉** だからだ。

## スコープ（STORY 一覧）

> 優先度: `Must` = リリース必須 / `Should` = できれば含める / `Could` = 余裕があれば

| 優先度 | #   | ストーリー（一文）                                       | Issue |
| ------ | --- | -------------------------------------------------------- | ----- |
| `Must` | 1   | 〈Who〉として、〈What〉がしたい。なぜなら〈Why〉だから。 | -     |

## スコープ外

- ...

## 受け入れ基準（EPIC 完了の定義）

- [ ] 配下のすべての `Must` STORY が Done になっている

## 参照

- [feature_scope](./docs/feature_scope.md)
```

### Step 2. Story の作成

ディレクトリ名: `[US-N] <ストーリー名>`
N はそのEpic内の既存ストーリー数 + 1。

`docs/issues/<epic>/[US-N] <ストーリー名>/story.md`:

```markdown
## 概要

<!-- このストーリーで何を実現するかを 1〜2 文で説明する -->

## 親 EPIC

- EPIC: (<N>) <エピック名>

## ユーザーストーリー

**〈Who〉** として、**〈What〉** がしたい。なぜなら **〈Why〉** だからだ。

## 作業内容

- [ ] TASK 1: <タスク名>（[TASK]ファイルで詳細管理）

## 受け入れ基準

> Given / When / Then 形式で記述する。

- [ ] **Given** <前提条件>
      **When** <操作>
      **Then** <結果>

## 完了の定義（DoD）

- [ ] 配下のすべてのTaskが完了している
- [ ] ビルドが通る
- [ ] セルフレビュー済み（lint / format エラーなし）
```

### Step 3. Task の作成（Story 作成後に必ず実行）

Story 作成後、**同じディレクトリに必ず1つ以上のTaskファイルを作成する**。

ファイル名: `[TASK] <タスク名>.md`

`docs/issues/<epic>/[US-N] <ストーリー名>/[TASK] <タスク名>.md`:

```markdown
## 概要

<!-- この TASK で何を実装するかを 1〜2 文で説明する -->

## 親 STORY

- STORY: (<US-N>) <ストーリー名>

## 作業内容

- [ ] <具体的な実装ステップ>
- [ ] <具体的な実装ステップ>

## 技術メモ

<!-- 使用するライブラリ・API・注意点など -->

## 完了の定義（DoD）

- [ ] コードが実装されている
- [ ] ビルドが通る
- [ ] セルフレビュー済み（lint / format エラーなし）

## 見積もり

| 項目         | 値  |
| ------------ | --- |
| 見積もり時間 | h   |
| 実績時間     | h   |
```

## GitHub への同期

ファイル作成・更新後は必ず **Epic → Story → Task の順** で同期する（親子リンクのため）。

```bash
# Epic を同期
bash .claude/hooks/update-issues.sh "docs/issues/<N>. <エピック名>/epic.md"

# Story を同期
bash .claude/hooks/update-issues.sh "docs/issues/<epic>/[US-N] <ストーリー名>/story.md"

# Task を同期
bash .claude/hooks/update-issues.sh "docs/issues/<epic>/[US-N] <ストーリー名>/[TASK] <タスク名>.md"
```

**ポイント:**

- 冪等: 同じファイルを何度同期しても安全（既存Issueは本文のみ更新）
- ドライラン確認: `DRY_RUN=true bash .claude/hooks/update-issues.sh`

## タスク進捗の更新

実装が進んだらTaskファイルのチェックボックスを `[ ]` → `[x]` に更新し、GitHubに同期する。

```bash
bash .claude/hooks/update-issues.sh "docs/issues/<epic>/<story>/[TASK] タスク名.md"
```

## 実装開始前チェックリスト

実装に着手する前に必ず確認する:

1. `ls docs/issues/` で該当Epicが存在するか確認
2. 対応するStoryディレクトリ（`[US-N]`）が存在するか確認
3. Storyの中にTaskファイル（`[TASK]*.md`）が存在するか確認
4. 存在しない場合は Step 1〜3 でファイルを作成してから同期
5. **その後** に実装開始
