## 概要

GET /api/notifications エンドポイントの実装（未読件数・一覧・既読化対応）。

## 親 Story

- Story: (US-1) コメントをサイト内通知で受け取りたい

## 作業内容

- [ ] `GET /api/notifications` — ログインユーザーの通知一覧取得（ページネーション対応）
- [ ] `GET /api/notifications/unread-count` — 未読件数取得
- [ ] `PUT /api/notifications/:id/read` — 個別既読化
- [ ] `PUT /api/notifications/read-all` — 全既読化
- [ ] 認証ミドルウェアによるアクセス制御

## 技術メモ

- 通知一覧はログインユーザーの `user_id` に紐づくレコードのみ返す
- `is_read = false` の件数をバッジ表示に使用する
- 既読化はPUTで冪等に処理する

## 完了の定義（DoD）

- [ ] コードが実装されている
- [ ] ユニットテストが書かれ、CI が通過している
- [ ] セルフレビュー済み（lint / format エラーなし）
- [ ] 親 Story の担当者にレビュー依頼済み

## 見積もり

| 項目         | 値  |
| ------------ | --- |
| 見積もり時間 | h   |
| 実績時間     | h   |

## 参照

- Story: (US-1) コメントをサイト内通知で受け取りたい
