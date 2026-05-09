---
name: route-ai-work
description: Deprecated compatibility skill. AI依頼先判断は implements-orchestrator が .agents/skills/implements-orchestrator/references/routing-policy.md を参照して行う。通常は implements-orchestrator を使う。
---

# route-ai-work

このスキルは互換用です。
AI依頼先判断は、独立スキルではなく `implements-orchestrator` の参照ポリシーとして扱います。

新しい作業では次を使ってください。

```text
.agents/skills/implements-orchestrator/SKILL.md
.agents/skills/implements-orchestrator/references/routing-policy.md
```

## 移行後の扱い

- レーン判断の主体は `implements-orchestrator`。
- 判断ルールの実体は `implements-orchestrator/references/routing-policy.md`。
- このスキルを単独の入口として使わない。
