# Developer Guide

このファイルには、このリポジトリで開発するときの恒久的な前提だけを書く。
実装フローや運用手順は AGENTS / skills 側を参照する。

## デザイン

- デザインには pencil を使用する
- `.pen` 形式でデザインを管理する

## フロントエンド

- Vue ファイルは現在 Vapor Mode を使用しない
- Vue 3.6 beta では、Vapor コンポーネントから VDOM コンポーネント（`@ark-ui/vue` など）を使うと SSR hydration でクラッシュする既知の問題がある
- Vapor Mode 対応は [issues/21. 技術的TODO/[US-1] Vapor Mode 対応/story.md](issues/21.%20技術的TODO/%5BUS-1%5D%20Vapor%20Mode%20対応/story.md) で管理する

### UI 方針

- 既成 UI コンポーネントは Park UI（`@ark-ui/vue` + `@park-ui/panda-preset`）を使う
- カスタム UI と design tokens は Panda CSS で管理する
- Park UI コンポーネントは `app/components/ui/` にコピーして編集する
- コンポーネントのスタイルは Panda CSS の `sva` を優先して、スロット単位で閉じ込める

## バックエンド

- レイヤー構成は `Presentation → Application → Domain ← Infrastructure`
- `server/domain/` はフレームワークや DB に依存しない
- `shared/schemas/` の Zod スキーマを型の唯一の真実とする
