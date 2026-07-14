#!/bin/bash
# Read session data from stdin
input=$(cat)

# Debug: dump input to see what Claude Code sends
echo "$input" > /tmp/statusline_debug.json

if command -v jq >/dev/null 2>&1; then
  # Parse ONLY valid JSON part from input (in case of update warnings or garbage text)
  clean_input=$(echo "$input" | grep -o '{.*}' | head -n 1)
  if [ -z "$clean_input" ]; then
    clean_input="$input"
  fi

  # Extract values safely. Avoid fetching the whole object.
  MODEL=$(echo "$clean_input" | jq -r '.model.display_name // .model.id // .model // "unknown"' 2>/dev/null)
  PCT=$(echo "$clean_input" | jq -r '.context_window.used_percentage // 0' 2>/dev/null)
  SIZE=$(echo "$clean_input" | jq -r '.context_window.context_window_size // 0' 2>/dev/null)
  
  # Target the active session cost instead of the cumulative overall cost
  COST=$(echo "$clean_input" | jq -r '.cost.session_cost_usd // .cost.current // 0' 2>/dev/null)

  # Format model name (remove prefix path if any)
  MODEL_NAME=$(basename "$MODEL")

  # Calculate tokens
  USED_TOKENS=$(echo "scale=1; $SIZE * $PCT / 100" | bc -l 2>/dev/null | cut -d. -f1)
  
  if [ -z "$USED_TOKENS" ] || [ "$USED_TOKENS" = "0" ]; then
    USED_TOKENS=0
  fi

  # Format numbers to "k"
  if [ $USED_TOKENS -ge 1000 ]; then
    USED_K=$(echo "scale=1; $USED_TOKENS / 1000" | bc -l 2>/dev/null)
    USED_K_FORMATTED=$(printf "%.1fk" "$USED_K")
  else
    USED_K_FORMATTED="${USED_TOKENS}"
  fi

  if [ $SIZE -ge 1000 ]; then
    SIZE_K=$(echo "$SIZE / 1000" | bc 2>/dev/null)
    SIZE_K_FORMATTED="${SIZE_K}k"
  else
    SIZE_K_FORMATTED="${SIZE}"
  fi

  # Format cost to 2 decimal places safely. Verify if it is a number.
  if [[ "$COST" =~ ^[0-9\.]+$ ]]; then
    COST_FORMATTED=$(printf "%.2f" "$COST" 2>/dev/null)
  else
    COST_FORMATTED="0.00"
  fi

  # Render output
  echo "$MODEL_NAME | Context: $USED_K_FORMATTED / $SIZE_K_FORMATTED | Cost: \$${COST_FORMATTED}"
else
  # Minimal fallback
  PCT=$(echo "$input" | grep -o '"used_percentage":[0-9\.]*' | cut -d: -f2)
  MODEL=$(echo "$input" | grep -o '"display_name":"[^"]*"' | cut -d: -f2 | tr -d '"')
  echo "${MODEL:-Model} | Context: ${PCT:-0}%"
fi
