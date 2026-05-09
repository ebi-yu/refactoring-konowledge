---
name: task-implementation
description: Task 1件を実装するときに必ず使うスキル。Task Issueまたはlocal Taskファイルを受け取り、TDD、Red-Green-Refactor、検証、DoD達成、Task更新、完了報告までを扱う。Issue作成、ブランチ作成、PR/MR作成、AI依頼先判断は implements-orchestrator に戻す。
---

# task-implementation

このスキルは、1つの Task または Bug Task を実装するための実装規律を定義する。
Issue作成、親子紐づけ、ブランチ作成、PR/MR作成、AI依頼先判断は `implements-orchestrator` が担当する。

## 入力

実装を始める前に、次を受け取る。

- 対象 Task または Bug Task の local issue path
- 対象 GitHub Issue URL
- Handoff block
- Scope / Out of scope
- 受け入れ条件
- DoD
- 必要な検証コマンド

不足している場合は、実装に進まず `implements-orchestrator` に戻す。

## 実装フロー

1. Task ファイルと GitHub Issue の内容を読む。
2. Scope / Out of scope / DoD を確認する。
3. 既存実装とテスト構造を読む。
4. 先に失敗するテストを書く。
5. テストが期待通り失敗することを確認する。
6. 最小限の実装でテストを通す。
7. Refactor する。
8. DoD に必要な lint、typecheck、build、test を実行する。
9. Task ファイルの完了した作業項目を更新する。
10. 検証結果と残リスクをまとめて `implements-orchestrator` に返す。

## TDD

原則として Red -> Green -> Refactor で進める。

```text
Red:
  期待する振る舞いをテストで表現し、失敗を確認する。

Green:
  最小限の実装でテストを通す。

Refactor:
  振る舞いを変えずに構造を整え、テストを再実行する。
```

テストを書けない場合は、理由と代替検証を明記する。仕様判断や検証不能な状態が残る場合は、人間判断が必要なものとして報告する。

## バグ修正

Bug Task では、まず再現テストを優先する。

- 再現テストを書ける場合は、失敗を確認してから修正する。
- 再現テストを書けない場合は、手動再現手順と代替検証を明記する。
- 原因が Task の範囲を超える場合は、実装を広げず `implements-orchestrator` に戻す。

## 変更範囲

- Handoff block の Scope 内だけを変更する。
- Out of scope に含まれるファイルや振る舞いを変更しない。
- 関連しないリファクタリングをしない。
- 既存のユーザー変更を戻さない。
- shared schema、public API、DB schema、auth、permission、config に触れる必要が出たら作業を止め、`implements-orchestrator` に戻す。

## 検証

DoD に応じて必要な確認を実行する。

- unit test
- integration test
- e2e test
- lint
- typecheck
- build
- formatter check
- manual browser verification

検証コマンドが失敗した場合は、失敗内容、原因推定、修正可否を整理する。Task 範囲外の失敗は勝手に修正しない。

## Task ファイル更新

実装完了時は local Task ファイルを更新する。

- 完了した作業項目を `[x]` にする。
- 実行した検証を記録する。
- 未完了項目や残リスクがある場合は明記する。

GitHub Issue への同期、進捗ラベル更新、PR/MR 作成は `implements-orchestrator` に戻す。

## コミット

コミットは小さく意味のある単位で行ってよい。
ただし、Task 範囲外の変更を混ぜない。
PR/MR で確認しやすい粒度を優先する。

## 完了報告

完了時は次を `implements-orchestrator` に返す。

```text
Task: <local issue path and GitHub Issue>
Changed files: <files>
Tests: <commands and results>
DoD: <met | not met>
Remaining risks: <none or details>
Suggested auto-merge: <yes | no | ask human>
Reason: <why>
```

## よくある間違い

- Issue 作成やPR/MR作成まで担当しない。
- Scope を超えて修正しない。
- テストなしで実装だけ進めない。
- Task ファイルを更新し忘れない。
- 検証不能な変更を自動マージ候補にしない。
