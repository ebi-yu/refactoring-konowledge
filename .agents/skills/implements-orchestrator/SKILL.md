---
name: implements-orchestrator
description: 開発作業の入口として必ず使うスキル。Issue作成、次のタスク選定、実装開始、バグ対応、ブランチ準備、GitHub Issue同期、PR/MR作成、AI依頼先判断、Issue進捗ラベル、open/close、自動マージ判断を扱うときに使う。
---

# implements-orchestrator

このスキルは、このリポジトリの開発作業を開始・進行・統合する入口である。
具体的な実装方法は扱わず、`issues/`、GitHub Issue、ブランチ、PR/MR、AI依頼先、進捗ラベル、open/close、自動化判断を管理する。

## 基本方針

- `issues/` を一次情報とする。GitHub Issue は `issues/` から同期する。
- Epic / Story / Task の3階層を必ず使う。
- Task 1件 = GitHub Issue 1件 = PR/MR 1件を原則にする。
- Task Issue は親 Story Issue に紐づける。
- Story Issue は親 Epic Issue に紐づける。
- AI依頼先はこのスキルが決める。迷う場合は人間に質問する。
- 具体実装は `task-implementation` に渡す。
- バグを検出したら `bug-triage` を呼ぶ。
- コミットは小さく意味のある単位で行ってよい。確認はPR/MRで行う。

## 参照

- ブランチ戦略: `.agents/references/branch-strategy.md`
- AI依頼先判断: `.agents/skills/implements-orchestrator/references/routing-policy.md`
- GitHub Issue同期: `.agents/hooks/update-issues.sh`
- Task実装規律: `.agents/skills/task-implementation/SKILL.md`
- バグ整理: `.agents/skills/bug-triage/SKILL.md`

## 開始時の必須手順

作業を始める前に、必ず次を行う。

1. `git status --short --branch` で既存差分を確認する。
2. 既存差分はユーザー変更として扱い、勝手に戻さない。
3. `git pull` で現在ブランチを最新化する。
4. `.agents/references/branch-strategy.md` に従って作業ブランチを準備する。
5. 作業ブランチで `git pull origin main` を実行する。

既存の Epic / Story / Task ブランチがある場合は、それを尊重する。存在しない場合は上位から順に作る。

```text
main
  -> epic/<epic-name>
    -> us/<story-name>
      -> task/<task-name>
```

## 通常開発フロー

1. ユーザー依頼と `issues/` を確認し、対象 Epic / Story / Task を決める。
2. 必要な Issue ファイルがなければ、Epic -> Story -> Task の順で作る。
3. `bash .agents/hooks/update-issues.sh "<path>"` で Epic -> Story -> Task の順に GitHub Issue へ同期する。
4. 親子関係が GitHub 上で張られていることを確認する。
5. Issue に進捗ラベルを付ける。
6. `references/routing-policy.md` に従って AI依頼先を決める。
7. Handoff block を作成し、選んだ依頼先へ渡す。
8. ローカル実装が必要な場合は `task-implementation` を使う。
9. 完了後、Task ファイルと GitHub Issue を更新する。
10. Task 1件につき PR/MR を1件作る。
11. 自動マージ可否を判断する。
12. merge 後、Task Issue を close し、親 Story / Epic の状態を確認する。

## Issue作成ポリシー

すべての実装作業は Task Issue から始める。GitHub Issue だけを先に作らず、まず `issues/` に反映する。

```text
issues/<N>. <epic>/epic.md
issues/<N>. <epic>/[US-N] <story>/story.md
issues/<N>. <epic>/[US-N] <story>/[TASK] <task>.md
```

バグの場合は Task ファイル名を `[BUG] <内容>.md` にする。

```text
issues/<N>. <epic>/[US-N] <story>/[BUG] ログイン失敗時に500になる.md
```

## バグ発見時のフロー

バグ、リグレッション、失敗するテスト、想定外のUI/API結果、production defect を見つけたら、すぐに `bug-triage` を呼ぶ。

`bug-triage` は次を行う。

- 再現手順、期待結果、実際結果、影響範囲を整理する。
- 既存 Issue との重複を確認する。
- 必ず Epic / Story / Task の3階層に入れる。
- 既存 Story に属さない場合、固定の Maintenance 親は作らず、その都度適切な Epic / Story を作る。
- `[BUG] ... .md` を `issues/` に作る。
- GitHub Issue を作成し、親子関係を紐づける。
- 原則 `cloud-github-codex-implementation` にアサインする。
- 大きい場合、複数修正が必要な場合、仕様整理が必要な場合は User Story 作成を検討する。

## Issue進捗ラベル

GitHub Issue には進捗ラベルを付ける。

```text
status:ready        実装可能
status:in-progress  AIまたは人間が作業中
status:blocked      依存、仕様未確定、環境問題で停止
status:review       PR/MR確認待ち
status:done         merge済みまたは対応完了
```

種別ラベルも付ける。

```text
type:epic
type:story
type:task
type:bug
```

バグには必要に応じて severity ラベルを付ける。

```text
severity:critical
severity:high
severity:medium
severity:low
```

## Issue open / close ポリシー

- Epic / Story / Task / Bug を作成した時点で open にする。
- 作業可能なら `status:ready`、情報不足なら `status:blocked` にする。
- ブランチ作成またはAIアサイン時点で `status:in-progress` にする。
- PR/MR 作成時に `status:review` にする。
- PR/MR が merge され、DoD を満たした時点で `status:done` にし、Task Issue を close する。
- close 前に local `issues/` も完了状態へ更新し、GitHub Issue に同期する。

親 Issue は次のように扱う。

- Task は PR/MR merge 後に close する。
- Story は配下 Task がすべて done なら `status:review` にし、受け入れ条件を満たせば close する。
- Epic は配下 Story がすべて done なら `status:review` にし、原則 human review 後に close する。

## PR/MRポリシー

- Task 1件につき PR/MR を1件作る。
- PR/MR には関連 Task Issue を必ず紐づける。
- Story / Epic も辿れる状態にする。
- MR/PR 作成時は Copilot をレビュワーに指定する。
- PR/MR の説明には実施内容、検証結果、自動マージ可否、human review が必要な理由を明記する。

## 自動マージポリシー

自動マージの基準は変更の小ささではなく、検証可能性で判断する。

```text
Small だから自動マージではない。
テスト・CI・DoDで十分に検証でき、人間の判断が不要だから自動マージできる。
```

次をすべて満たす場合、自動マージしてよい。

- Task 1件だけに紐づく PR/MR である。
- 受け入れ条件と DoD が明確である。
- CI が green である。
- テスト、lint、typecheck、build で十分に検証できる。
- DB schema、migration、auth、permission、secret、dependency、build config、deploy config、CI config に触れていない。
- UI/UX、文言、仕様の判断が不要である。
- public API、shared schema、複数 Story に影響しない。
- 破壊的変更ではない。

自動マージしやすい例:

- 再現テスト付きの小さなバグ修正
- 型エラー修正
- lint 修正
- テスト追加
- dead code 削除
- 明白な typo 修正

## Human Review ポリシー

次のどれかに該当する場合は、人間判断を残す。

- 仕様判断が必要
- UI/UX、デザイン、文言の判断が必要
- DB schema、migration、auth、permission、security に触る
- dependency、build、deploy、CI config に触る
- public API、shared schema を変更する
- 複数 Story / 複数 Issue に影響する
- Large 変更である
- テストで十分に確認できない
- flaky test や検証不能な状態が残っている

## Handoff block

AIへ渡すときは、必ず routing-policy の判断結果を含む Handoff block を作る。

```text
Lane: <lane id>
Owner: <Claude Code Pro | Codex Pro | Codex cloud | GitHub Copilot>
Place: <local workspace | GitHub/Codex cloud | GitHub PR/editor>
Size: <small | medium | large> (<production files>, <production LOC estimate>)
Reason: <first matching routing rule and why it matched>
Scope: <what is included>
Out of scope: <what must not be changed>
Verification: <required checks before completion>
Issue: <GitHub Issue URL or local issue path>
Branch: <target branch>
PR/MR: <required PR/MR target>
Auto-merge: <allowed | not allowed | ask human>
```

## よくある間違い

- `issues/` を更新せずに GitHub Issue だけを作らない。
- 親子関係のない Task から始めない。
- Task 1件に複数 PR/MR を作らない。
- 複数 Task を1つの PR/MR にまとめない。
- バグを見つけたまま即修正しない。まず `bug-triage` で Issue 化する。
- AI依頼先に迷ったまま進めない。迷ったら人間に質問する。
