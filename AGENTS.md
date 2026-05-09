## 最重要戦略

- ファイルの変更を始める前に必ずブランチを切ること（ブランチ戦略は `.agents/references/branch-strategy.md` を参照）
- ファイルの変更を始める前に`git pull`して最新の状態にすること
- ファイルの変更を始める前に`git pull origin main`して作業ブランチにmainブランチをマージすること
- コミットは小さく意味のある単位で行ってよい（確認はMR/PRで行う）
- コミットを行ったら、必ずgithubにPRを作成してユーザーにマージを依頼すること（PRのレビュワーには必ずCopilotを指定すること）
- 開発作業の入口は `implements-orchestrator` スキルを使うこと
- Task単位の具体実装は `task-implementation` スキルを使うこと
- バグを見つけた場合は `bug-triage` スキルでIssue化・分類してから進めること

## コーディング

- TDDで必ずテストコードを先に書いてから実装すること(Red-Green-Refactorサイクル)
- ブランチ戦略は `.agents/references/branch-strategy.md` を参照（`epic → us → task` の3階層）
- コミットは小さく、意味のある単位で行うこと
- デザインは.pen形式で行うこと
- CHANGELOGはKeep a Changelogのフォーマットに従うこと

## GitHUb

- MRを作る際は必ず、関連するIssueを紐づけること
- MRを作成した際は`Copilot`をレビュワーに指定すること
- `issues`を変更した際は、必ず関連するIssueを更新すること（`bash .agents/hooks/update-issues.sh` を使用）

## 参照

- `.agents/references/architecture.md` — レイヤー設計・ディレクトリ構造
- `.agents/references/tech_stack.md` — 技術スタック
- `.agents/skills/implements-orchestrator/SKILL.md` — 開発作業の入口・進行管理
- `.agents/skills/implements-orchestrator/references/routing-policy.md` — AI依頼先判断
- `.agents/skills/task-implementation/SKILL.md` — Task単位の実装規律
- `.agents/skills/bug-triage/SKILL.md` — バグのIssue化・分類
- `issues/` : github issueと連携したローカルのIssueファイル群
