# [EPIC] 初期環境構築

## 概要

Nuxt 4 フルスタックアプリケーションの初期開発環境を Modular Monolith・レイヤードアーキテクチャに沿ってセットアップする。
Mise によるランタイム統一・Docker Compose によるインフラ起動・Nuxt 4 スキャフォールド・型安全ツールチェーン（TypeScript/Lint/Format）・Prisma・Panda CSS を整備し、チーム全員がコマンド一発で開発を始められる状態を作る。

## EPIC ストーリー

**開発者** として、**クローン直後にコマンド数本でローカル開発環境が動く状態** にしたい。なぜなら **環境差異によるトラブルをなくし、本質的な機能開発にすぐ集中できるようにしたい** からだ。

## スコープ（STORY 一覧）

> 優先度: `Must` = リリース必須 / `Should` = できれば含める / `Could` = 余裕があれば

| 優先度 | #   | ストーリー（一文）                                                                                                                                                                   | Issue |
| ------ | --- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | ----- |
| `Must` | 1   | 開発者として、Mise と Docker Compose でランタイム・インフラを一発で立ち上げたい。なぜなら Node/Bun バージョン差異や DB 起動手順の属人化をなくしたいから。                            | -     |
| `Must` | 2   | 開発者として、Nuxt 4 フルスタックの土台（スキャフォールド・ディレクトリ構造・nuxt.config）を整えたい。なぜなら architecture.md に沿った開発を始めたいから。                          | -     |
| `Must` | 3   | 開発者として、TypeScript (tsgo)・Oxlint・Oxfmt・Husky でコード品質ゲートを自動化したい。なぜなら型エラーやスタイル違反をコミット前に検出して品質を保ちたいから。                     | -     |
| `Must` | 4   | 開発者として、Prisma でデータベーススキーマを管理したい。なぜなら型安全なDBアクセスとマイグレーション管理を一元化したいから。                                                        | -     |
| `Must` | 5   | 開発者として、Panda CSS のセットアップと基本デザイントークン（カラー・タイポ・スペーシング・semantic token）を定義したい。なぜなら一貫したデザインシステムの上でUIを実装したいから。 | -     |

## スコープ外

- **CI/CD パイプライン**: GitHub Actions の設定は別 EPIC（インフラ・運用）で対応
- **本番環境デプロイ設定**: Fly.io / Railway 等の本番設定は別 EPIC で対応
- **デザインコンポーネント実装**: Panda CSS のトークン定義までで、コンポーネントの実装は各機能 EPIC で対応
- **Meilisearch インデックス設計**: 起動確認までで、インデックス定義は検索 EPIC で対応

## 受け入れ基準（EPIC 完了の定義）

- [x] 配下のすべての `Must` STORY が Done になっている
- [x] `docker compose up -d` で PostgreSQL・Meilisearch が起動する
- [x] `bun run dev` でローカル開発サーバーが起動する
- [x] `npx tsgo --noEmit` で型エラーなし
- [x] `bun run lint` でエラーなし
- [x] `bun run build` でビルド成功
- [x] `git commit` 時に pre-commit フックが実行される
- [x] `bunx prisma db push` で DB に接続・同期できる

## 参照

- [feature_scope](https://github.com/ebi-yu/refactoring-konowledge/blob/main/docs/feature_scope.md) - 機能スコープ一覧
- [architecture.md](https://github.com/ebi-yu/refactoring-konowledge/blob/main/docs/architecture.md) - アーキテクチャ設計
- [tech_stack.md](https://github.com/ebi-yu/refactoring-konowledge/blob/main/docs/tech_stack.md) - 技術スタック詳細
