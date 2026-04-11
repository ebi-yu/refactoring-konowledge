## 概要

`knowledge post/edit/list`等のCLIコマンドの実装。

## 親 Story

- Story: (US-4) CLIで記事を操作したい

## 作業内容

- [ ] `knowledge post <file>` コマンドの実装（MarkdownファイルをAPIで投稿）
- [ ] `knowledge edit <article-id>` コマンドの実装（記事をエディタで編集して更新）
- [ ] `knowledge list` コマンドの実装（自分の記事一覧表示）
- [ ] `knowledge delete <article-id>` コマンドの実装（記事削除）
- [ ] Markdownフロントマター（title, tags等）のパース処理

## 技術メモ

- `EDITOR` 環境変数を参照してデフォルトエディタで記事を開く
- フロントマターはgray-matter等のライブラリでパースする
- 投稿/更新の際にはAPIから返るエラーを分かりやすいメッセージで表示する

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

- Story: (US-4) CLIで記事を操作したい
