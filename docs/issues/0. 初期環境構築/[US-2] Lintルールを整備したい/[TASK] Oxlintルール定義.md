## 概要

`.oxlintrc.json` を作成し、プロジェクトの記述規約を Oxlint ルールとして定義する。

どのルールを定義するかは要検討

## 親 STORY

- STORY: (US-2) Lintルールを整備したい

## 作業内容

### 基本設定

- [ ] `.oxlintrc.json` を作成する
- [ ] `plugins: ["vue"]` を追加して Vue ルールを有効化する

### Vue ルール

- [ ] `vue/no-options-api`: Options API 使用を禁止（`__VUE_OPTIONS_API__: false` と一致させる）
- [ ] `vue/component-api-style`: `["script-setup"]` のみ許可

### TypeScript ルール

- [ ] `no-unused-vars`: 未使用変数をエラーにする
- [ ] `@typescript-eslint/no-explicit-any`: `any` 使用を警告にする

### 除外設定

- [ ] `app/components/ui/**`: Ark UI ラッパーは一部ルールを緩和（vapor 対応後に見直し）

## 技術メモ

- Oxlint の設定ファイルは `.oxlintrc.json`（プロジェクトルート）
- `bun run lint` で実行（`package.json` の `scripts.lint` は `oxlint .`）
- Vapor Mode 強制ルールは Oxlint に組み込みルールがないため、Vue 3.6 正式リリース後に別途検討（[#138](https://github.com/ebi-yu/refactoring-konowledge/issues/138) 参照）

## 完了の定義（DoD）

- [ ] コードが実装されている
- [ ] `bun run lint` でエラーなし
- [ ] セルフレビュー済み

## 見積もり

| 項目         | 値  |
| ------------ | --- |
| 見積もり時間 | h   |
| 実績時間     | h   |
