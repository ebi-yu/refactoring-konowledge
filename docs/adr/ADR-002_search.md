---
Status: Accepted
Date: 2026-03-20
---

# ADR-003: 全文検索に Meilisearch を採用する

## Context

旧システムは Lucene 4.10 による全文検索を実装しており、日本語（kuromoji アナライザ）にも対応していた。
リライトにあたり、TypeScript から扱いやすい検索エンジンを選定する必要がある。

主な要件：

- 日本語全文検索
- セルフホスト可能
- TypeScript SDK の充実

## Candidates

| 候補 | 日本語対応 | セルフホスト | TS SDK | 運用コスト |
|------|-----------|------------|--------|-----------|
| **Meilisearch** | ◎ | ◎ | ◎ | 低 |
| Typesense | ○ | ◎ | ○ | 低 |
| PostgreSQL全文検索 | △ | ◎（DB同居） | - | 最小 |
| Elasticsearch | ◎ | ○ | ○ | 高 |
| Algolia | ◎ | ✗（SaaS） | ◎ | 従量課金 |

## Decision

**Meilisearch** を採用する（ただし、スコープ確定後に PostgreSQL 全文検索で十分かどうかを再評価する）。

## Rationale

- REST API と TypeScript SDK が充実しており、Nuxt 4 から扱いやすい
- Docker 1コンテナで起動できるため、開発環境のセットアップが簡単
- 日本語のトークナイズ精度が Typesense より高い
- Elasticsearch に比べて運用コストが大幅に低い

## Consequences

- 検索インデックスと PostgreSQL の二重管理が必要（記事投稿・更新時に同期処理を実装する）
- 添付ファイル内の全文検索は Meilisearch 単体ではできない（旧システムは Apache Tika で PDF 等をテキスト抽出していた。同等の処理を実装するか、初期スコープでは対象外にする）
- 機能スコープによっては PostgreSQL の `tsvector` で十分な場合があり、その場合はインフラをシンプルにするため Meilisearch を外す

## Open Questions

- 添付ファイル内の検索を行うか？（スコープ 4-1 の詳細による）
- 初期スコープで Meilisearch が重すぎる場合は PostgreSQL 全文検索にダウングレードする

---

## Links

- [[tech_stack]] - 技術スタック全体サマリ
- [[feature_scope]] - 検索機能のスコープ（4-1〜4-6）
- [[ADR-004_feature_scope]] - 機能スコープ選定の判断根拠
