## 概要

POST/GET/PUT/DELETE /api/threads エンドポイントの実装。

## 親 Story

- Story: (US-1) スレッドを作成したい

## 作業内容

- [ ] `threads` テーブルのDBスキーマ定義（id, user_id, title, is_public, created_at, updated_at）
- [ ] `POST /api/threads` — スレッド作成
- [ ] `GET /api/threads` — 公開スレッド一覧取得（自分の非公開スレッドも含む）
- [ ] `GET /api/threads/:id` — スレッド詳細取得
- [ ] `PUT /api/threads/:id` — スレッド更新（作成者のみ）
- [ ] `DELETE /api/threads/:id` — スレッド削除（作成者のみ）

## 技術メモ

- 一覧取得は `is_public = true OR user_id = {currentUserId}` の条件でフィルターする
- 削除は関連するスレッド投稿も CASCADE で削除する
- スレッドとユーザーのN+1問題を避けるためJOINでユーザー情報も取得する

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

- Story: (US-1) スレッドを作成したい
