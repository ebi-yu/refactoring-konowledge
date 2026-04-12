# ブランチ戦略

```
main
 └── epic/<epic-name>        # Epic単位のブランチ
      └── us/<story-name>    # User Story単位のブランチ
           └── task/<task-name>  # Task単位のブランチ（ここで実装）
```

**作業開始時に必ずブランチを作成する:**

```bash
# 例: Epic「認証」> Story「ログイン」> Task「ログインフォーム実装」
git checkout epic/auth
git checkout -b us/login
git checkout -b task/login-form
```

**マージの方向:** `task → us → epic → main`（各段階でユーザーのレビュー・マージ待ち）
