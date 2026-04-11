## 概要

Chrome拡張のmanifest.json・ポップアップHTML・background serviceWorkerの基盤実装。

## 親 STORY

- STORY: [US-1] ツールバーからメモをスレッドに投稿したい

## 作業内容

- [ ] `manifest.json` の作成（Manifest V3・必要なpermissions設定）
- [ ] ポップアップHTML・CSS・JavaScript（React or Vanilla JS）の基盤実装
- [ ] Background Service Workerの設定（APIクライアント処理）
- [ ] ストレージ（`chrome.storage.local`）へのAPIトークン・設定保存処理
- [ ] 認証状態チェックと未ログイン時のログイン促進UI

## 技術メモ

- Manifest V3では `background.service_worker` を使用（V2の `background.scripts` は非推奨）
- `chrome.storage.local` にAPIトークンとサーバーURLを保存する
- Content Security PolicyはManifest V3の制約に従い外部スクリプトを制限する

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

- STORY: [US-1] ツールバーからメモをスレッドに投稿したい
