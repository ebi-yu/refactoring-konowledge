## 概要

YouTube や SpeakerDeck 等の外部 URL を自動的に iframe に変換する Markdown プラグインの実装。

## 親 STORY

- STORY: (US-6) 外部コンテンツをiframeで埋め込みたい

## 作業内容

- [ ] Markdown パーサーのカスタムレンダラーで URL のみの行を検出する
- [ ] ホワイトリストに一致するドメインの URL を対応する iframe 埋め込みコードに変換する
- [ ] YouTube・SpeakerDeck・SlideShare・Figma の URL パターンと iframe 変換ロジックを実装する
- [ ] 埋め込み iframe に `sandbox` 属性を適切に設定してセキュリティを確保する
- [ ] アスペクト比を維持したレスポンシブ iframe レイアウトを実装する

## 技術メモ

- YouTube URL は `youtu.be/` と `youtube.com/watch?v=` の両形式に対応する
- `sandbox="allow-scripts allow-same-origin allow-presentation"` を基本とする

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

- STORY: (US-6) 外部コンテンツをiframeで埋め込みたい
