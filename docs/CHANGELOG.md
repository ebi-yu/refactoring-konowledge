# CHANGELOG — knowledge リライトプロジェクト

> `document/rewrite/` 以下のドキュメント作業ログ。
> Git コミット前の作業記録として管理する。

---

## [Unreleased] — 2026-04-05

### Added

#### `story/2. 記事（ナレッジ）投稿・管理/epic.md`

- `[Epic] 記事（ナレッジ）投稿・管理` を新規作成
- Ph1 スコープイン機能（2-1〜2-5）を `Must`、ファイル添付（2-6）を `Should` で整理
- スコープ外（テンプレート・共同編集・差分表示・ピン留め・メール投稿・グループ限定公開）を理由付きで明記

---

## [Unreleased] — 2026-04 (前セッション)

### Added

#### `01_feature_scope.md` — 機能スコープ一覧（全面改訂）

- **凡例に `[x2]`（Ph2）を追加**
- **Section 1 認証**: セクション注釈追加（Ph1/Ph2 分離方針）
  - `1-1` 組み込みメール+パスワード認証を Ph1 一次手段として明示
  - `1-2`, `1-3` を `[△]`（条件付き最小実装）に変更
  - `1-8` APIトークンを `[x2]`（REST API は Ph2 のため連動）
  - `1-9` 外部IdP連携（OIDC/Keycloak）を `[x2]` で新規追加
- **Section 2 記事管理**: `2-4` 公開範囲から「特定グループ」を削除（Ph2 追加と明記）
- **Section 4 検索・発見**: 再番号付け＋新機能追加
  - `4-4` 閲覧履歴を `[-]` に（低価値で削除）
  - `4-5` 関連記事を `[x2]` に変更（AI統合予定）
  - `4-6` 新着記事フィード `[x]` 🆕 追加
  - `4-7` 勢い記事（トレンド）`[x]` 🆕 追加（時間減衰加重スコア方式）
- **Section 6 グループ・アクセス制御**: セクション注釈追加（Keycloak Ph2 必須方針）
  - `6-1` グループ作成を `[-]`（アプリ内UI なし、Keycloak 側管理）
  - `6-2` グループ限定公開を `[x2]`（Keycloak 必須 Ph2）
  - `6-3` RBAC を `[x2]`（Keycloak 必須 Ph2）
- **Section 7 通知**: `7-4` Webhook連携を `[x2]` に変更
- **Section 11 管理者**:
  - `11-1` ユーザー管理: Ph1 は基本ロール（管理者/一般）のみと明記
  - `11-3` メール設定を `[△]`（1-2・1-3 が有効な場合のみ必要）
  - `11-6` Webhook管理を `[x2]` に変更
- **Section 12**: 名称を「REST API / CLI（外部連携）」に変更
  - `12-5` CLI連携 `[x2]` 🆕 追加
- **Section 13 新規機能** 全体を新規追加:
  - **13-A Knowledgebase / RAG連携**: `13-5` 外部RAG同期 `[x2]`、`13-6` AI Q&A（RAGベース）`[x2]`
  - **13-B クラウドストレージ連携**: `13-7` S3/R2/MinIO 設定 `[x]`
  - **13-C セルフホストサポート**: `13-8`〜`13-12`（Docker Compose 起動・env 設定・ヘルスチェック・バックアップ・アップグレードガイド）全 `[x]`
  - **13-D 体系的知識（Book 機能）**: `13-13`〜`13-16`（本作成・チャプター管理・目次ナビ Ph2・公開設定）
  - **13-E 旧システム移行**: `13-17`〜`13-22`（ユーザー・記事・添付・コメント・グループ移行・検証レポート）
- **サマリテーブル更新**: `Ph2[x2]`・`部分[△]` 列を追加
  - 合計 86件 | 新規 22件 | Ph1=37 | Ph2=19 | 部分=3 | 除外=26 | 未決=0

#### `02_tech_stack.md` — 技術スタック（全面改訂）

- **Rolldown（Vite 8、Rust ベースバンドラ）** をコアスタックに追加
- **TailwindCSS** 統合を `@nuxtjs/tailwindcss` → `@tailwindcss/vite` プラグインに変更（バージョン独立）
- **Mise** を Node.js / pnpm バージョン管理ツールとして追加
- **Linter**: ESLint 単独 → ESLint + Oxlint（Rust ベース高速 linter）に変更
- **Formatter**: Prettier → Oxfmt に変更
- **「Nuxt 設定方針」セクション追加**（`nuxt.config.ts` のベースライン設定例を掲載）
  - `compatibilityVersion: 4`（Nuxt 4 互換）
  - `typedPages: true`、`optionsAPI: false`
  - `compressPublicAssets: true`、`drop_console: true`
  - `propsDestructure: true`、`defineModel: true`
- **auto-imports 無効化方針**セクション追加（明示的 import を採用）
- Links セクション修正（死リンク削除、Zenn 参照を追記）

#### `adr/` — ADR 関連

- **ADR-005（認証アーキテクチャ）** を大幅改訂
  - 旧: Keycloak を一次 IdP とする方針
  - 新: **組み込みメール+パスワードが一次手段（Ph1・デフォルト）**、Keycloak は外部オプション連携（Ph2）
  - 認証モード対応表・機能分担表を追加
  - アプリは Keycloak をバンドルせず、env 変数で外部 Keycloak へ接続する構成を明記

---

## Links

- [[feature_scope]] - 機能スコープ一覧
- [[tech_stack]] - 技術スタック
