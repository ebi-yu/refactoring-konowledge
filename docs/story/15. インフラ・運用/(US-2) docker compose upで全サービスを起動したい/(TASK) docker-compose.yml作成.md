## 概要

アプリ・PostgreSQL・MinIO等を含むdocker-compose.ymlの作成。

## 親 Story

- Story: (US-2) docker compose upで全サービスを起動したい

## 作業内容

- [ ] `docker-compose.yml` にアプリ・PostgreSQL・MinIOのサービス定義を追加
- [ ] 各サービスのイメージバージョン固定と環境変数設定
- [ ] ボリューム定義（PostgreSQLデータ・MinIOデータ）
- [ ] ネットワーク定義（サービス間通信）
- [ ] `.env.example` に docker compose 用の環境変数を追加

## 技術メモ

- PostgreSQLは公式イメージ（postgres:16-alpine）を使用
- MinIOは `minio/minio:latest` を使用しAPIポートとコンソールポートを公開
- アプリのDockerfileはマルチステージビルドで本番用イメージサイズを最小化

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

- Story: (US-2) docker compose upで全サービスを起動したい
