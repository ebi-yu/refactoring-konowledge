#!/bin/bash
# create-issues.sh
# docs/issues/ の Epic > Story > Task 階層を GitHub Issues として一括作成する
#
# 親子関係: GitHub Sub-issues API を使用（ネイティブの親子関係）
#   Epic → Story → Task
#
# ラベル設計:
#   種別ラベル : epic / story / task
#   階層ラベル : エピック#<名前>   → epic・story・task すべてに付与
#                ストーリー#<名前> → story・task に付与
#
# 使い方:
#   bash .claude/hooks/create-issues.sh                         # 全 Epic を対象に作成
#   EPIC="認証・アカウント管理" bash .claude/hooks/create-issues.sh  # 指定 Epic のみ作成
#   DRY_RUN=true bash .claude/hooks/create-issues.sh            # ドライラン（GitHub に何も作成しない）
#
# ※ マッピングファイルに記録済みの issue はスキップ（冪等）

set -uo pipefail

REPO="ebi-yu/refactoring-konowledge"
ISSUES_DIR="docs/issues"
MAPPING_FILE="${ISSUES_DIR}/.github-issue-map.json"
DRY_RUN="${DRY_RUN:-false}"
EPIC="${EPIC:-}"  # 指定があればそのエピックのみ処理
RATE_LIMIT_SLEEP=0.5

# ── カラー出力 ────────────────────────────────────────────────
GREEN='\033[0;32m'; YELLOW='\033[1;33m'; RED='\033[0;31m'; CYAN='\033[0;36m'; NC='\033[0m'
log_info()   { printf "${GREEN}[INFO]${NC}  %s\n" "$*" >&2; }
log_skip()   { printf "${YELLOW}[SKIP]${NC}  %s\n" "$*" >&2; }
log_create() { printf "${CYAN}[NEW]${NC}   %s\n" "$*" >&2; }
log_link()   { printf "${GREEN}[LINK]${NC}  %s\n" "$*" >&2; }
log_error()  { printf "${RED}[ERROR]${NC} %s\n" "$*" >&2; }

# ── マッピングファイル ─────────────────────────────────────────
init_mapping() { [ ! -f "$MAPPING_FILE" ] && echo '{}' > "$MAPPING_FILE"; }

get_issue_number() { jq -r --arg k "$1" '.[$k] // empty' "$MAPPING_FILE"; }

save_issue_number() {
  local key="$1" number="$2" tmp
  tmp=$(mktemp)
  jq --arg k "$key" --argjson n "$number" '.[$k] = $n' "$MAPPING_FILE" > "$tmp" && mv "$tmp" "$MAPPING_FILE"
}

# ── ラベル名生成ヘルパー ──────────────────────────────────────
strip_number_prefix() { echo "$1" | sed 's/^[0-9]*[[:space:]]*\.[[:space:]]*//' | sed 's/^(TASK)[[:space:]]*//' ; }

# ── ラベル作成 ────────────────────────────────────────────────
ensure_label() {
  local name="$1" color="$2" desc="$3"
  [ "$DRY_RUN" = "true" ] && return 0
  gh label create "$name" --repo "$REPO" --color "$color" --description "$desc" 2>/dev/null || \
  gh label edit   "$name" --repo "$REPO" --color "$color" --description "$desc" 2>/dev/null || true
}

ensure_base_labels() {
  log_info "Ensuring base labels..."
  ensure_label "epic"  "0052cc" "Epic"
  ensure_label "story" "e4e669" "User Story"
  ensure_label "task"  "d93f0b" "Task"
}

# ── GitHub Sub-issues API で親子関係を設定 ────────────────────
link_sub_issue() {
  local parent_number="$1" child_number="$2"
  [ -z "$parent_number" ] || [ -z "$child_number" ] && return 0
  [ "$DRY_RUN" = "true" ] && { log_link "[DRY RUN] #${parent_number} → #${child_number}"; return 0; }

  # sub_issue_id は issue の内部 integer ID（number とは別）
  local child_id
  child_id=$(gh api "repos/${REPO}/issues/${child_number}" --jq '.id' 2>/dev/null)
  if [ -z "$child_id" ]; then
    log_error "Could not get id for #${child_number}"
    return 0
  fi

  local result
  result=$(gh api \
    --method POST \
    -H "Accept: application/vnd.github+json" \
    "repos/${REPO}/issues/${parent_number}/sub_issues" \
    -F "sub_issue_id=${child_id}" 2>&1)

  if echo "$result" | grep -q '"id"'; then
    log_link "#${parent_number} → #${child_number}"
  elif echo "$result" | grep -qiE "already|duplicate|one parent"; then
    log_skip "Already linked: #${parent_number} → #${child_number}"
  else
    log_error "Failed to link #${parent_number} → #${child_number}: ${result}"
  fi
}

# ── issue 作成（冪等）────────────────────────────────────────
# 引数: key title body_file label [label ...]
create_issue() {
  local key="$1" title="$2" body_file="$3"
  shift 3
  local labels=("$@")

  # すでに作成済みなら本文のみ更新
  local existing
  existing=$(get_issue_number "$key")
  if [ -n "$existing" ]; then
    if [ "$DRY_RUN" = "true" ]; then
      log_skip "[DRY RUN] #${existing} ${title} (would update body)"
    else
      gh issue edit "$existing" --repo "$REPO" --body-file "$body_file" >/dev/null 2>&1
      log_skip "Updated body: #${existing} ${title}"
    fi
    printf '%s' "$existing"
    return 0
  fi

  if [ "$DRY_RUN" = "true" ]; then
    log_create "[DRY RUN] [${labels[*]}] ${title}"
    printf '0'
    return 0
  fi

  sleep "$RATE_LIMIT_SLEEP"

  local label_args=()
  for lbl in "${labels[@]}"; do label_args+=(--label "$lbl"); done

  local url number
  url=$(gh issue create \
    --repo "$REPO" \
    --title "$title" \
    --body-file "$body_file" \
    "${label_args[@]}" 2>/dev/null || echo "")

  # URL から issue 番号を抽出: https://github.com/.../issues/123
  number=$(echo "$url" | grep -oE '[0-9]+$')

  if [ -n "$number" ] && [ "$number" -gt 0 ] 2>/dev/null; then
    save_issue_number "$key" "$number"
    log_create "#${number} [${labels[*]}] ${title}"
    printf '%s' "$number"
  else
    log_error "Failed to create: ${title}"
    printf ''
  fi
}

# ── メイン ────────────────────────────────────────────────────
main() {
  log_info "Repo:       ${REPO}"
  log_info "Issues dir: ${ISSUES_DIR}"
  log_info "Dry run:    ${DRY_RUN}"
  [ -n "$EPIC" ] && log_info "Epic filter: ${EPIC}"
  echo "" >&2

  init_mapping
  ensure_base_labels

  local epic_count=0 story_count=0 task_count=0

  while IFS= read -r epic_dir; do
    local epic_name epic_short epic_hier_label
    epic_name=$(basename "$epic_dir")
    [[ "$epic_name" == template* || "$epic_name" == .* ]] && continue

    local epic_md="${epic_dir}/epic.md"
    [ ! -f "$epic_md" ] && continue

    epic_short=$(strip_number_prefix "$epic_name")

    # EPIC 指定がある場合は一致するエピックのみ処理
    if [ -n "$EPIC" ] && [ "$epic_short" != "$EPIC" ]; then continue; fi

    epic_hier_label="エピック#${epic_short}"
    ensure_label "$epic_hier_label" "0052cc" "Epic: ${epic_short}"

    # ── Epic issue ──
    local epic_key="epic::${epic_name}"
    local epic_number
    epic_number=$(create_issue "$epic_key" "(Epic) ${epic_short}" "$epic_md" \
      "epic" "$epic_hier_label")
    epic_count=$((epic_count + 1))

    while IFS= read -r story_dir; do
      local story_name story_hier_label
      story_name=$(basename "$story_dir")
      [ ! -d "$story_dir" ] || [[ "$story_name" == .* ]] && continue

      local story_md="${story_dir}/story.md"
      [ ! -f "$story_md" ] && continue

      story_hier_label="ストーリー#${story_name}"
      ensure_label "$story_hier_label" "e4e669" "Story: ${story_name}"

      # ── Story issue → Epic の子に ──
      local story_key="story::${epic_name}::${story_name}"
      local story_number
      story_number=$(create_issue "$story_key" "${story_name}" "$story_md" \
        "story" "$epic_hier_label" "$story_hier_label")
      story_count=$((story_count + 1))

      # Epic → Story の親子リンク
      link_sub_issue "$epic_number" "$story_number"

      while IFS= read -r task_file; do
        local task_name task_short
        task_name=$(basename "$task_file" .md)
        task_short=$(strip_number_prefix "$task_name")

        # ── Task issue → Story の子に ──
        local task_key="task::${epic_name}::${story_name}::${task_name}"
        local task_number
        task_number=$(create_issue "$task_key" "(Task) ${task_short}" "$task_file" \
          "task" "$epic_hier_label" "$story_hier_label")
        task_count=$((task_count + 1))

        # Story → Task の親子リンク
        link_sub_issue "$story_number" "$task_number"

      done < <(find "$story_dir" -maxdepth 1 -name "(TASK)*.md" | sort)

    done < <(find "$epic_dir" -maxdepth 1 -mindepth 1 -type d | sort)

  done < <(find "$ISSUES_DIR" -maxdepth 1 -mindepth 1 -type d | sort)

  echo "" >&2
  log_info "────────────────────────────────"
  log_info "Complete!"
  log_info "  Epics:   ${epic_count}"
  log_info "  Stories: ${story_count}"
  log_info "  Tasks:   ${task_count}"
  log_info "  Total:   $((epic_count + story_count + task_count))"
  log_info "Mapping:   ${MAPPING_FILE}"
}

main "$@"
