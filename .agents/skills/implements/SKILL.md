---
name: implements
description: Deprecated compatibility skill. 通常開発、Issue作成、実装開始、次のタスク選定、PR/MR作成、バグ対応は implements-orchestrator を使う。Task 1件の実装規律は task-implementation を使う。
---

# implements

このスキルは互換用です。新しい開発フローでは、次のスキルを使ってください。

```text
通常開発、Issue作成、実装開始、次のタスク選定、PR/MR作成、バグ対応:
  .agents/skills/implements-orchestrator/SKILL.md

Task 1件の実装規律:
  .agents/skills/task-implementation/SKILL.md

バグのIssue化・分類・GitHub同期:
  .agents/skills/bug-triage/SKILL.md
```

## 移行後の責務

- `implements-orchestrator` が開発作業の入口になる。
- `implements-orchestrator/references/routing-policy.md` がAI依頼先判断を担う。
- `task-implementation` がTDD、検証、DoD達成、Task更新を担う。
- `bug-triage` がバグを `[BUG] ... .md` と GitHub Issue に変換する。

新しい作業では、このスキル本文の代わりに `implements-orchestrator` を読む。
