#!/bin/bash
# PostToolUse hook: git commit 後に GitHub issue #3 の進捗チェックボックスを更新する

INPUT=$(cat)
COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // ""')

# git commit を含むコマンドでなければスキップ
if ! echo "$COMMAND" | grep -q "git commit"; then
  exit 0
fi

# 直前のコミットメッセージを取得
COMMIT_MSG=$(git log -1 --format="%s" 2>/dev/null || echo "")
if [ -z "$COMMIT_MSG" ]; then
  exit 0
fi

COMMIT_LOWER=$(echo "$COMMIT_MSG" | tr '[:upper:]' '[:lower:]')

# コミットメッセージのキーワードから対応タスクを決定
TASK_LABEL=""
if echo "$COMMIT_LOWER" | grep -q "mise"; then
  TASK_LABEL="Task 1"
elif echo "$COMMIT_LOWER" | grep -q "docker"; then
  TASK_LABEL="Task 2"
elif echo "$COMMIT_LOWER" | grep -q "scaffold"; then
  TASK_LABEL="Task 3"
elif echo "$COMMIT_LOWER" | grep -q "configure nuxt"; then
  TASK_LABEL="Task 4"
elif echo "$COMMIT_LOWER" | grep -q "directory structure"; then
  TASK_LABEL="Task 5"
elif echo "$COMMIT_LOWER" | grep -q "tsgo"; then
  TASK_LABEL="Task 6"
elif echo "$COMMIT_LOWER" | grep -q "oxlint"; then
  TASK_LABEL="Task 7"
elif echo "$COMMIT_LOWER" | grep -q "oxfmt"; then
  TASK_LABEL="Task 8"
elif echo "$COMMIT_LOWER" | grep -q "husky"; then
  TASK_LABEL="Task 9"
elif echo "$COMMIT_LOWER" | grep -q "prisma"; then
  TASK_LABEL="Task 10"
elif echo "$COMMIT_LOWER" | grep -q "panda"; then
  TASK_LABEL="Task 11"
elif echo "$COMMIT_LOWER" | grep -qE "zod|better-auth|pinia"; then
  TASK_LABEL="Task 12"
fi

if [ -z "$TASK_LABEL" ]; then
  exit 0
fi

ISSUE_NUMBER=3
REPO="ebi-yu/refactoring-konowledge"

# 現在の issue body を取得
CURRENT_BODY=$(gh issue view "$ISSUE_NUMBER" --repo "$REPO" --json body -q '.body')

# Python で対象タスクのチェックボックスを更新（日本語含む Unicode を安全に処理）
NEW_BODY=$(python3 -c "
import sys, re
body = sys.stdin.read()
label = '${TASK_LABEL}'
pattern = r'- \[ \] (' + re.escape(label) + r'[^\n]*)'
new_body = re.sub(pattern, lambda m: '- [x] ' + m.group(1), body)
print(new_body, end='')
" <<< "$CURRENT_BODY")

if [ "$NEW_BODY" = "$CURRENT_BODY" ]; then
  exit 0  # 変更なし（すでにチェック済み等）
fi

gh issue edit "$ISSUE_NUMBER" --repo "$REPO" --body "$NEW_BODY"
echo "{\"systemMessage\": \"GitHub issue #${ISSUE_NUMBER} の ${TASK_LABEL} を完了済みにしました\"}"
