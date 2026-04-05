## 概要

` ```mermaid ` ブロックを Mermaid.js で SVG に変換する Markdown 拡張の実装。

## 親 Story

- Story: (US-3) Mermaid記法で図を記事内に描きたい

## 作業内容

- [ ] Markdown レンダラーのカスタムコードブロックレンダラーで `language === 'mermaid'` を検出する
- [ ] `mermaid.render()` を呼び出して SVG を生成する処理を実装する
- [ ] 生成した SVG を記事詳細ページのコンテンツエリアに表示する
- [ ] try/catch でエラーをキャッチし、エラーメッセージを表示してクラッシュを防ぐ

## 技術メモ

- `mermaid.render(id, code)` は一意の ID を必要とするため `crypto.randomUUID()` 等を使用する
- XSS 対策として SVG を直接 `v-html` で挿入する際はサニタイズを確認する

## 完了の定義（DoD）

- [ ] コードが実装されている
- [ ] ユニットテストが書かれ、CI が通過している
- [ ] セルフレビュー済み（lint / format エラーなし）
- [ ] 親 Story の担当者にレビュー依頼済み

## 見積もり

| 項目 | 値 |
|------|----|
| 見積もり時間 | h |
| 実績時間 | h |

## 参照

- Story: (US-3) Mermaid記法で図を記事内に描きたい
