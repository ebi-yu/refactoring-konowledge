## ユーザーストーリー

| 項目 | 内容 |
|------|------|
| **Who**（誰が） | 管理者 |
| **What**（何をしたい） | `docker compose up`だけで全サービスを起動したい |
| **Why**（なぜ・価値） | 複雑な手順なしにすぐ動く環境を手に入れたいから |

**ストーリー文（上記を文章化）:**

> **管理者** として、**`docker compose up`だけで全サービスを起動したい** がしたい。なぜなら **複雑な手順なしにすぐ動く環境を手に入れたい** からだ。

## 背景・補足

docker-compose.ymlにアプリ・PostgreSQL・MinIOを定義し、depends_onとhealthcheckで起動順を制御する。`docker compose up -d`一発でローカル開発環境が動作する状態にする。

## 受け入れ基準

- [ ] **Given** docker compose環境  
      **When** `docker compose up -d`を実行する  
      **Then** アプリ・DB・MinIOが起動してトップページにアクセスできる

## スコープ・制約

| 項目 | 内容 |
|------|------|
| **優先度** | `Must` |
| **旧システム対応** | 🆕 新規 |
| **スコープ** | `[x]` 実装 |

## タスク一覧

- [ ] (TASK) docker-compose.yml作成
- [ ] (TASK) サービス依存関係・ヘルスチェック設定

## 参照

- Epic: 15. インフラ・運用/epic.md
