## 概要

各プロバイダー（GitHub・GitLab・Keycloak）の OAuth コールバックを処理し、ユーザーを DB に登録または更新するエンドポイント実装。

## 親 Story

- Story: (US-1) GitHub・GitLab・Keycloakのアカウントでログインしたい

## 作業内容

- [ ] `/auth/github/callback`・`/auth/gitlab/callback`・`/auth/keycloak/callback` ルートを実装する
- [ ] コールバックで受け取ったプロフィール情報（id, email, name, avatar_url）を DB に upsert する
- [ ] 既存ユーザーの場合は provider_id で突合してレコードを更新する
- [ ] コールバック成功後にセッションを発行してトップページにリダイレクトする
- [ ] エラー（アクセス拒否・state 不一致）を適切にハンドリングする

## 技術メモ

- OAuth state パラメータで CSRF を防止する
- 同一メールアドレスで複数プロバイダーが存在する場合のアカウントマージ方針を事前に決定しておく
- DB upsert は `ON CONFLICT (provider, provider_id) DO UPDATE` パターンを使用する

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
