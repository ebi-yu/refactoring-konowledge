## 概要

指定 URL の HTML から OGP メタタグ（og:title, og:description, og:image）を取得するサーバーサイド API の実装。

## 親 Story

- Story: (US-5) URLがOGPカードとして表示されるのを見たい

## 作業内容

- [ ] `GET /api/ogp?url=<encoded_url>` エンドポイントを実装する
- [ ] サーバーサイドで対象 URL の HTML を取得し、`<meta property="og:*">` タグをパースする
- [ ] タイトル・説明・画像・faviconを抽出してレスポンスする
- [ ] 取得結果をキャッシュ（Redis または in-memory）して同じ URL への重複リクエストを防ぐ
- [ ] タイムアウト（例: 3秒）を設定してレスポンス遅延を防ぐ

## 技術メモ

- SSRF 対策として内部 IP アドレス（10.x, 192.168.x, 127.x 等）へのリクエストをブロックする
- HTML パースには `cheerio` または `node-html-parser` を使用する

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

- Story: (US-5) URLがOGPカードとして表示されるのを見たい
