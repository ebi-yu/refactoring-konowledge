# 技術スタック

## 採用スタック

### フルスタック: Nuxt 4

記事投稿サイトとしてSSR・型共有・開発効率を重視し、Nuxt 4 フルスタック構成を採用。

```md
my-knowledge/
├── app/                    # Nuxt 4 フロントエンド
│   ├── pages/
│   ├── components/
│   ├── layouts/
│   ├── composables/
│   └── middleware/
├── server/                 # Nitro (H3) バックエンド
│   ├── api/                # APIエンドポイント
│   ├── middleware/
│   └── utils/
├── shared/                 # フロント・バック共有
│   └── types/              # 型定義 (自動で両側に公開)
├── public/
└── nuxt.config.ts
```

### 選定理由

| 観点 | 理由 |
|------|------|
| 型共有 | `shared/` ディレクトリがフロント・サーバー両方で自動利用可能 |
| SEO | 記事ページのSSRがビルトイン |
| 開発効率 | 単一リポジトリで完結、設定コスト最小 |
| TypeScript | デフォルトで strict、全体で型安全 |

---

## 技術スタック詳細

### コア

| 役割 | 技術 | バージョン |
|------|------|-----------|
| フレームワーク | **Nuxt 4** | 4.x |
| ランタイム | **Node.js** | 22 LTS (Mise で管理) |
| 言語 | **TypeScript** | 5.x |
| サーバー | **Nitro v2** (H3) | Nuxt 4 同梱 |
| バンドラー | **Rolldown** (Vite 8) | Rustベース、esbuild/rollup を置き換え |

### フロントエンド

| 役割 | 技術 |
|------|------|
| UIフレームワーク | Vue 3 (Composition API) | Options APIは無効化（バンドルサイズ削減） |
| スタイリング | TailwindCSS v4 (`@tailwindcss/vite`) | `@nuxtjs/tailwindcss` ではなく Viteプラグインを直接使用（Nuxtモジュールのバージョン依存を排除） |
| 状態管理 | Pinia | |
| Markdownレンダリング | markdown-it / Shiki (シンタックスハイライト) | |
| ダイアグラム | Mermaid.js | |
| 数式 | KaTeX (MathJaxより軽量) | |
| アイコン | unplugin-icons + Iconify | |

### バックエンド (Nitro / H3)

| 役割 | 技術 |
|------|------|
| APIルーティング | Nitro server routes (`server/api/`) |
| ORM | **Prisma** (型安全・情報量豊富) |
| バリデーション | **Zod** (スキーマ共有でフロントと型連携) |
| 認証 | **nuxt-auth-utils** or better-auth |
| ファイルアップロード | unjs/unenv + ローカルストレージ or S3互換 |
| メール送信 | Resend or nodemailer |
| 全文検索 | **Meilisearch** (Luceneから移行、セルフホスト可) |

### データベース

| 役割 | 技術 |
|------|------|
| DB | **PostgreSQL 16** |
| マイグレーション | Prisma Migrate |
| 開発用 | Docker Compose |

### インフラ・開発環境

| 役割 | 技術 | 備考 |
|------|------|------|
| コンテナ | Docker / Docker Compose | |
| パッケージマネージャ | pnpm | |
| ランタイムバージョン管理 | **Mise** (mise-en-place) | Node.js・pnpmのバージョンを `.mise.toml` で固定 |
| Linter | ESLint + @nuxt/eslint + **Oxlint** | Oxlint (Rustベース) でルール高速チェック、eslint-plugin-oxlint で重複排除 |
| フォーマッター | **Oxfmt** | Rustベースで高速。`experimentalSortImports: true` でimport整列 |
| テスト | Vitest (unit) + Playwright (e2e) | |

---

## 旧スタックとの対応

| 旧 (Java) | 新 (Nuxt 4) |
|-----------|-------------|
| カスタムDIフレームワーク | Nuxt composables / auto-imports |
| カスタムORM (XML) | Prisma (TypeScript) |
| Lucene全文検索 | Meilisearch |
| JSP テンプレート | Vue SFC |
| Servlet Filter (認証) | Nitro middleware |
| Gulp + Bower | Rolldown / Vite 8 (Nuxt 4内蔵) |
| Tomcat WAR | Node.js サーバー |

---

## Nuxt設定方針

参考記事（[Nuxt4 + Vue3.6のセットアップ](https://zenn.dev/ytr0903/articles/9c9cb812a06110)）を踏まえ、以下の設定を標準とする。

### nuxt.config.ts の主要設定

```typescript
export default defineNuxtConfig({
  future: { compatibilityVersion: 4 },

  experimental: {
    typedPages: true,          // 型安全なルーティング
  },

  nitro: {
    compressPublicAssets: true, // gzip/brotli圧縮
  },

  vue: {
    propsDestructure: true,
    defineModel: true,
    features: {
      optionsAPI: false,        // Options APIを無効化（バンドルサイズ削減）
    },
  },

  vite: {
    build: {
      terserOptions: {
        compress: {
          drop_console: true,   // 本番でconsole.log除去
        },
      },
    },
  },

  runtimeConfig: {
    // サーバーサイドのみの秘密情報（DB接続情報など）
    databaseUrl: '',
    // PUBLIC_ プレフィックスはクライアントに公開される
    public: {
      appUrl: '',
    },
  },
})
```

### 自動インポートの方針

Nuxt のコンポーネント・composables の自動インポートは**無効化**し、明示的 `import` を採用する。

| 理由 | 詳細 |
|------|------|
| IDE補完の確実性 | 自動インポートはエディタによっては補完が不安定になる |
| コードの可読性 | どのファイルからインポートしているかが明示されて追いやすい |
| 名前衝突の防止 | グローバルに展開されると同名の関数で予期しない上書きが起きうる |

---

## 型共有イメージ

```typescript
// prisma/schema.prisma → Prisma が型を自動生成
model Article {
  id         Int      @id @default(autoincrement())
  title      String
  content    String
  visibility Visibility
  tags       Tag[]
}

// shared/types/article.ts → Zod でバリデーション定義
import { z } from 'zod'

export const ArticleSchema = z.object({
  title: z.string().min(1).max(200),
  content: z.string(),
  visibility: z.enum(['public', 'login_only', 'private']),
  tags: z.array(z.string()),
})

export type ArticleInput = z.infer<typeof ArticleSchema>
// Prisma型 → DB層、Zod型 → API入力バリデーション・フロント共有
```

---

## 決定済み事項（ADR参照）

| 決定 | 結論 | ADR |
|------|------|-----|
| フルスタックフレームワーク | Nuxt 4 | [[ADR-001_framework]] |
| DB + ORM | PostgreSQL 16 + Prisma | [[ADR-002_database]] |
| 全文検索 | Meilisearch | [[ADR-002_search]] |
| 認証ライブラリ | better-auth | [[ADR-005_auth]] |
| ファイルストレージ | ローカルFS（開発）/ MinIO S3互換（本番） | [[ADR-006_file_storage]] |
| サーバーランタイム | Node.js 22 LTS | [[ADR-007_runtime]] |

---

## Links

- [[01_architecture]] - 現状システム解析（移行元）
- [[ADR-001_framework]] - Nuxt 4 採用の判断根拠
- [[ADR-002_database]] - PostgreSQL + Prisma 採用の判断根拠
- [[ADR-002_search]] - Meilisearch 採用の判断根拠
- [参考: Nuxt4 + Vue3.6のセットアップ](https://zenn.dev/ytr0903/articles/9c9cb812a06110)
