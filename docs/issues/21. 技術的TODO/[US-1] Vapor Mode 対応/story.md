## 概要

Vue 3.6 の Vapor Mode（VDOMレスレンダリング）を本プロジェクトで有効化する。現在は `@ark-ui/vue` など外部 VDOM コンポーネントを使う際に SSR hydration でクラッシュする既知の問題（Vue 3.6 beta 制限）があるため一時保留中。

## 親 EPIC

- EPIC: (21) 技術的TODO

## ユーザーストーリー

**開発者** として、**Vue ファイルを Vapor Mode でコンパイルできる状態** にしたい。なぜなら **VDOM を排除することでランタイムサイズと描画コストを削減し、Vue 3.6 の恩恵を最大限に活かせるから**。

## 背景・保留理由

- Vapor コンポーネント（`<script setup lang="ts" vapor>`）から VDOM コンポーネント（`@ark-ui/vue`）を子として使うと、SSR hydration 時に `setRef` が vapor の内部構造と合わずクラッシュする
- `vaporInteropPlugin` を登録しても hydration タイミングで解消されない
- Vue 3.6 が正式リリースされ interop が安定したタイミングで対応する

## 作業内容

- [ ] Vue 3.6 正式リリース後に Vapor + VDOM interop の SSR hydration 挙動を検証する
- [ ] `app/pages/` および `app/components/`（ui/ 除く）に `vapor` を付与する
- [ ] `app/plugins/vapor.client.ts` で `vaporInteropPlugin` を登録する
- [ ] `app/components/ui/` の Ark UI ラッパーは vapor 対象外とし oxlint 除外設定を追加する

## 完了の定義（DoD）

- [ ] `bun run dev` で hydration エラーなし
- [ ] `bun run build` でビルド成功
- [ ] セルフレビュー済み（lint / format エラーなし）
