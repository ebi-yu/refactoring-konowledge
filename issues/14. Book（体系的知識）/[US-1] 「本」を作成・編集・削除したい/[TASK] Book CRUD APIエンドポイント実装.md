## 概要

POST/GET/PUT/DELETE /api/books エンドポイントの実装。

## 親 STORY

- STORY: [US-1] 「本」を作成・編集・削除したい

## 作業内容

- [ ] `books` テーブルのDBスキーマ定義（id, user_id, title, description, cover_image_url, visibility, created_at, updated_at）
- [ ] `POST /api/books` — 本の作成
- [ ] `GET /api/books` — 公開中の本一覧取得
- [ ] `GET /api/books/:id` — 本の詳細取得
- [ ] `PUT /api/books/:id` — 本の更新（作成者のみ）
- [ ] `DELETE /api/books/:id` — 本の削除（作成者のみ）

## 技術メモ

- 所有者チェックは認証ユーザーのIDと `books.user_id` を比較する
- cover_image_urlはアップロードAPIと連携して設定する
- 削除は関連するチャプターも CASCADE で削除する

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

- STORY: [US-1] 「本」を作成・編集・削除したい
