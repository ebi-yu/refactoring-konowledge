## 概要

GET/POST/PUT/DELETE /api/v1/articles エンドポイント群の実装。

## 親 STORY

- STORY: [US-1] REST APIで記事CRUDをしたい

## 作業内容

- [ ] `POST /api/v1/articles` — 記事作成（タイトル・本文・タグ）
- [ ] `GET /api/v1/articles` — 記事一覧取得（ページネーション・フィルター）
- [ ] `GET /api/v1/articles/:id` — 記事詳細取得
- [ ] `PUT /api/v1/articles/:id` — 記事更新
- [ ] `DELETE /api/v1/articles/:id` — 記事削除
- [ ] APIトークン認証ミドルウェアの適用

## 技術メモ

- `/api/v1/` プレフィックスでバージョニングを明示する
- 記事作成・更新・削除は自分のリソースのみ操作可能にする
- レスポンスはJSON APIまたはREST標準のフォーマットに統一する

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

- STORY: [US-1] REST APIで記事CRUDをしたい
