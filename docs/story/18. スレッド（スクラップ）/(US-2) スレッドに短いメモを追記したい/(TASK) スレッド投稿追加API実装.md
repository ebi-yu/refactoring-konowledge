## 概要

POST /api/threads/:id/posts エンドポイントの実装（投稿の追加・編集・削除）。

## 親 Story

- Story: (US-2) スレッドに短いメモを追記したい

## 作業内容

- [ ] `thread_posts` テーブルのDBスキーマ定義（id, thread_id, user_id, content, created_at, updated_at）
- [ ] `POST /api/threads/:id/posts` — 投稿追加
- [ ] `PUT /api/threads/:id/posts/:postId` — 投稿編集（作成者のみ）
- [ ] `DELETE /api/threads/:id/posts/:postId` — 投稿削除（作成者のみ）
- [ ] `GET /api/threads/:id/posts` — 投稿一覧取得（時系列昇順）

## 技術メモ

- スレッドが非公開の場合は投稿取得もオーナーのみアクセス可能にする
- 投稿の時系列順は `created_at` 昇順で固定する
- Markdownコンテンツはサーバー側でサニタイズしてXSSを防ぐ

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

- Story: (US-2) スレッドに短いメモを追記したい
