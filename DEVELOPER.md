# Developer Guide

詳細は `docs/` 以下を参照。

- `docs/architecture.md` — レイヤー設計・ディレクトリ構造
- `docs/tech_stack.md` — 技術スタック
- `docs/issues/` — Epic / Story / Task

---

## デザイン

- デザインには pencil を使用する
- `pen`形式でデザインを管理する

## フロントエンド

Vue ファイルは現在 Vapor Mode を使用しない。Vue 3.6 beta において、Vapor コンポーネントから VDOM コンポーネント（`@ark-ui/vue` 等）を使う場合に SSR hydration でクラッシュする既知の問題があるため一時保留。

Vapor Mode 対応は[別途 Issue](./docs//issues/21.%20技術的TODO/[US-1]%20Vapor%20Mode%20対応/story.md) で管理する。

### UIコンポーネント：Park UI + Panda CSS

| 用途                                                 | ツール                                            |
| ---------------------------------------------------- | ------------------------------------------------- |
| 既成UIコンポーネント（ボタン・モーダル・フォーム等） | Park UI (`@ark-ui/vue` + `@park-ui/panda-preset`) |
| カスタムUIのスタイリング・design tokens              | Panda CSS                                         |

**Park UI の使い方：** `npx @park-ui/cli components add <component>` でコンポーネントを `app/components/ui/` にコピーして使う。コピーしたファイルは自由に編集してよい。

**使い分け：** Park UI で補えないカスタムUIは Panda CSS で書く。Park UI コンポーネントのスタイル変更はコピー済みファイルを直接編集する。

**Panda CSS セットアップ**

`bun run dev` で `panda watch` が同時起動し、`styled-system/` を自動生成する。import は必ず `styled-system/` から行う。

```ts
import { css, cva, sva } from "../styled-system/css";
```

CSSはPanda CSSを使用すること。Panda CSSにおいてsva（Slot Variants API）を使用して、コンポーネントのスタイルをスロットごとに定義し、スタイルをコンポーネントに閉じ込めることが推奨される。

```ts
// Slot Recipe でスロットごとのスタイルを定義
const modalStyles = sva({
  slots: ["header", "body", "footer"],
  base: {
    header: { fontSize: "xl", fontWeight: "semibold", color: "text.primary" },
    body: { fontSize: "sm", color: "text.muted" },
    footer: { display: "flex", justifyContent: "flex-end", gap: "sm" },
  },
})

// スタイルをコンポーネントに閉じ込める
const classes = modalStyles()

export const ModalHeader = ({ children }) => (
  <h1 className={classes.header}>{children}</h1>
)
export const ModalBody = ({ children }) => (
  <div className={classes.body}>{children}</div>
)
export const ModalFooter = ({ children }) => (
  <div className={classes.footer}>{children}</div>
)
```

```vue
<script setup lang="ts" vapor>
import { css } from "../styled-system/css";
const modalClasses = modalStyles();
// Vapor Mode でのスクリプト
</script>

<template>
  <ModalHeader>>Hello 🐼!</ModalHeader>
</template>
```

## バックエンド

```md
Presentation → Application → Domain ← Infrastructure
```

`server/domain/` はフレームワーク・DB に依存しない。
`shared/schemas/` の Zod スキーマが型の唯一の真実。

詳細 → `docs/architecture.md`

- TDD（Red → Green → Refactor）に従って実装すること

## Issue 管理

```bash
bash .claude/hooks/update-issues.sh docs/issues/<epic>/<story>/story.md
bash .claude/hooks/update-issues.sh "docs/issues/<epic>/<story>/[TASK] xxx.md"
DRY_RUN=true bash .claude/hooks/update-issues.sh  # ドライラン
```
