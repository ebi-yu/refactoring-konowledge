# Issue テンプレート集（アジャイル：EPIC / STORY / TASK）

> 機能スコープ（[[feature_scope]]）をもとに Issue を起こす際のテンプレート集のインデックス。
> EPIC → STORY → TASK の 3 階層で管理する。

## テンプレート一覧

| ファイル                               | 種別      | 概要                               |
| -------------------------------------- | --------- | ---------------------------------- |
| [epic_template.md](epic_template.md)   | **EPIC**  | 機能グループ単位（数週間〜数ヶ月） |
| [story_template.md](story_template.md) | **STORY** | ユーザー価値単位（数日〜1 週間）   |
| [task_template.md](task_template.md)   | **TASK**  | 実装単位（数時間〜1 日）           |

---

## 階層の定義

| 種別      | 粒度                                          | 対応するスコープ行                                      | ラベル例     |
| --------- | --------------------------------------------- | ------------------------------------------------------- | ------------ |
| **EPIC**  | 機能グループ（数週間〜数ヶ月）                | `### 1. 認証・アカウント管理` など章レベル              | `type:epic`  |
| **STORY** | ユーザーが価値を感じる 1 機能（数日〜1 週間） | テーブル 1 行（例: `1-1 メールアドレス登録・ログイン`） | `type:story` |
| **TASK**  | STORY を分割した実装単位（数時間〜1 日）      | STORY 内で技術的に分割したもの                          | `type:task`  |

---

## 使い方フロー

```
01_feature_scope.md を開く
        │
        ▼
章（### X. xxxxxx）を 1 つ選ぶ
        │
        ▼
[EPIC] Issue を起票 ─────────────────────────────────────┐
        │                                                 │
        ▼                                                 │
テーブルの各行（スコープ [x] / [△] のみ）を 1 つ選ぶ      │
        │                                                 │
        ▼                                                 │
[STORY] Issue を起票 → EPIC にリンク                      │
        │                                                 │
        ▼                                                 │
STORY を技術単位に分割                                     │
        │                                                 │
        ▼                                                 │
[TASK] Issue を起票 → STORY にリンク ────────────────────┘
```

---

## ラベル推奨セット

| ラベル名             | 色（16進） | 用途             |
| -------------------- | ---------- | ---------------- |
| `type:epic`          | `#8B5CF6`  | EPIC Issue       |
| `type:story`         | `#3B82F6`  | STORY Issue      |
| `type:task`          | `#10B981`  | TASK Issue       |
| `scope:in`           | `#22C55E`  | スコープイン確定 |
| `scope:partial`      | `#F59E0B`  | 部分実装         |
| `status:todo`        | `#E5E7EB`  | 未着手           |
| `status:in-progress` | `#FCD34D`  | 着手中           |
| `status:done`        | `#6EE7B7`  | 完了             |

---

## 参照ドキュメント

- [EPIC テンプレート](epic_template.md)
- [STORY テンプレート](story_template.md)
- [TASK テンプレート](task_template.md)
- [機能スコープ一覧](../01_feature_scope.md)
- [技術スタック](../03_tech_stack.md)
- [ADR一覧](../adr/)
