# AI作業の振り分けポリシー

このファイルは `implements-orchestrator` が参照する判断ルールである。
独立したスキルとして使わず、作業開始前に orchestrator が実行レーンを1つ選ぶために使う。

最初に一致したルールを採用する。複数のレーンを「どれでもよい」として提示してはいけない。

## 定量的なサイズ

振り分けの前に、変更対象となる本番コードのファイル数と、本番コードの正味 LOC を見積もる。
テスト、ドキュメント、生成ファイル、ロックファイル、整形だけの差分は本番 LOC に含めない。

| サイズ | 本番ファイル数 |    本番 LOC |
| ------ | -------------: | ----------: |
| Small  |      1-3 files |   1-120 LOC |
| Medium |      4-8 files | 121-400 LOC |
| Large  |       9+ files |    401+ LOC |

ファイル数と LOC の判定が異なる場合は、より大きい方を採用する。

## 定量的なスコープ

| スコープ     | 定義                                                                                   |
| ------------ | -------------------------------------------------------------------------------------- |
| Isolated     | `[TASK]*.md` または `[BUG]*.md` が1つ、アプリ層が1つだけで、共有契約ファイルを含まない |
| Cross-module | 2つ以上のアプリ層にまたがる、または共有契約ファイルを含む                              |
| Multi-story  | 複数の Story ディレクトリ、または複数の GitHub Issue にまたがる                        |

アプリ層は `app/`、`server/`、`shared/`、`prisma/`、および設定ファイルである。
共有契約ファイルには `shared/schemas/`、`server/domain/`、`prisma/schema.prisma`、`panda.config.ts`、`nuxt.config.ts`、パッケージマネージャー関連ファイル、CI/deploy 関連ファイルを含める。

## レーン

| レーン                            | 担当            | 場所                   | 用途                                                                                       |
| --------------------------------- | --------------- | ---------------------- | ------------------------------------------------------------------------------------------ |
| local-claude-planning-review      | Claude Code Pro | ローカルワークスペース | 計画、分解、要件明確化、リスクレビュー、最終レビュー                                       |
| local-codex-implementation        | Codex Pro       | ローカルワークスペース | リポジトリ文脈、テスト、秘密情報を安全に扱うローカルコマンド、機微な領域が必要な決定的編集 |
| cloud-github-codex-implementation | Codex cloud     | GitHub/Codex cloud     | Issue/PR 文脈だけで完結し、クラウド側で検証できる独立した実装                              |
| github-copilot-fixes-review       | GitHub Copilot  | GitHub PR/editor       | 小さな PR コメント対応、局所的修正、レビュー提案対応、機械的な後続修正                     |

## 順序付き振り分けルール

1. 要求が計画、デザインレビュー、スコープ定義、分解、受け入れ条件、コードレビュー、リスクレビュー、または作業の進め方の判断である場合は、`local-claude-planning-review` を選ぶ。
2. DB スキーマやマイグレーション、認証、認可、権限、シークレット、依存バージョン、パッケージマネージャー設定、ビルド/ランタイム設定、CI 設定、デプロイ設定、デザイントークン、共有スタイル基盤に触れる場合は、サイズに関係なく `local-codex-implementation` を選ぶ。
3. ローカルにしかない文脈、未コミットのワークスペース状態、非公開ファイル、ローカルサービス、手動ブラウザ検証、環境変数、または GitHub/Codex cloud では使えないコマンドが必要な場合は、`local-codex-implementation` を選ぶ。
4. バグ修正は原則 `cloud-github-codex-implementation` を選ぶ。ただし、Large、Cross-module、Multi-story、機微な領域、ローカル専用検証が必要な場合は、User Story 作成または `local-codex-implementation` を検討し、人間に確認する。
5. 実装が Large の場合は、`local-codex-implementation` を選ぶ。
6. 実装が Medium で、スコープが `Cross-module` または `Multi-story` の場合は、`local-codex-implementation` を選ぶ。
7. 実装が Small または Medium で、スコープが `Isolated`、GitHub Issue または PR が1つだけ、かつ GitHub/Codex cloud 上で完全に検証できる場合は、`cloud-github-codex-implementation` を選ぶ。
8. タスクが小さな GitHub PR レビューコメント対応、typo レベルの修正、局所的な lint/type エラー修正、または 1-2 ファイルかつ本番 LOC 80 行以内のレビュー提案対応である場合は、`github-copilot-fixes-review` を選ぶ。
9. 上記のどれにも当てはまらない場合は、`local-codex-implementation` を選ぶ。

## 人間に質問する条件

次の条件では、レーンを決めきらず人間に質問する。

- `cloud-github-codex-implementation` と `local-codex-implementation` のどちらも成立しそうだが、ローカル文脈が必要か判断できない。
- バグが Task 1件で収まるか、User Story を作るべきか迷う。
- 自動マージしてよいか判断できない。
- 仕様、UX、セキュリティ、データ互換性に関する判断が必要。
- 検証手段が不足している。

## 必須 Handoff block

振り分けの判断では、実行開始前に毎回このブロックを含める。

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

## レーン別委託方法

| レーン                            | 委託方法                                                                                                                                               |
| --------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------ |
| local-claude-planning-review      | この会話の中でそのまま実行する。追加の委託コマンドは不要。                                                                                             |
| local-codex-implementation        | Codex に委託する。Handoff block を添えて、対象範囲、非対象範囲、検証条件を明示する。                                                                   |
| cloud-github-codex-implementation | GitHub 上の Issue または PR に委託する。Handoff block を本文またはコメントに貼り、対象 Issue を明示し、GitHub/Codex cloud だけで完結できる状態にする。 |
| github-copilot-fixes-review       | GitHub PR またはエディタ上で GitHub Copilot に依頼する。対象ファイル、期待する局所修正、確認条件を明示し、1-2 ファイル程度の狭い修正に限定する。       |

## よくある間違い

- 2つのレーンがどちらも妥当だと言わない。順序付きルールを適用し、最初に一致したものを選ぶ。
- 修正が小さいという理由で、機微な領域を cloud や Copilot に振り分けない。
- 実装サイズの見積もりに、テストやドキュメントの LOC を含めない。
- Copilot に広範囲のリファクタリング、設計変更、複数ファイルにまたがる振る舞い変更を担当させない。
