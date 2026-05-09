## 概要

CLIツールのpackageセットアップ・コマンドパーサー・認証設定の基盤実装。

## 親 STORY

- STORY: (US-4) CLIで記事を操作したい

## 作業内容

- [ ] CLIパッケージ（`knowledge-cli`）のpackage.json・tsconfig設定
- [ ] コマンドパーサーライブラリ（commander / yargs等）の導入設定
- [ ] `knowledge login` コマンドの実装（APIトークンをローカル設定ファイルに保存）
- [ ] `knowledge logout` コマンドの実装（設定ファイルのトークン削除）
- [ ] 設定ファイル（`~/.knowledge/config.json`）の読み書きユーティリティ実装

## 技術メモ

- 設定ファイルは `~/.knowledge/config.json` に保存してパーミッションを600に設定
- APIエンドポイントURLも設定ファイルで管理してセルフホスト環境にも対応
- TypeScriptでビルドしてnpm経由でインストールできるようにする

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

- STORY: (US-4) CLIで記事を操作したい
