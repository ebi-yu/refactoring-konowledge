---
name: create-issue
<<<<<<< HEAD
description: 新しい Epic / Story / Task の issue ファイルを作成して GitHub に同期するスキル。Issue を作って、Epic を追加して、Story を作って、Task を作って、と言われたときに使うこと。
=======
description: 新しいEpic / Story / Taskのissueファイルを作成してGitHubに同期する。「Issueを作って」「Epicを追加して」「ストーリーを作成して」「タスクを追加して」と言われたとき、または新しい機能・タスクのIssueファイルが必要なときに必ずこのスキルを使うこと。
>>>>>>> b7ee0ea2d181f9d93837b642c42a26e677d5eecd
---

# create-issue スキル

新しい Issue ファイルを作成し、GitHub に同期する。

## 現在の Issue ディレクトリ構造

!`ls issues/`

## あなたのタスク

新しい Issue ファイルを作成し、GitHub に同期する。

### ステップ 1: 作成するレベルを判断する

ユーザーのリクエストから何を作成するか判断する:

- **Epic** → `issues/<N>. <エピック名>/epic.md`
- **Story** → `issues/<epic>/<[US-N] ストーリー名>/story.md`
- **Task** → `issues/<epic>/<story>/[TASK] <タスク名>.md`

ディレクトリ番号は既存の最大番号 + 1 とする。

### ステップ 2: ファイルを作成する

#### Epic テンプレート

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
- [ ] ビルドが通っている

## 参照

- [feature_scope](.agents/references/feature_scope.md)
```

#### Story テンプレート

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

- [ ] **Given** <前提条件>
      **When** <操作>
      **Then** <結果>

## 完了の定義（DoD）

- [ ] 配下のすべてのTaskが完了している
- [ ] ビルドが通る
- [ ] セルフレビュー済み（lint / format エラーなし）
```

#### Task テンプレート

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

### ステップ 3: GitHub に同期する（Epic → Story → Task の順）

```bash
# Epic
bash .agents/hooks/update-issues.sh "issues/<epic>/epic.md"

# Story（Epicが同期済みであること）
bash .agents/hooks/update-issues.sh "issues/<epic>/<story>/story.md"

# Task（Storyが同期済みであること）
bash .agents/hooks/update-issues.sh "issues/<epic>/<story>/[TASK] タスク名.md"
```

### ステップ 4: 結果を報告する

作成したファイルパスと GitHub Issue 番号（#N）をユーザーに報告する。
