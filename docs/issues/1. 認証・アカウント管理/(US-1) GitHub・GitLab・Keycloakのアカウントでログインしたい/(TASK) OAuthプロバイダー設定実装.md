## 概要

GitHub・GitLab・Keycloak の OAuth/OIDC プロバイダー設定（client_id, client_secret, redirect_uri 等）を環境変数から読み込む設定実装。

## 親 Story

- Story: (US-1) GitHub・GitLab・Keycloakのアカウントでログインしたい

## 作業内容

- [ ] 各プロバイダー（GitHub / GitLab / Keycloak）の OAuth アプリを登録し client_id・client_secret を取得する
- [ ] 環境変数（`.env`）にプロバイダー設定項目を定義する
- [ ] 設定読み込みモジュールを実装し、プロバイダーごとの OAuth ストラテジーを初期化する
- [ ] redirect_uri をプロバイダーごとに設定し動作確認する

## 技術メモ

- Passport.js（Node.js）または各フレームワーク対応の OAuth ライブラリを使用する
- Keycloak は OIDC（OpenID Connect）で接続し、realm / issuer URL も環境変数で切り替え可能にする
- 本番・開発環境で異なる redirect_uri を使えるよう `BASE_URL` 環境変数を参照する

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

- Story: (US-1) GitHub・GitLab・Keycloakのアカウントでログインしたい
