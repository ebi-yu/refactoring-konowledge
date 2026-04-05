## 概要

depends_on・healthcheckを使ったサービス起動順序制御の設定。

## 親 Story

- Story: (US-2) docker compose upで全サービスを起動したい

## 作業内容

- [ ] PostgreSQLのhealthcheck設定（pg_isready コマンド使用）
- [ ] MinIOのhealthcheck設定（HTTPヘルスチェックエンドポイント使用）
- [ ] アプリのdepends_onにPostgreSQL・MinIOのservice_healthy条件を設定
- [ ] 初回起動時のDBマイグレーション自動実行設定

## 技術メモ

- `depends_on` の `condition: service_healthy` でhealth状態を確認してから起動する
- healthcheckの `interval` / `timeout` / `retries` を適切に設定してタイムアウトを防ぐ
- DBマイグレーションはアプリ起動前にinitコンテナまたはentrypoint.shで実行

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

- Story: (US-2) docker compose upで全サービスを起動したい
