## 概要

管理者がお知らせを作成・更新・削除するAPIと全ユーザーへの取得APIの実装。

## 親 Story

- Story: (US-2) システムお知らせをヘッダーで確認したい

## 作業内容

- [ ] `system_notices` テーブルのDBスキーマ定義（title, body, is_active, created_at）
- [ ] `POST /api/admin/notices` — お知らせ作成（管理者権限必須）
- [ ] `PUT /api/admin/notices/:id` — お知らせ更新
- [ ] `DELETE /api/admin/notices/:id` — お知らせ削除
- [ ] `GET /api/notices/active` — 有効なお知らせ取得（全ユーザー用）

## 技術メモ

- is_activeフラグで表示・非表示を切り替える
- 管理者エンドポイントはロールチェックミドルウェアで保護する
- 全ユーザー向けGETはキャッシュを活用してDBアクセスを減らす

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

- Story: (US-2) システムお知らせをヘッダーで確認したい
