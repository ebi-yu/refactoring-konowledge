# Panda CSS とは

## なぜこれを知る必要があるか

> このプロジェクトのスタイリングは Panda CSS を中心に構成されている。「なぜこの書き方をするのか」「なぜ CSS ファイルが自動生成されるのか」を理解しないまま使うと、スタイルが当たらないなどのトラブルに対処できない。

---

## 一言で言うと

> **「TypeScript でスタイルを書いて、ビルド時に静的 CSS を出力する」ゼロランタイムの CSS-in-JS ライブラリ。**

---

## 全体像

- 開発者が `css()` / `cva()` / `sva()` で TypeScript としてスタイルを記述する
- ビルド時に Panda CSS がソースを静的解析し、使われたスタイルだけを CSS に変換する
- `styled-system/styles.css` として出力され、ブラウザがそのまま読み込む
- **ランタイムに JS がスタイルを計算することは一切ない。** CSS ファイルは事前に用意されている。

---

## 詳細

### なぜ作られたか：ランタイム CSS-in-JS の限界

React Server Components が登場し、「サーバーで HTML を生成、クライアントに JS を送らない」という設計が主流になった。

従来の CSS-in-JS（Emotion, styled-components など）は **ブラウザ上で JS を実行してスタイルを生成する** 設計のため、RSC と根本的に相性が悪い。Panda CSS はこの問題を「ビルド時に全部やる」で解決した。

```
従来の CSS-in-JS
  サーバー: HTML 生成 → クライアント: JS 実行 → スタイル生成 → 画面表示
  （JS バンドルサイズが増える・SSR と相性が悪い）

Panda CSS
  ビルド時: CSS 生成 → サーバー: HTML + CSS 配信 → 画面表示
  （ブラウザで JS は実行されない）
```

### スタイルの書き方：3 つの関数

**`css()`** — 単発のスタイル定義

```ts
import { css } from "styled-system/css";

const className = css({ display: "flex", color: "neutral.11" });
// → "d_flex c_neutral.11" のようなクラス名文字列を返す
```

**`cva()`** — バリアント付きコンポーネント（1 つの要素）

```ts
import { cva } from "styled-system/css";

const button = cva({
  base: { display: "inline-flex" },
  variants: {
    variant: {
      solid: { bg: "neutral.9", color: "white" },
      outline: { borderWidth: "1px" },
    },
  },
});

button({ variant: "solid" }); // → クラス名文字列
```

**`sva()`** — バリアント付きコンポーネント（複数要素 = スロット）

```ts
import { sva } from "styled-system/css";

const card = sva({
  slots: ["root", "header", "body"],
  base: {
    root:   { borderRadius: "md" },
    header: { fontWeight: "bold" },
  },
  variants: { ... },
});

const classes = card({ size: "lg" });
classes.root;   // → ルート要素のクラス名
classes.header; // → ヘッダー要素のクラス名
```

| 関数    | 用途                                           |
| ------- | ---------------------------------------------- |
| `css()` | 単発・動的なスタイル                           |
| `cva()` | 単一要素のコンポーネント（ボタンなど）         |
| `sva()` | 複数要素にまたがるコンポーネント（カードなど） |

### CSS Cascade Layers

生成される `styles.css` は CSS の `@layer` を使って優先度を明示的に管理している。

```css
@layer reset, base, tokens, recipes, utilities;
```

| レイヤー    | 内容                                                     |
| ----------- | -------------------------------------------------------- |
| `reset`     | ブラウザのデフォルトスタイルをリセット                   |
| `base`      | グローバルベーススタイル                                 |
| `tokens`    | デザイントークン（`--colors-neutral-9` などの CSS 変数） |
| `recipes`   | `cva`/`sva` で定義したコンポーネントスタイル             |
| `utilities` | `css()` 等から生成されたユーティリティクラス             |

後ろに書かれたレイヤーほど優先度が高い。`utilities` が最強。

### デザイントークン

色・サイズ・余白などの値を CSS 変数として一元管理する仕組み。

```ts
// panda.config.ts で定義（または Park UI プリセットから継承）
tokens: {
  colors: {
    neutral: { 9: { value: "#8d8d8d" } }
  }
}
```

↓ `styles.css` の `@layer tokens` に出力

```css
:root {
  --colors-neutral-9: #8d8d8d;
}
```

↓ `css({ bg: "neutral.9" })` と書くと

```css
.bg_neutral\.9 {
  background: var(--colors-neutral-9);
}
```

トークン名を変えれば全体のデザインが一括で変わる。

---

## このプロジェクトでの構成

```
panda.config.ts
  ├─ presets: Park UI プリセット（デザイントークン + コンポーネントスタイル）
  ├─ include: ["./app/**/*.{ts,tsx,vue}"]  ← スキャン対象
  └─ outdir: "styled-system"              ← 出力先

styled-system/
  ├─ styles.css   ← Nuxt が読み込む CSS（これが本体）
  ├─ css/         ← css(), cva(), sva() などの関数
  └─ types/       ← TypeScript 型定義
```

詳細なコマンドの動作は [panda-css-commands.md](./panda-css-commands.md) を参照。

---

## よくある誤解・トラブル

| 状況                                                       | 正しい理解                                                 |
| ---------------------------------------------------------- | ---------------------------------------------------------- |
| ブラウザの DevTools でスタイルの JS 処理が見えない         | 正常。Panda は JS でスタイルを操作しない                   |
| トークン名（`neutral.9` など）を間違えても型エラーが出ない | `styled-system/types` から import すると型チェックが効く   |
| 新しいクラスを追加したのに CSS に出ない                    | `panda watch` が起動していないか、スキャン対象外のファイル |
| `styled-system/` 配下を手で編集した                        | 自動生成ファイルなので再生成で上書きされる。編集禁止       |
