#!/bin/bash
# Description: macOS native notification using terminal-notifier/osascript for Antigravity/Claude Code hooks
# Location: ~/.config/ghostty/terminal-notify.sh

LOG_FILE="/tmp/terminal-notify.log"
echo "=== Antigravity Notification Triggered at $(date) ===" >> "$LOG_FILE"
echo "Arguments: $@" >> "$LOG_FILE"

# デフォルト設定
SUBTITLE=""
MESSAGE=""
TITLE="Antigravity / Claude Code"

# 標準入力からJSONデータを受け取る場合（フックからの詳細情報）
if [ ! -t 0 ]; then
  INPUT=$(cat)
  echo "Input JSON: $INPUT" >> "$LOG_FILE"
  if command -v jq >/dev/null 2>&1; then
    # Claude Code と Antigravity 両方のスキーマに対応
    TOOL_NAME=$(echo "$INPUT" | jq -r '.tool // .tool_name // empty')
    EVENT_NAME=$(echo "$INPUT" | jq -r '.event // .notification_type // empty')
    MSG_TEXT=$(echo "$INPUT" | jq -r '.message // empty')

    # 詳細情報のパース
    DETAIL_TYPE=$(echo "$INPUT" | jq -r '.details.type // empty')
    DETAIL_CMD=$(echo "$INPUT" | jq -r '.details.command // empty')

    echo "Parsed: TOOL_NAME='$TOOL_NAME', EVENT_NAME='$EVENT_NAME', DETAIL_TYPE='$DETAIL_TYPE', DETAIL_CMD='$DETAIL_CMD'" >> "$LOG_FILE"

    # メッセージのマッピング
    if [ -n "$TOOL_NAME" ]; then
      SUBTITLE="🔒 ツール実行許可待ち"
      MESSAGE="Tool: $TOOL_NAME"
    elif [ "$EVENT_NAME" = "ToolPermission" ] && [ "$DETAIL_TYPE" = "exec" ]; then
      SUBTITLE="⚠️ コマンド実行の確認"
      MESSAGE="Command: $DETAIL_CMD"
    elif [ "$EVENT_NAME" = "ToolPermission" ] && [ "$DETAIL_TYPE" = "ask_user" ]; then
      SUBTITLE="💬 エージェントから質問"
      MESSAGE="エージェントが質問しています"
    elif [ "$EVENT_NAME" = "ToolPermission" ]; then
      SUBTITLE="🔒 許可が必要です"
      MESSAGE="${MSG_TEXT:-操作の承認を待っています}"
    elif [ "$EVENT_NAME" = "permission_prompt" ]; then
      SUBTITLE="🔒 許可待ち"
      MESSAGE="アクションの承認を待っています"
    elif [ "$EVENT_NAME" = "idle_prompt" ] || [ "$EVENT_NAME" = "UserPrompt" ]; then
      SUBTITLE="⌛ 入力待ち"
      MESSAGE="返答をお待ちしています..."
    elif [ "$EVENT_NAME" = "stop" ] || [ "$EVENT_NAME" = "AfterAgent" ]; then
      SUBTITLE="✅ タスク完了"
      MESSAGE="すべての操作が正常に完了しました"
    elif [ -n "$EVENT_NAME" ]; then
      SUBTITLE="ステータス: $EVENT_NAME"
      MESSAGE="${MSG_TEXT:-}"
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
