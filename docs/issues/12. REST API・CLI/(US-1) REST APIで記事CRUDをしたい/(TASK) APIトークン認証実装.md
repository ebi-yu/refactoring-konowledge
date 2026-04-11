## 概要

APIトークン発行・検証・失効処理の実装。

## 親 Story

- Story: (US-1) REST APIで記事CRUDをしたい

## 作業内容

- [ ] `api_tokens` テーブルのDBスキーマ定義（user_id, token_hash, name, expires_at, revoked_at）
- [ ] `POST /api/v1/auth/tokens` — APIトークン発行エンドポイント
- [ ] `DELETE /api/v1/auth/tokens/:id` — APIトークン失効エンドポイント
- [ ] APIリクエスト時のBearerトークン検証ミドルウェアの実装
- [ ] トークンの有効期限・失効チェック処理

## 技術メモ

- トークンはランダムな256bitの値をSHA-256ハッシュしてDBに保存する（平文は発行時のみ表示）
- 有効期限はデフォルト1年、カスタム設定可能にする
- 検証はDBルックアップのみで行いJWTと混在させない

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

- Story: (US-1) REST APIで記事CRUDをしたい
