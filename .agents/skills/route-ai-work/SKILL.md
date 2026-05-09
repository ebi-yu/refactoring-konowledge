---
name: route-ai-work
description: Use when deciding where AI-assisted software work belongs across Claude Code Pro, Codex Pro, GitHub Codex cloud, and GitHub Copilot before implementation, fixes, or review.
---

# Route AI Work

## Purpose

Choose one execution lane before work starts. This skill removes ambiguous judgment about local vs cloud execution and tool ownership; it routes the work, then `implements` executes the selected lane.

First matching rule wins. Do not offer multiple acceptable lanes.

## Quantitative Size

Estimate touched production files and net production LOC before routing. Tests, docs, generated files, lockfiles, and formatting-only churn do not count as production LOC.

| Size   | Production files | Production LOC |
| ------ | ---------------: | -------------: |
| Small  |        1-3 files |      1-120 LOC |
| Medium |        4-8 files |    121-400 LOC |
| Large  |         9+ files |       401+ LOC |

Use the larger result when file count and LOC disagree.

## Quantitative Scope

| Scope        | Definition                                                            |
| ------------ | --------------------------------------------------------------------- |
| Isolated     | Exactly one `[TASK]*.md`, one app layer, and no shared contract files |
| Cross-module | Two or more app layers, or any shared contract file                   |
| Multi-story  | More than one Story directory or more than one GitHub Issue           |

App layers are `app/`, `server/`, `shared/`, `prisma/`, and configuration files. Shared contract files include `shared/schemas/`, `server/domain/`, `prisma/schema.prisma`, `panda.config.ts`, `nuxt.config.ts`, package manager files, and CI/deploy files.

## Lanes

| Lane                              | Owner           | Place              | Use for                                                                                          |
| --------------------------------- | --------------- | ------------------ | ------------------------------------------------------------------------------------------------ |
| local-claude-planning-review      | Claude Code Pro | Local workspace    | Planning, decomposition, requirements clarification, risk review, final review                   |
| local-codex-implementation        | Codex Pro       | Local workspace    | Deterministic edits needing repo context, tests, secrets-safe local commands, or sensitive areas |
| cloud-github-codex-implementation | Codex cloud     | GitHub/Codex cloud | Isolated implementation from issue/PR context where cloud can verify without local-only state    |
| github-copilot-fixes-review       | GitHub Copilot  | GitHub PR/editor   | Small PR comments, localized fixes, review suggestions, and mechanical follow-ups                |

## Ordered Routing Rules

1. If the request is planning, design review, scoping, decomposition, acceptance criteria, code review, risk review, or deciding how work should be done, choose `local-claude-planning-review`.
2. If the work touches DB schema or migrations, authentication, authorization, permissions, secrets, dependency versions, package manager config, build/runtime config, CI config, deploy config, design tokens, or shared styling foundations, choose `local-codex-implementation` regardless of size.
3. If the work requires local-only context, uncommitted workspace state, private files, local services, manual browser verification, environment variables, or commands unavailable in GitHub/Codex cloud, choose `local-codex-implementation`.
4. If implementation is large, choose `local-codex-implementation`.
5. If implementation is medium and scope is `Cross-module` or `Multi-story`, choose `local-codex-implementation`.
6. If implementation is small or medium, scope is `Isolated`, has a single GitHub issue or PR, and can be verified entirely in GitHub/Codex cloud, choose `cloud-github-codex-implementation`.
7. If the task is to address small GitHub PR review comments, typo-level fixes, localized lint/type failures, or reviewer suggestions affecting 1-2 files and up to 80 production LOC, choose `github-copilot-fixes-review`.
8. If none of the above rules match, choose `local-codex-implementation`.

## Required Handoff Block

Every routing decision must include this block before execution starts:

```text
Lane: <lane id>
Owner: <Claude Code Pro | Codex Pro | Codex cloud | GitHub Copilot>
Place: <local workspace | GitHub/Codex cloud | GitHub PR/editor>
Size: <small | medium | large> (<production files>, <production LOC estimate>)
Reason: <first matching routing rule and why it matched>
Scope: <what is included>
Out of scope: <what must not be changed>
Verification: <required checks before completion>
```

## How To Delegate The Work

After choosing a lane, delegate the actual work using the method below.

| Lane                              | Delegation method                                                                                                                                                                                                                                                          |
| --------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| local-claude-planning-review      | Execute it directly in this conversation. No extra delegation command is needed; Claude Code handles planning, review, decomposition, and final checks in place.                                                                                                           |
| local-codex-implementation        | Delegate to Codex using the `/codex` skill. Include the handoff block above and make scope, out-of-scope constraints, and verification requirements explicit before asking Codex to implement in the local workspace.                                                      |
| cloud-github-codex-implementation | Delegate through a GitHub Issue or PR. Put the handoff block in the issue body, PR body, or a comment, identify the target issue clearly, and assign an owner when needed so the work can be completed entirely in GitHub/Codex cloud. Do not pass local-only information. |
| github-copilot-fixes-review       | Ask GitHub Copilot from the PR or editor. State the target files, the expected localized fix, and the verification condition, and keep the request limited to a narrow 1-2 file change.                                                                                    |

### local-codex-implementation Template

```text
/codex please implement this.

Lane: local-codex-implementation
Owner: Codex Pro
Place: local workspace
Size: <small | medium | large> (<production files>, <production LOC estimate>)
Reason: <first matching routing rule and why it matched>
Scope: <what is included>
Out of scope: <what must not be changed>
Verification: <required checks before completion>
```

### local-claude-planning-review Rule

This lane is not delegated elsewhere. The agent in the current conversation continues the work directly after outputting the handoff block, then proceeds with planning, review, decomposition, or acceptance-criteria refinement.

### cloud-github-codex-implementation Rules

- Limit the handoff to one GitHub Issue or one PR.
- Include the handoff block in the body, description, or review comment.
- Assign an owner when needed so the starting point is explicit.
- Do not include uncommitted local state, secrets, environment variables, or assumptions that depend on local services.
- Provide verification steps that can be completed entirely on GitHub/Codex cloud.

### github-copilot-fixes-review Rules

- Keep PR comment replies and editor requests tightly scoped.
- Name the files, the symptom, and the expected fix concretely.
- Do not expand this lane into broad design changes or cross-module edits.
- Add the smallest relevant check such as lint, typecheck, or the affected test when needed.

## Relationship To implements

`route-ai-work` chooses the lane, owner, place, size, and handoff constraints. `implements` performs the implementation after the handoff exists. Do not use `implements` to re-decide the lane.

## Common Mistakes

- Do not say two lanes are both acceptable. Apply the ordered rules and pick the first match.
- Do not route sensitive areas to cloud or Copilot because the edit is small.
- Do not count test or documentation LOC when sizing implementation.
- Do not let Copilot own broad refactors, architecture changes, or multi-file behavior changes.
