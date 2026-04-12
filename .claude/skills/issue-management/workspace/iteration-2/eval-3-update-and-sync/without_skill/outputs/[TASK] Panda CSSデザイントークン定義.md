## 概要

`panda.config.ts` にデザイントークンと semantic token を定義する。カラー・タイポグラフィ・スペーシング・シャドウ・ボーダー半径を網羅し、ダークモード対応の semantic token も揃える。

## 親 STORY

- STORY: (US-1) デザイントークンを設定したい

## 作業内容

### カラートークン (`theme.tokens.colors`)

- [x] ブランドカラー: `brand.50`〜`brand.900`（primary アクション用）
- [ ] グレースケール: `gray.50`〜`gray.900`
- [ ] ステータスカラー: `success`, `warning`, `error`, `info`（各 `DEFAULT` + `subtle`）

### Semantic Token (`theme.semanticTokens`)

- [ ] `colors.bg.canvas` — ページ背景（ライト: gray.50 / ダーク: gray.950）
- [ ] `colors.bg.surface` — カード・パネル背景（ライト: white / ダーク: gray.900）
- [ ] `colors.text.primary` — 主テキスト
- [ ] `colors.text.muted` — 補助テキスト
- [ ] `colors.border.subtle` — ボーダー
- [ ] `colors.accent` — アクションカラー

### タイポグラフィ (`theme.tokens.fonts`)

- [ ] `sans`: システムフォントスタック（UI テキスト用）
- [ ] `mono`: コードブロック用モノスペースフォント

### スペーシング

- [ ] Panda CSS デフォルトスケール（4px 基点）を確認し、必要なカスタム値のみ追加

### その他

- [ ] `theme.tokens.radii`: `sm`, `md`, `lg`, `full`
- [ ] `theme.tokens.shadows`: `sm`, `md`（カード用）

## 技術メモ

- Panda CSS の設定ファイルは `panda.config.ts`
- semantic token は `{ value: { base: "...", _dark: "..." } }` 形式で定義
- `_dark` はデフォルトの `darkMode: "class"` に対応（OS設定を Nuxt 側でクラス付与）

## 完了の定義（DoD）

- [ ] コードが実装されている
- [ ] `bun run build` でビルドが通る
- [ ] セルフレビュー済み（lint / format エラーなし）

## 見積もり

| 項目         | 値  |
| ------------ | --- |
| 見積もり時間 | h   |
| 実績時間     | h   |

## 参照

- STORY: (US-1) デザイントークンを設定したい
- Panda CSS Tokens: https://panda-css.com/docs/theming/tokens
- Panda CSS Semantic Tokens: https://panda-css.com/docs/theming/semantic-tokens
