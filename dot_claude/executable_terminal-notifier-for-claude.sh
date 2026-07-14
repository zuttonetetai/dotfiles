#!/bin/bash
# Description: macOS native notification using terminal-notifier/osascript for Claude Code hooks
# Location: ~/.config/ghostty/terminal-notifier-for-claude.sh

LOG_FILE="/tmp/terminal-notify-claude.log"
echo "=== Claude Code Notification Triggered at $(date) ===" >> "$LOG_FILE"
echo "Arguments: $@" >> "$LOG_FILE"

# デフォルト設定
SUBTITLE=""
MESSAGE=""
TITLE="Claude Code"

# 標準入力からJSONデータを受け取る場合（フックからの詳細情報）
if [ ! -t 0 ]; then
  INPUT=$(cat)
  echo "Input JSON: $INPUT" >> "$LOG_FILE"
  if command -v jq >/dev/null 2>&1; then
    # Claude Code フックのスキーマに対応
    # Notification フック: { "message": "...", "title": "..." } など
    # Stop フック: { "stop_hook_active": bool } など
    HOOK_TYPE=$(echo "$INPUT" | jq -r '.hook_event_name // empty')
    TOOL_NAME=$(echo "$INPUT" | jq -r '.tool_name // empty')
    MSG_TEXT=$(echo "$INPUT" | jq -r '.message // empty')

    echo "Parsed: HOOK_TYPE='$HOOK_TYPE', TOOL_NAME='$TOOL_NAME', MSG_TEXT='$MSG_TEXT'" >> "$LOG_FILE"

    if [ "$HOOK_TYPE" = "Notification" ]; then
      # claude code の通知フック
      SUBTITLE="💬 通知"
      MESSAGE="${MSG_TEXT:-エージェントからの通知があります}"
    elif [ "$HOOK_TYPE" = "Stop" ]; then
      SUBTITLE="✅ タスク完了"
      MESSAGE="すべての操作が正常に完了しました"
    elif [ "$HOOK_TYPE" = "PreToolUse" ]; then
      if [ -n "$TOOL_NAME" ]; then
        SUBTITLE="🔒 ツール実行許可待ち"
        MESSAGE="Tool: $TOOL_NAME"
      else
        SUBTITLE="🔒 許可が必要です"
        MESSAGE="操作の承認を待っています"
      fi
    elif [ "$HOOK_TYPE" = "PostToolUse" ]; then
      SUBTITLE="🔧 ツール実行完了"
      MESSAGE="${TOOL_NAME:+Tool: $TOOL_NAME}${TOOL_NAME:-操作が完了しました}"
    elif [ -n "$MSG_TEXT" ]; then
      # hook_event_name がない場合でも message があれば通知（Notificationフック互換）
      SUBTITLE="💬 通知"
      MESSAGE="$MSG_TEXT"
    elif [ -n "$TOOL_NAME" ]; then
      SUBTITLE="🔒 ツール実行許可待ち"
      MESSAGE="Tool: $TOOL_NAME"
    fi
  fi
fi

echo "Final SUBTITLE: $SUBTITLE, MESSAGE: $MESSAGE, TITLE: $TITLE" >> "$LOG_FILE"

# SUBTITLE もしくは MESSAGE が設定されていない場合は通知せずに終了
if [ -z "$SUBTITLE" ] || [ -z "$MESSAGE" ]; then
  echo "Notification skipped: No matching condition." >> "$LOG_FILE"
  echo "========================================" >> "$LOG_FILE"
  exit 0
fi

# terminal-notifier による通知（クリックでGhosttyへフォーカス）
if command -v terminal-notifier >/dev/null 2>&1; then
  terminal-notifier \
    -title "$TITLE" \
    -subtitle "$SUBTITLE" \
    -message "$MESSAGE" \
    -activate com.mitchellh.ghostty \
    -sound default >> "$LOG_FILE" 2>&1
else
  # fallback: osascript
  osascript -e "display notification \"$MESSAGE\" with title \"$TITLE\" subtitle \"$SUBTITLE\"" >> "$LOG_FILE" 2>&1
fi

echo "========================================" >> "$LOG_FILE"
