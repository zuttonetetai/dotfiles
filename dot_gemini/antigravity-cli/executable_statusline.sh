#!/usr/bin/env bash

# 標準入力から JSON を読み込み
raw_input=$(cat)
if [ -z "$raw_input" ]; then
  raw_input="{}"
fi

# トラブルシューティング用に最新の入力 JSON を保存
echo "$raw_input" > "$HOME/.gemini/antigravity-cli/scratch/last_statusline_input.json" 2>/dev/null

# 1. カレントディレクトリの取得
cwd=$(echo "$raw_input" | jq -r '.workspace.current_dir // .cwd // ""' 2>/dev/null)
if [ -z "$cwd" ] || [ "$cwd" = "null" ]; then
  cwd="$(pwd)"
fi

# 2. モデル名の取得 (display_name を抽出)
model=$(echo "$raw_input" | jq -r '
  if (.model | type) == "object" then
    (.model.display_name // .model.id // .model.name // "Unknown")
  else
    (.model // "Unknown")
  end
' 2>/dev/null)
if [ -z "$model" ] || [ "$model" = "null" ]; then
  model="Unknown"
fi

# 3. コンテキスト利用率 (%) の取得
context_val=$(echo "$raw_input" | jq -r '.context_window.used_percentage // .context_window.used_percent // 0' 2>/dev/null)
context_pct=$(awk -v c="$context_val" 'BEGIN { printf "%.0f", c }')

# 4. モデルに応じて 5時間 quota キーを選択
#    - model.id に "claude" (case-insensitive) が含まれる → "3p-5h"
#    - それ以外 (Gemini 等)                              → "gemini-5h"
model_id=$(echo "$raw_input" | jq -r '
  if (.model | type) == "object" then .model.id else (.model // "") end
' 2>/dev/null | tr '[:upper:]' '[:lower:]')

if echo "$model_id" | grep -qi "claude"; then
  quota_key="3p-5h"
else
  quota_key="gemini-5h"
fi

rem_frac=$(echo "$raw_input" | jq -r --arg k "$quota_key" '.quota[$k].remaining_fraction // 1' 2>/dev/null)
reset_sec=$(echo "$raw_input" | jq -r --arg k "$quota_key" '.quota[$k].reset_in_seconds // 0' 2>/dev/null)

if [ -z "$rem_frac" ] || [ "$rem_frac" = "null" ]; then rem_frac="1"; fi
if [ -z "$reset_sec" ] || [ "$reset_sec" = "null" ]; then reset_sec="0"; fi

# 使用率 (Used %) を計算
cost_used_pct=$(awk -v r="$rem_frac" 'BEGIN { printf "%.0f", (1 - r) * 100 }')

# リフレッシュまでの時間フォーマット
time_str=""
if [ "$reset_sec" -gt 0 ] 2>/dev/null; then
  time_fmt=$(awk -v s="$reset_sec" 'BEGIN {
    h = int(s / 3600);
    m = int((s % 3600) / 60);
    if (h > 0) { printf "%dh %dm", h, m; } else { printf "%dm", m; }
  }')
  time_str=" (resets in ${time_fmt})"
fi

# ANSI カラーコードの定義
RESET="\033[0m"
BOLD="\033[1m"
CYAN="\033[36m"
BLUE="\033[34m"
GREEN="\033[32m"
YELLOW="\033[33m"

# 一行目: カレントディレクトリ
echo -e "${CYAN}📁 Dir:${RESET} ${cwd}"

# 二行目: モデル名 | コンテキスト利用率 | 5時間リミット利用率 (解除までの時間)
echo -e "${BOLD}🤖 Model:${RESET} ${BLUE}${model}${RESET} | ${BOLD}🧠 Context:${RESET} ${GREEN}${context_pct}%${RESET} | ${BOLD}💳 Cost (5h):${RESET} ${YELLOW}${cost_used_pct}%${time_str}${RESET}"
