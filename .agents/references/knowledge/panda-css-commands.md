# Panda CSS のコマンドと CSS 生成の仕組み

## なぜこれを知る必要があるか

> `bun run dev` でボタンのスタイルが当たらない、`panda codegen` を実行したのになぜか CSS が更新されない——原因を追うには Panda CSS がどのタイミングで何を生成するかを知る必要がある。

---

## 一言で言うと

> **`panda` / `panda watch` がソースをスキャンして CSS を生成する。`panda codegen` は CSS を生成しない。**

---

## 全体像

- `panda` はソースファイルをスキャンし、使われたスタイルだけを `styles.css` に書き出す
- `panda watch` は起動時に同じスキャンを行い、その後ファイル変更を監視し続ける
- `panda codegen` は TypeScript のユーティリティ関数を生成するだけで CSS は変更しない
- `styles.css` の `@layer utilities` が空なら、スキャンが実行されていない

---

## 詳細

### コマンドの違い

| コマンド        | 初回スキャン | CSS 生成 | ファイル監視               |
| --------------- | ------------ | -------- | -------------------------- |
| `panda`         | あり         | あり     | なし（1回で終了）          |
| `panda --watch` | **あり**     | あり     | あり（変更を監視し続ける） |
| `panda codegen` | なし         | **なし** | なし                       |

`panda --watch` は起動時に `panda` と同じ初回スキャンを行う。そのため `panda && panda --watch` と2回実行する必要はない。

> **注意**: `panda watch`（サブコマンド形式）は v1.9.1 でファイルを0件スキャンするバグがある。必ず `panda --watch`（フラグ形式）を使うこと。

### panda codegen が CSS を生成しない理由

`panda codegen` は `styled-system/` 配下の TypeScript ユーティリティ（`css()`, `sva()` 関数そのもの）を生成するコマンド。スタイルの「書き方」を提供するが、「何が使われているか」はスキャンしないため CSS は出力されない。

```
panda codegen が生成するもの
  styled-system/css/      ← css(), sva(), cva() などの関数
  styled-system/types/    ← TypeScript 型定義

panda が生成するもの（上記 + ）
  styled-system/styles.css ← 実際に読み込まれる CSS ファイル
```

---

## このプロジェクトでの使い方

```json
// package.json
{
  "dev": "panda --watch & nuxt dev", // 起動時スキャン + 以降は監視
  "build": "panda && nuxt build" // 1回スキャンして終了
}
```

`build` は監視不要なので `panda`（1回限り）。`dev` は `panda watch` だけで初回スキャンも監視も両方カバーできる。

---

## よくある誤解・トラブル

| 状況                                                  | 正しい理解                                                                  |
| ----------------------------------------------------- | --------------------------------------------------------------------------- |
| `panda codegen` を実行したのにスタイルが変わらない    | `codegen` は CSS を生成しない。`panda` または `panda watch` を使う          |
| `panda && panda watch` と書いてある                   | 初回スキャンが2回走るだけで無害だが冗長。`panda watch` だけで良い           |
| ファイルを保存したのにスタイルが反映されない          | `panda --watch` が起動していない。`bun run dev` で再起動する                |
| `panda watch` を使ったら0ファイルしかスキャンされない | v1.9.1 のバグ。`panda --watch`（フラグ形式）を使う                          |
| `@layer utilities` が空                               | `panda` / `panda watch` が正常に実行されていない。`bunx panda` で手動再生成 |
