---
name: implements
description: AIがタスクを進めるときの実装フロー全体を管理するスキル。新機能を実装するとき、エピック・ストーリー・タスクを選ぶとき、ブランチを作成するとき、「Issueを作って」「実装を始めて」「次のタスクに進んで」と言われたときに必ずこのスキルを使うこと。
---

# implements スキル

このプロジェクトの開発フローは **Epic単位で計画し、Task単位で実装し、PRで統合する**。
GitHub Issues とローカルの `issues/` を連携し、Epic → Story → Task の3層でタスクを管理する。

実行前のAIルーティング判断は `.agents/skills/route-ai-work/SKILL.md` に従う。このスキルでは、ルーティング後の実装作業を進める。

---

## 開発の進め方

### 前提

- GitHub Issue とローカルの `issues/` の内容を連携させている
- 連携には `.agents/hooks/update-issues.sh` を使用する
- ブランチ戦略は `.agents/references/branch-strategy.md` を参照すること
- フロントエンドの実装フローは `references/frontend-workflow.md` を参照すること
- バックエンドの実装フローは `references/backend-workflow.md` を参照すること

---

### Step 0. Epic / Story / Task の決定

`issues/` 配下から対象の Epic を確認し、Story と Task を選ぶ。

```bash
ls issues/
```

Story 内の `[TASK]*.md` を洗い出し、依存関係を整理する。
Issue ファイルが存在しない場合は「Issue ファイル作成手順」で Epic → Story → Task の順に作成・同期してから進む。

---

### Phase 0. Epic開始前：デザインフェーズ

UIを含むEpicでは、実装前にエピック全体の画面・UIパターンを俯瞰し、デザイントークンと要素を揃える。
ピクセルパーフェクトではなく、配置・情報構造・必要コンポーネントが伝わるワイヤーフレームで十分。

やること:

1. `issues/<epic>/epic.md` と Story 一覧から、UIが必要なページ・状態を洗い出す
2. `.pen` でモックを作り、レイアウト、情報構造、UIパターン、空・ローディング・エラー状態を確認する
3. `panda.config.ts` の semantic tokens など、不足するデザイントークンを確認・調整する
4. 必要ならデザイン・トークン確認をコミットする

```bash
git commit -m "design(<epic>): モックデザイン・デザイントークン確認"
```

タスク実装中に迷った場合は、Phase 0 のモックとトークンに立ち返る。
複数Epicで同じUIパターンが出た場合は `common/` への抽出を検討する。抽出の目安は2回目に使おうとしたとき。

---

### Phase 1. Story → Task の確認

対象 Story の `story.md` を読み、Task 一覧と依存関係を整理する。

```bash
ls "issues/<epic>/<story>/"*.md
```

依存関係のない Task は並列実行できる。依存がある Task は順序を決めて実行する。

---

### Phase 2. Task単位の実装

**Task 1件 = ブランチ1本 = PR1本** を基本単位にする。

#### ブランチの作成（実装前に必ず行う）

`.agents/references/branch-strategy.md` を参照し、**上位ブランチから順に**作成する。

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

#### タスクの並列実行

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

#### フロントエンドタスク

`references/frontend-workflow.md` に従う。

```
E2Eテスト作成（Red）
  → 実装（Green）
  → browser-use で視覚確認
  → Refactor
```

Phase 0 のモックと `panda.config.ts` のトークンを見ながら実装する。

#### バックエンドタスク

`references/backend-workflow.md` に従う。

```
TDD: Red → Green → Refactor
```

#### タスク完了時の必須手順

各タスクが完了したら**必ず**以下を実行する:

1. `[TASK]*.md` の完了した作業項目を `[x]` に更新する
2. テスト・ビルド・lint / format など、Task の DoD に必要な検証を実行する
3. フロントエンドの場合は browser-use で視覚確認する
4. GitHub に同期する:
   ```bash
   bash .agents/hooks/update-issues.sh "<タスクファイルパス>"
   ```
5. 小さく意味のある単位でコミットする

```bash
git commit -m "<type>(<scope>): <変更内容>"
```

すべてのタスクが完了したら、`story.md` の作業内容も更新してコミットする。

---

### Phase 3. Epic完了確認とPR統合

Story / Epic の完了時は、受け入れ基準と DoD を確認する。

- Must Story がすべて Done になっている
- 配下の Task がすべて完了している
- E2E シナリオや必要なテストが通っている
- ドキュメント・Issue ファイルが更新され、GitHub に同期されている

#### PR の作成とマージ

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

`issues/<N>. <エピック名>/epic.md`:

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
bash .agents/hooks/update-issues.sh "issues/<N>. <エピック名>/epic.md"
bash .agents/hooks/update-issues.sh "issues/<epic>/[US-N] <ストーリー名>/story.md"
bash .agents/hooks/update-issues.sh "issues/<epic>/[US-N] <ストーリー名>/[TASK] <タスク名>.md"
```
