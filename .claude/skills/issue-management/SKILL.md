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
│   ├── epic_template.md
│   ├── story_template.md
│   └── task_template.md
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

## ファイル作成の手順

### 1. Epic を作成する

既存のEpicリストを確認し、該当Epicが存在しない場合のみ新規作成する。

```bash
# 既存のEpicを確認
ls docs/issues/
```

ディレクトリ名: `<連番>. <エピック名>`（例: `21. 技術的TODO`）

`docs/issues/<N>. <エピック名>/epic.md` を以下の形式で作成:

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

### 2. Story を作成する

ディレクトリ名: `[US-N] <ストーリー名>`（例: `[US-3] ユーザー登録ができる`）

`docs/issues/<epic>/<story>/story.md` を以下の形式で作成:

```markdown
## 概要

<!-- このストーリーで何を実現するかを 1〜2 文で説明する -->

## 親 EPIC

- EPIC: (<N>) <エピック名>

## ユーザーストーリー

**〈Who〉** として、**〈What〉** がしたい。なぜなら **〈Why〉** だからだ。

## 作業内容

- [ ] TASK 1: <タスク名>（別ファイルで詳細管理）

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

### 3. Task を作成する

ファイル名: `[TASK] <タスク名>.md`（例: `[TASK] ログインAPIエンドポイント実装.md`）

`docs/issues/<epic>/<story>/[TASK] <名前>.md` を以下の形式で作成:

```markdown
## 概要

<!-- この TASK で何を実装するかを 1〜2 文で説明する -->

## 親 STORY

- STORY: (<US-N>) <ストーリー名>

## 作業内容

- [ ] ...
- [ ] ...

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

ファイル作成・更新後は必ずGitHubに同期する。

### 単一ファイルを同期（推奨）

```bash
# Epic を同期
bash .claude/hooks/update-issues.sh docs/issues/<epic>/epic.md

# Story を同期（Epic が先に同期済みであること）
bash .claude/hooks/update-issues.sh "docs/issues/<epic>/<story>/story.md"

# Task を同期（Story が先に同期済みであること）
bash .claude/hooks/update-issues.sh "docs/issues/<epic>/<story>/[TASK] タスク名.md"
```

### 注意事項

- **順序が重要**: Epic → Story → Task の順で同期すること（親子リンクのため）
- **冪等**: 同じファイルを何度同期しても安全（マッピング済みのIssueは本文のみ更新）
- **ドライラン**: `DRY_RUN=true bash .claude/hooks/update-issues.sh` で実際には作成しない

## タスク進捗の更新

実装が進んだら Task ファイルのチェックボックスを更新し、GitHubに同期する。

```markdown
## 作業内容

- [x] APIエンドポイント実装（完了）
- [ ] テスト作成
- [ ] ドキュメント更新
```

更新後:

```bash
bash .claude/hooks/update-issues.sh "docs/issues/<epic>/<story>/[TASK] タスク名.md"
```

## 実装開始時のチェックリスト

1. 該当Epicが存在するか確認（`ls docs/issues/`）
2. 存在しない場合はEpicを作成してGitHubに同期
3. Storyを作成してGitHubに同期
4. Taskに分解してGitHubに同期
5. 実装開始

## よくある操作例

**新機能のIssue一式を作成する場合:**

```bash
# 1. Epicを作成・同期
bash .claude/hooks/update-issues.sh docs/issues/"21. 技術的TODO"/epic.md

# 2. Storyを作成・同期
bash .claude/hooks/update-issues.sh "docs/issues/21. 技術的TODO/[US-1] 〇〇機能/story.md"

# 3. Taskを作成・同期
bash .claude/hooks/update-issues.sh "docs/issues/21. 技術的TODO/[US-1] 〇〇機能/[TASK] 実装.md"
```
