---
github_issue: 3
title: "chore: 初期環境構築"
labels: []
---

## 概要

Nuxt 4 フルスタックアプリケーションの初期環境をレイヤード方式でセットアップする。

**Architecture:** Modular Monolith（Nuxt 4 フルスタック）
**Tech Stack:** Nuxt 4, Bun, TypeScript (tsgo), Nitro v2, PostgreSQL 17, Meilisearch, Prisma, Zod, Panda CSS, better-auth, Pinia, Oxlint, Oxfmt, Husky, Docker Compose, Mise

---

## 進捗

### ✅ 完了

- [x] Task 1: Mise セットアップ (`.mise.toml`)
- [x] Task 2: Docker Compose セットアップ (`docker-compose.yml`, `.env`)
- [x] Task 3: Nuxt 4 スキャフォールド
- [x] Task 4: `nuxt.config.ts` 設定（tech_stack.md 準拠）
- [x] Task 5: ディレクトリ構造作成（architecture.md 準拠）
- [x] Task 6: TypeScript (tsgo) セットアップ
- [x] Task 7: Oxlint セットアップ
- [x] Task 8: Oxfmt セットアップ
- [x] Task 9: Husky + lint-staged セットアップ
- [x] Task 10: Prisma セットアップ
- [x] Task 11: Panda CSS セットアップ
- [x] Task 12: 残りの依存インストール (Zod, better-auth, Meilisearch client, Pinia)

### 🔄 残り

- [ ] Task 13: 最終確認（Docker起動 + `bunx prisma db push`）

---

## 完了条件

- [x] `docker compose up -d` で PostgreSQL・Meilisearch が起動する
- [x] `bun run dev` でローカル開発サーバーが起動する
- [x] `npx tsgo --noEmit` で型エラーなし
- [x] `bun run lint` でエラーなし
- [ ] `bun run build` でビルド成功
- [x] `git commit` 時に pre-commit フックが実行される
- [ ] `bunx prisma db push` で DB に接続・同期できる

---

## 参照

- Plan: `docs/superpowers/plans/2026-04-05-env-setup.md`
- Spec: `docs/superpowers/specs/2026-04-05-env-setup-design.md`
