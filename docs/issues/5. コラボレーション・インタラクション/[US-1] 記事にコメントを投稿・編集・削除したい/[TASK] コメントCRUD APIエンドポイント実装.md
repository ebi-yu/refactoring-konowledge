## 概要

POST/PUT/DELETE /api/articles/:id/comments エンドポイントの実装（権限チェック含む）。

## 親 STORY

- STORY: [US-1] 記事にコメントを投稿・編集・削除したい

## 作業内容

- [ ] `POST /api/articles/:id/comments` でコメント投稿エンドポイントを実装する
- [ ] `PUT /api/articles/:id/comments/:commentId` でコメント編集エンドポイントを実装する（自分のコメントのみ）
- [ ] `DELETE /api/articles/:id/comments/:commentId` でコメント削除エンドポイントを実装する（自分のコメントのみ・管理者は全削除可）
- [ ] `GET /api/articles/:id/comments` でコメント一覧取得エンドポイントを実装する
- [ ] コメント本文のバリデーション（空文字不可・最大文字数）を実装する

## 技術メモ

- コメント本文は Markdown をサポートする（保存は生テキスト、表示時にレンダリング）
- コメント削除は物理削除ではなく `deleted_at` のソフトデリートを検討する

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

- STORY: [US-1] 記事にコメントを投稿・編集・削除したい
