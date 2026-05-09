## 参照

開発環境・技術スタック・Vapor Mode など開発全般の情報は **[DEVELOPER.md](./.claude/references/DEVELOPER.md)** を参照。

- ファイルの変更を始める前に必ずブランチを切ること（ブランチ戦略は `.agents/references/branch-strategy.md` を参照）
- ファイルの変更を始める前に`git pull`して最新の状態にすること
- ファイルの変更を始める前に`git pull origin main`して作業ブランチにmainブランチをマージすること
- コミットは勝手に行わず、必ずユーザーの許可を求めること
- コードの変更は`codex`スキルを使ってcodexに委託すること

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

## 開発の進め方

`implements` スキルに従う
