## 参照

開発環境・技術スタック・Vapor Mode など開発全般の情報は **[DEVELOPER.md](./DEVELOPER.md)** を参照。

## コーディング

- TDDで必ずテストコードを先に書いてから実装すること(Red-Green-Refactorサイクル)
- 作業はfeatureブランチをmainから切って行うこと
- コミットは小さく、意味のある単位で行うこと
- コミットが完了したらCHANGELOG.mdを更新すること
- デザインは.pen形式で行うこと

  ```md
  ## yyyy-mm-dd

  ### [type]

  - <変更内容>
  ```

## 開発の進め方

### 前提

- github issueとローカルの`docs/issues`の内容を連携させている
- 連携には`.claude/hooks/update-issues.sh`を使用している。
- フロントエンドの実装フローは **`frontend-workflow` スキル**（`.claude/skills/frontend-workflow/SKILL.md`）を参照すること。
- バックエンドの実装フローは **`backend-workflow` スキル**（`.claude/skills/backend-workflow/SKILL.md`）を参照すること。

### 共通の開発フロー

#### 1. エピックの決定

ユーザーにどのエピックを実装するかを決めてもらう。
エピックは `docs/issues/` 配下のディレクトリ一覧から選ぶ。

#### 2. ユーザーストーリーの確認

エピックに紐づくストーリー（`[US-N]` ディレクトリ）を確認し、実装するストーリーを選ぶ。
ストーリー内のタスク（`[TASK]*.md`）を洗い出し、依存関係を整理する。

#### 3. タスクの並列実行

依存関係のないタスクは**サブエージェントで並列実行**する。

```
タスクA ──► サブエージェント1
タスクB ──► サブエージェント2  （同時起動）
タスクC ──► サブエージェント3
```

各サブエージェントには以下を明示して渡す:

- 対象の `[TASK]*.md` ファイルパス
- 使用するスキル（フロントなら `frontend-workflow`、バックなら `backend-workflow`）
- 完了時に `[TASK]*.md` のチェックリストを更新すること

#### 4. タスク完了時の必須手順

各タスクが完了したら**必ず**以下を実行する:

1. `[TASK]*.md` の完了した作業項目を `[x]` に更新する
2. GitHub に同期する: `bash .claude/hooks/update-issues.sh "<タスクファイルパス>"`
3. コミットを作成する

すべてのタスクが完了したら、Story の `story.md` の作業内容も更新してコミットする。
