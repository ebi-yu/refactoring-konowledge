## 概要

marked.js / remark 等の Markdown パーサーライブラリを組み込みサニタイズ設定を行う。

## 親 STORY

- STORY: [US-1] Markdown記法が正しく表示された記事を読みたい

## 作業内容

- [ ] Markdown パーサーライブラリ（marked.js または remark）を選定・導入する
- [ ] DOMPurify または sanitize-html で HTML サニタイズを設定する
- [ ] 許可する HTML タグ・属性のホワイトリストを設定する（`<script>` 等は除外）
- [ ] パーサー設定（GFM 有効・テーブル対応等）を構成する
- [ ] XSS 攻撃パターンのテストケースを書いてサニタイズが機能することを確認する

## 技術メモ

- `marked.js` を使用する場合は `DOMPurify.sanitize(marked.parse(input))` のパターンで XSS を防ぐ
- `remark` + `rehype-sanitize` のプラグインチェーンも有効な選択肢

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

- STORY: [US-1] Markdown記法が正しく表示された記事を読みたい
