## 概要

` ```mermaid ` コードブロックを Mermaid.js で SVG に変換して表示する処理の実装。

## 親 Story

- Story: (US-2) mermaid形式で図を書きたい

## 作業内容

- [ ] Markdown パーサーのカスタムレンダラーで ` ```mermaid ` ブロックを検出する
- [ ] 検出した mermaid コードを `mermaid.render()` で SVG に変換する処理を実装する
- [ ] エディタプレビューペインにリアルタイムで SVG を反映する
- [ ] 無効な mermaid 記法の場合にエラーメッセージを表示してクラッシュしないようにする

## 技術メモ

- `mermaid.render(id, code)` は非同期処理のため Promise チェーンで処理する
- SSR 時は mermaid をスキップし、クライアントサイドで `onMounted` 後に描画する

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

- Story: (US-2) mermaid形式で図を書きたい
