## 概要

記事作成・更新 API に draft ステータス対応を追加し、下書き保存エンドポイントを実装。

## 親 Story

- Story: (US-6) 下書きとして保存したい

## 作業内容

- [ ] articles テーブルに `status` 列（`draft` / `published`）を追加するマイグレーションを実装する
- [ ] `POST /api/articles` および `PUT /api/articles/:id` で `status` フィールドを受け取れるようにする
- [ ] `PATCH /api/articles/:id/publish` エンドポイントを実装し、draft → published に変更する
- [ ] 下書き記事は作成者のみが取得できるようにアクセス制御を追加する

## 技術メモ

- `status` と `visibility` は独立したフィールドとして管理する（下書きでも公開範囲は設定可能）
- 公開日時（`published_at`）を publish 操作時に設定する

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

- Story: (US-6) 下書きとして保存したい
