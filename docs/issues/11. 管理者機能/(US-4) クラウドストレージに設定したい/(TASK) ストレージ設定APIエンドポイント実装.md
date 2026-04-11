## 概要

管理者がS3/R2/MinIOの接続情報（endpoint, bucket, accessKey等）を設定・テストするAPIの実装。

## 親 Story

- Story: (US-4) クラウドストレージに設定したい

## 作業内容

- [ ] `storage_settings` テーブルのDBスキーマ定義（provider, endpoint, bucket, access_key, secret_key等）
- [ ] `PUT /api/admin/settings/storage` エンドポイントの実装（接続情報の保存）
- [ ] `POST /api/admin/settings/storage/test` エンドポイントの実装（接続テスト）
- [ ] シークレット情報の暗号化保存処理
- [ ] バリデーション（必須フィールドチェック・URL形式チェック）

## 技術メモ

- access_key・secret_keyは暗号化してDBに保存する（AES-256等）
- 接続テストは実際にバケットへのPUT/GETを試みてエラーを返す
- 設定変更後はストレージアダプターを再初期化する

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

- Story: (US-4) クラウドストレージに設定したい
