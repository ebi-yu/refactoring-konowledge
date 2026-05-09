---
name: route-ai-work
description: Claude Code Pro、Codex Pro、GitHub Codex cloud、GitHub Copilot のどこに AI 支援のソフトウェア作業を割り当てるべきかを、実装・修正・レビューの前に判断するときに使います。
---

# AI 作業の振り分け

## 目的

作業を始める前に、実行レーンを 1 つ選びます。このスキルは、ローカル実行かクラウド実行か、どのツールが担当するかという曖昧な判断をなくし、まず作業を振り分け、その後 `implements` が選ばれたレーンを実行します。

最初に一致したルールを採用します。複数のレーンを「どれでもよい」として提示してはいけません。

## 定量的なサイズ

振り分けの前に、変更対象となる本番コードのファイル数と、本番コードの正味 LOC を見積もります。テスト、ドキュメント、生成ファイル、ロックファイル、整形だけの差分は本番 LOC に含めません。

| サイズ | 本番ファイル数 |    本番 LOC |
| ------ | -------------: | ----------: |
| Small  |      1-3 files |   1-120 LOC |
| Medium |      4-8 files | 121-400 LOC |
| Large  |       9+ files |    401+ LOC |

ファイル数と LOC の判定が異なる場合は、より大きい方を採用します。

## 定量的なスコープ

| スコープ     | 定義                                                                            |
| ------------ | ------------------------------------------------------------------------------- |
| Isolated     | `[TASK]*.md` がちょうど 1 つ、アプリ層が 1 つだけで、共有契約ファイルを含まない |
| Cross-module | 2 つ以上のアプリ層にまたがる、または共有契約ファイルを含む                      |
| Multi-story  | 複数の Story ディレクトリ、または複数の GitHub Issue にまたがる                 |

アプリ層は `app/`、`server/`、`shared/`、`prisma/`、および設定ファイルです。共有契約ファイルには `shared/schemas/`、`server/domain/`、`prisma/schema.prisma`、`panda.config.ts`、`nuxt.config.ts`、パッケージマネージャー関連ファイル、CI/deploy 関連ファイルを含みます。

## レーン

| レーン                            | 担当            | 場所                   | 用途                                                                                       |
| --------------------------------- | --------------- | ---------------------- | ------------------------------------------------------------------------------------------ |
| local-claude-planning-review      | Claude Code Pro | ローカルワークスペース | 計画、分解、要件明確化、リスクレビュー、最終レビュー                                       |
| local-codex-implementation        | Codex Pro       | ローカルワークスペース | リポジトリ文脈、テスト、秘密情報を安全に扱うローカルコマンド、機微な領域が必要な決定的編集 |
| cloud-github-codex-implementation | Codex cloud     | GitHub/Codex cloud     | issue/PR 文脈だけで完結し、クラウド側で検証できる独立した実装                              |
| github-copilot-fixes-review       | GitHub Copilot  | GitHub PR/editor       | 小さな PR コメント対応、局所的修正、レビュー提案対応、機械的な後続修正                     |

## 順序付き振り分けルール

1. 要求が計画、デザインレビュー、スコープ定義、分解、受け入れ条件、コードレビュー、リスクレビュー、または作業の進め方の判断である場合は、`local-claude-planning-review` を選びます。
2. DB スキーマやマイグレーション、認証、認可、権限、シークレット、依存バージョン、パッケージマネージャー設定、ビルド/ランタイム設定、CI 設定、デプロイ設定、デザイントークン、共有スタイル基盤に触れる場合は、サイズに関係なく `local-codex-implementation` を選びます。
3. ローカルにしかない文脈、未コミットのワークスペース状態、非公開ファイル、ローカルサービス、手動ブラウザ検証、環境変数、または GitHub/Codex cloud では使えないコマンドが必要な場合は、`local-codex-implementation` を選びます。
4. 実装が large の場合は、`local-codex-implementation` を選びます。
5. 実装が medium で、スコープが `Cross-module` または `Multi-story` の場合は、`local-codex-implementation` を選びます。
6. 実装が small または medium で、スコープが `Isolated`、GitHub issue または PR が 1 つだけ、かつ GitHub/Codex cloud 上で完全に検証できる場合は、`cloud-github-codex-implementation` を選びます。
7. タスクが小さな GitHub PR レビューコメント対応、typo レベルの修正、局所的な lint/type エラー修正、または 1-2 ファイルかつ本番 LOC 80 行以内のレビュー提案対応である場合は、`github-copilot-fixes-review` を選びます。
8. 上記のどれにも当てはまらない場合は、`local-codex-implementation` を選びます。

## 必須ハンドオフブロック

振り分けの判断では、実行開始前に毎回このブロックを含めなければなりません。

```text
Lane: <lane id>
Owner: <Claude Code Pro | Codex Pro | Codex cloud | GitHub Copilot>
Place: <local workspace | GitHub/Codex cloud | GitHub PR/editor>
Size: <small | medium | large> (<production files>, <production LOC estimate>)
Reason: <first matching routing rule and why it matched>
Scope: <what is included>
Out of scope: <what must not be changed>
Verification: <required checks before completion>
```

## 委託の実行方法

レーンを選んだ後は、次の方法で実際の作業を委託します。

| レーン                            | 委託方法                                                                                                                                                                                                                              |
| --------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| local-claude-planning-review      | この会話の中でそのまま実行します。追加の委託コマンドは不要で、Claude Code 上で計画、レビュー、分解、最終確認を進めます。                                                                                                              |
| local-codex-implementation        | `/codex` スキルで Codex に委託します。上のハンドオフブロックを添えて、対象範囲、非対象範囲、検証条件を明示したうえでローカルワークスペースで実装させます。                                                                            |
| cloud-github-codex-implementation | GitHub 上の Issue または PR に委託します。ハンドオフブロックを本文またはコメントに貼り、対象 Issue を明示し、必要なら担当者を割り当てて GitHub/Codex cloud だけで完結できる状態にして渡します。ローカル専用情報は渡してはいけません。 |
| github-copilot-fixes-review       | GitHub PR またはエディタ上で GitHub Copilot に依頼します。対象ファイル、期待する局所修正、確認条件を明示し、1-2 ファイル程度の狭い修正に限定します。                                                                                  |

### local-codex-implementation の委託テンプレート

```text
/codex スキルで実装してください。

Lane: local-codex-implementation
Owner: Codex Pro
Place: local workspace
Size: <small | medium | large> (<production files>, <production LOC estimate>)
Reason: <first matching routing rule and why it matched>
Scope: <what is included>
Out of scope: <what must not be changed>
Verification: <required checks before completion>
```

### local-claude-planning-review の実行ルール

このレーンは委託ではなく、この会話の担当者がそのまま実行します。ユーザーへの返答にはハンドオフブロックを出したうえで、計画、レビュー、分解、受け入れ条件整理などを続けます。

### cloud-github-codex-implementation の委託ルール

- GitHub Issue か PR を 1 つに絞ること。
- ハンドオフブロックを本文、説明、またはレビューコメントに含めること。
- 必要なら担当者をアサインし、着手対象を明確にすること。
- ローカルの未コミット変更、秘密情報、環境変数、手元サービス前提の情報を含めないこと。
- GitHub 上だけで検証できる確認手順を書くこと。

### github-copilot-fixes-review の委託ルール

- PR コメント返信やエディタ依頼では、修正箇所を狭く限定すること。
- ファイル、症状、期待する修正を具体的に書くこと。
- 大きな設計変更や複数モジュール横断修正に広げないこと。
- 必要なら lint、typecheck、該当テストなど最小の確認条件を添えること。

## implements との関係

`route-ai-work` は、レーン、担当者、場所、サイズ、ハンドオフ制約を選びます。`implements` は、そのハンドオフが存在した後で実装を実行します。レーンの再判断に `implements` を使ってはいけません。

## よくある間違い

- 2 つのレーンがどちらも妥当だとは言わないこと。順序付きルールを適用し、最初に一致したものを選ぶこと。
- 修正が小さいという理由で、機微な領域を cloud や Copilot に振り分けないこと。
- 実装サイズの見積もりに、テストやドキュメントの LOC を含めないこと。
- Copilot に広範囲のリファクタリング、設計変更、複数ファイルにまたがる振る舞い変更を担当させないこと。
