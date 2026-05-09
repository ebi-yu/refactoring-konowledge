# 初期環境構築 設計ドキュメント

**作成日:** 2026-04-05  
**対象リポジトリ:** refactoring-konowledge（リポジトリルートに直接セットアップ）  
**アプローチ:** C（レイヤード）

---

## 概要

tech_stack.md・architecture.md に基づき、Nuxt 4 フルスタックアプリケーションの初期環境をレイヤード方式で構築する。
各層を独立して検証可能にし、問題の切り分けを容易にする。

---

## 層構成

### 層 1: インフラ層

**Mise (.mise.toml)**

- Bun の最新安定版をバージョン固定

**Docker Compose (docker-compose.yml)**

- PostgreSQL 17（ポート 5432）
- Meilisearch 最新版（ポート 7700、MEILI_MASTER_KEY=masterkey）
- 両サービスとも named volume でデータ永続化

**環境変数**

- `.env.example` を作成（`.env` は `.gitignore` 対象）
- 含む変数: `DATABASE_URL`, `MEILI_HOST`, `MEILI_MASTER_KEY`, `NUXT_PUBLIC_APP_URL`

---

### 層 2: Nuxt 4 スキャフォールド

**プロジェクト生成**

- `bunx nuxi init` でリポジトリルートに生成

**nuxt.config.ts 設定**（tech_stack.md 準拠）

- `future: { compatibilityVersion: 4 }`
- `experimental: { typedPages: true }`
- `nitro: { compressPublicAssets: true }`
- `vue: { propsDestructure: true, defineModel: true, features: { optionsAPI: false } }`
- `vite.build.terserOptions.compress.drop_console: true`
- `runtimeConfig`: `databaseUrl`（サーバー）、`public.appUrl`（クライアント）
- **自動インポート無効化**: `imports: { autoImport: false }`, `components: { dirs: [] }`

**ディレクトリ構造**（architecture.md 準拠）

```
app/
  pages/
  components/
    common/
    knowledge/
  composables/
  layouts/
server/
  api/
    knowledge/
    auth/
    search/
  middleware/
  domain/
    knowledge/
    auth/
    search/
  infrastructure/
    prisma/
    meilisearch/
    storage/
shared/
  schemas/
  types/
prisma/
tests/
  unit/
  integration/
  e2e/
```

---

### 層 3: コード品質ツール

**Linter: Oxlint のみ**（ESLint は不採用）

- `oxlint` インストール
- `oxlintrc.json` で設定

**Formatter: Oxfmt**

- `oxfmt.toml` で Prettier 互換設定（Vue / CSS / Markdown 対応）
- import 整列をビルトイン活用

**Husky + lint-staged**

- `pre-commit` フックで lint-staged 実行
- lint-staged 対象:
  - `*.{ts,vue}` → oxlint
  - `*.{ts,vue,css,md}` → oxfmt

**TypeScript**

- `tsconfig.json` で `strict: true`
- 型チェッカー: `@typescript/native-preview`（tsgo）を使用（`tsc` の代わりに `npx tsgo`）

---

### 層 4: アプリ依存

| パッケージ                  | 用途                     | 初期作業                            |
| --------------------------- | ------------------------ | ----------------------------------- |
| `prisma` + `@prisma/client` | ORM                      | `prisma init`、provider: postgresql |
| `@pandacss/dev`             | ゼロランタイム CSS-in-JS | `panda.config.ts` 初期生成          |
| `zod`                       | バリデーション           | インストールのみ（実装は後続）      |
| `better-auth`               | 認証                     | インストールのみ（設定は認証 EPIC） |
| `meilisearch`               | 全文検索クライアント     | インストールのみ（実装は後続）      |
| `@pinia/nuxt`               | 状態管理                 | インストール・Nuxt モジュール登録   |

---

## 決定事項

| 項目           | 決定          | 理由                                          |
| -------------- | ------------- | --------------------------------------------- |
| Linter         | Oxlint のみ   | ESLint 不採用（ユーザー判断）                 |
| Formatter      | Oxfmt         | tech_stack.md 準拠（Prettier 互換・30x 高速） |
| DB             | PostgreSQL 17 | tech_stack.md 準拠                            |
| 検索           | Meilisearch   | Docker Compose に初期から含める               |
| 自動インポート | 無効          | IDE 補完の確実性・可読性・名前衝突防止        |

---

## スコープ外（後続タスク）

- Prisma スキーマ詳細定義（各 EPIC 実装時）
- better-auth 設定・OIDC 連携（認証 EPIC）
- Meilisearch インデックス定義（検索 EPIC）
- Panda CSS デザインシステム構築
- CI/CD パイプライン
