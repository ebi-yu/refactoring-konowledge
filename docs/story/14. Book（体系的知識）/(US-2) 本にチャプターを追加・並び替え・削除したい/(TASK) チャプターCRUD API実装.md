## 概要

POST/PUT/DELETE /api/books/:id/chapters エンドポイントの実装（並び順管理含む）。

## 親 Story

- Story: (US-2) 本にチャプターを追加・並び替え・削除したい

## 作業内容

- [ ] `book_chapters` テーブルのDBスキーマ定義（id, book_id, article_id, position, created_at）
- [ ] `POST /api/books/:id/chapters` — チャプター追加（記事IDと位置指定）
- [ ] `PUT /api/books/:id/chapters/reorder` — チャプター並び順一括更新
- [ ] `DELETE /api/books/:id/chapters/:chapterId` — チャプター削除
- [ ] 並び順の整合性維持ロジック（position重複・空白の自動修正）

## 技術メモ

- positionは整数値で管理し、並び替えは全チャプターのposition一括更新で対応
- 1つの記事を複数の本に含めることを許可するかはビジネスルールを確認
- チャプター削除は記事本体を削除せずbook_chaptersレコードのみ削除する

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

- Story: (US-2) 本にチャプターを追加・並び替え・削除したい
