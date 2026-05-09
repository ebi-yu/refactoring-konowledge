#!/bin/bash
# PostToolUse hook: git commit 後に PR がなければ作成して issue #3 にリンクする

INPUT=$(cat)
COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // ""')

# git commit を含むコマンドでなければスキップ
if ! echo "$COMMAND" | grep -q "git commit"; then
  exit 0
fi

export PATH="$HOME/.local/share/mise/shims:$PATH"

BRANCH=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)

# main / master ブランチはスキップ
if [ "$BRANCH" = "main" ] || [ "$BRANCH" = "master" ]; then
  exit 0
fi

REPO="ebi-yu/refactoring-konowledge"

# すでに PR が存在するか確認
EXISTING_PR=$(gh pr list --repo "$REPO" --head "$BRANCH" --state open --json number -q '.[0].number' 2>/dev/null)

if [ -n "$EXISTING_PR" ]; then
  exit 0  # PR 既存 → スキップ
fi

# リモートにブランチを push（未 push の場合）
git push -u origin "$BRANCH" 2>/dev/null || true

# 直前のコミットメッセージを PR タイトルに使用
COMMIT_MSG=$(git log -1 --format="%s" 2>/dev/null)

# PR を作成して issue #3 にリンク
PR_URL=$(gh pr create \
  --repo "$REPO" \
  --title "$COMMIT_MSG" \
  --body "$(cat <<'EOF'
## 概要

Closes #3

## 変更内容

<!-- 自動作成された PR です。必要に応じて編集してください。 -->
EOF
)" \
  --head "$BRANCH" \
  --base main 2>/dev/null)

if [ -n "$PR_URL" ]; then
  echo "{\"systemMessage\": \"PR を作成しました: ${PR_URL}\"}"
fi
