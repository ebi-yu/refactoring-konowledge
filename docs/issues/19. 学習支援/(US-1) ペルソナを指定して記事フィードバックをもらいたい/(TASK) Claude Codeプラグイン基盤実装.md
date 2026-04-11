## 概要

Claude Code MCPプラグインとしてのパッケージ設定とCLI統合の基盤実装。

## 親 Story

- Story: (US-1) ペルソナを指定して記事フィードバックをもらいたい

## 作業内容

- [ ] Claude Code MCPプラグインとしてのパッケージ設定（`mcp.json` / `package.json`）
- [ ] Claude APIクライアントの設定（APIキー管理・モデル指定）
- [ ] CLIコマンド基盤との統合設定（`knowledge` CLIへのプラグイン登録）
- [ ] Anthropic Claude API接続テストの実装

## 技術メモ

- Anthropic SDK (`@anthropic-ai/sdk`) を使用してClaude APIを呼び出す
- APIキーは `ANTHROPIC_API_KEY` 環境変数または `~/.knowledge/config.json` で管理
- MCPサーバーとして実装してClaude Codeから呼び出せるようにする

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

- Story: (US-1) ペルソナを指定して記事フィードバックをもらいたい
