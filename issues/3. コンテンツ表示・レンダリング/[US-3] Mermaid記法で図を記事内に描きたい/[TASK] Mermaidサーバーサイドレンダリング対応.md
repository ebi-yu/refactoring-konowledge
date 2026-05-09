## 概要

SSR 環境で Mermaid.js が正しく動作するよう設定（クライアントサイドのみのフォールバック対応）。

## 親 STORY

- STORY: [US-3] Mermaid記法で図を記事内に描きたい

## 作業内容

- [ ] SSR（Nuxt.js / Next.js 等）環境で Mermaid.js が `window` を参照してエラーになる問題を解消する
- [ ] `process.client`（Nuxt）または `typeof window !== 'undefined'` チェックで SSR 時はスキップする
- [ ] クライアントサイドの `onMounted` フック後に Mermaid.js を動的インポートして描画する
- [ ] SSR 時は mermaid コードブロックをプレースホルダー表示してクライアントで置換する

## 技術メモ

- `import('mermaid').then(m => m.default.run())` のパターンで動的インポートを使用する
- Nuxt の場合 `<ClientOnly>` ラッパーコンポーネントを活用する

## 完了の定義（DoD）

- [ ] コードが実装されている
- [ ] ユニットテストが書かれ、CI が通過している
- [ ] セルフレビュー済み（lint / format エラーなし）
- [ ] 親 STORY の担当者にレビュー依頼済み

## 見積もり

| 項目         | 値  |
| ------------ | --- |
| 見積もり時間 | h   |
| 実績時間     | h   |

## 参照

- STORY: [US-3] Mermaid記法で図を記事内に描きたい
