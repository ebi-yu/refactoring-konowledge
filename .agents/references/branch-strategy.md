# ブランチ戦略

```
main
 └── epic/<epic-name>        # Epic単位のブランチ
      └── us/<story-name>    # User Story単位のブランチ
           └── task/<task-name>  # Task単位のブランチ（ここで実装）
```

**作業開始時に必ずブランチを作成する（上位から順に）:**

下位ブランチは上位ブランチが存在しないと切れないため、必ずこの順序で行う。

```bash
# 1. Epic ブランチ（main から）
git checkout main
git checkout -b epic/auth

# 2. Story ブランチ（epic から）
git checkout -b us/login

# 3. Task ブランチ（us から）
git checkout -b task/login-form
```

既にEpic・Storyブランチが存在する場合は、そこから切る。

**マージの方向:** `task → us → epic → main`（各段階でユーザーのレビュー・マージ待ち）
