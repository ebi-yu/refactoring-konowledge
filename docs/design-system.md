# デザインシステム方針

> このプロジェクトのUIデザインに関する方針・ツール・開発フローをまとめる。

---

## 基本方針：コードファースト

**コードが唯一の真実（Source of Truth）**。Figma や外部ツールで管理するのではなく、`panda.config.ts` のデザイントークンとコンポーネントコードそのものがデザインシステムの実体。

| 優先事項       | 理由                                             |
| -------------- | ------------------------------------------------ |
| 実装速度       | デザイン先行で時間を使わず、動くものを早く作る   |
| コードとの同期 | デザインファイルが実装とズレる問題を根本から排除 |
| 保守性         | コンポーネントを変更したら即座に反映される       |

---

## ツールスタック

### Ark UI + Panda CSS（Park UI）

**Park UI** = `@ark-ui/vue`（ヘッドレスUIコンポーネント）+ `@park-ui/panda-preset`（Panda CSSプリセット）の組み合わせ。

```txt
Ark UI  ... アクセシビリティ・動作（ロジック）を担当
Panda CSS ... スタイリング・デザイントークンを担当
Park UI ... この2つを統合したプリセット+コンポーネント集
```

**使い分け：**

| ケース                               | 使うもの                              |
| ------------------------------------ | ------------------------------------- |
| ボタン・モーダル・フォーム等の標準UI | Park UI コンポーネント（CLIでコピー） |
| Park UI で補えないカスタムUI         | Panda CSS で直接実装                  |
| Park UI のスタイル変更               | コピー済みファイルを直接編集          |

```bash
# Park UI コンポーネントの追加
npx @park-ui/cli components add <component>
# → app/components/ui/ にコピーされる（自由に編集可）
```

---

## デザイントークン

### 定義場所

`panda.config.ts` がトークンの唯一の定義場所。

```ts
// panda.config.ts
export default defineConfig({
  presets: [
    "@pandacss/dev/presets",
    createPreset({
      accentColor: neutral, // ← アクセントカラー
      grayColor: slate, // ← グレースケール
      radius: "sm", // ← 角丸の基準
    }),
  ],
  theme: {
    extend: {
      tokens: {
        // カスタムトークンはここに追加
        colors: {},
        fontSizes: {},
        spacing: {},
      },
      semanticTokens: {
        // 意味的トークン（ダークモード対応など）
        colors: {
          bg: {
            default: { value: { base: "{colors.white}", _dark: "{colors.gray.900}" } },
          },
        },
      },
    },
  },
});
```

### トークン設計指針

1. **Park UI プリセットをベースに使う** — `neutral`（アクセント）/ `slate`（グレー）が基本パレット
2. **カスタムトークンは必要になってから追加** — 先に全部定義しない（YAGNI）
3. **Semantic Token を使う** — ダークモード対応は `semanticTokens` で `base`/`_dark` を定義

---

## コンポーネント実装方針

### SVA でスタイルを定義

CSSは Panda CSS の `sva`（Slot Variants API）を使い、スロットごとにスタイルを定義してコンポーネントに閉じ込める。

```ts
const styles = sva({
  slots: ["root", "title", "body"],
  base: {
    root: { p: "4", rounded: "md" },
    title: { fontSize: "xl", fontWeight: "bold" },
  },
  variants: {
    variant: {
      subtle: { root: { bg: "bg.subtle" } },
      outline: { root: { borderWidth: "1px" } },
    },
  },
});
```

### コンポーネント分類

```txt
app/components/
├── ui/          ... Park UI から追加したコンポーネント（自由に編集可）
├── common/      ... プロジェクト共通カスタムコンポーネント
├── knowledge/   ... ナレッジ機能固有コンポーネント
└── sample/      ... 開発・確認用（本番では非表示）
```

---

## モックデザイン（.pen）の使い方

### 使う場面 / 使わない場面

| 場面                                     | .pen モック                          |
| ---------------------------------------- | ------------------------------------ |
| **新しいページ全体のレイアウト**         | ✅ 作る — 配置・情報構造の合意に有効 |
| **複雑なUIパターン**（ダッシュボード等） | ✅ 作る                              |
| 既存 Park UI コンポーネントを使うだけ    | ⏭ スキップ可 — コードを見れば十分   |
| 軽微なスタイル調整                       | ⏭ スキップ可                        |

### 方針

- **.pen はページレベルの合意ツール**。コンポーネント単体のモックは不要。
- 実装後に乖離するなら .pen を維持するコストは不要。**実装が完成したら .pen は参考資料として保持するだけ**。
- 「大体こう並ぶ」が伝わる粒度で十分。ピクセルパーフェクトは求めない。

---

## コンポーネントカタログ（Storybook 非採用）

### Storybook を採用しない理由

| 観点         | 理由                                                          |
| ------------ | ------------------------------------------------------------- |
| 管理コスト   | Story ファイルが実装と常に同期が必要                          |
| 代替手段あり | `browser-use` で実際の画面を確認できる                        |
| 規模感       | 現時点でコンポーネント数が Storybook を必要とするほど多くない |

### 代替：アプリ内カタログページ

開発環境のみ表示される `/dev/components` ページでコンポーネントを一覧表示する。

```
app/pages/dev/
└── components.vue   ... 開発用コンポーネントカタログ（本番ビルドでは除外）
```

```vue
<!-- app/pages/dev/components.vue -->
<script setup lang="ts">
definePageMeta({ ssr: false });
</script>

<template>
  <!-- コンポーネントを並べるだけ。Storybook のような設定不要 -->
  <section>
    <Button variant="solid">Primary</Button>
    <Button variant="outline">Secondary</Button>
  </section>
</template>
```

**確認方法：** `browser-use` で `http://localhost:3000/dev/components` を開いて視覚確認。

---

## 実装フロー

詳細は `docs/implementation-flow.md` を参照。

実装は **エピック単位で計画し、タスク単位で実行する**。  
エピック開始時（Phase 0）に `.pen` でエピック全体のUIをモックし、デザイントークンを確認・調整してから実装に入る。

```
❌ やらない：デザインシステム全部定義してから実装
❌ やらない：タスクのたびに毎回デザインを一から決める（統一が崩れる）
✅ やる：エピック開始時に全体UIをモックで俯瞰 → タスク単位で実装
```

---

## 参考

- [Panda CSS ドキュメント](https://panda-css.com)
- [Park UI ドキュメント](https://park-ui.com)
- [Ark UI ドキュメント](https://ark-ui.com)
- `docs/knowledge/panda-css-overview.md` — プロジェクト内 Panda CSS 知識
- `DEVELOPER.md` — フロントエンド実装方針
