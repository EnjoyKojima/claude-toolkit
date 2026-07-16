#!/bin/bash
# Claude Code statusline インストーラー
# - statusline-command.sh を ~/.claude/ にコピー（curl 実行時はGitHubから取得）
# - ~/.claude/settings.json に statusLine 設定をマージ
#
# 使い方:
#   ローカル: bash statusline/install.sh
#   リモート: curl -fsSL https://raw.githubusercontent.com/EnjoyKojima/claude-toolkit/master/statusline/install.sh | bash
set -euo pipefail

RAW_BASE="https://raw.githubusercontent.com/EnjoyKojima/claude-toolkit/master/statusline"
CLAUDE_DIR="$HOME/.claude"
SETTINGS="$CLAUDE_DIR/settings.json"
DEST="$CLAUDE_DIR/statusline-command.sh"

if ! command -v jq >/dev/null 2>&1; then
  echo "❌ jq が必要です。先にインストールしてください（macOS: brew install jq）" >&2
  exit 1
fi

mkdir -p "$CLAUDE_DIR"

# ローカルにスクリプトがあればコピー、なければ（curl | bash 実行時）GitHubから取得
script_dir=$(cd "$(dirname "${BASH_SOURCE[0]:-.}")" 2>/dev/null && pwd || echo "")
if [ -n "$script_dir" ] && [ -f "$script_dir/statusline-command.sh" ]; then
  cp "$script_dir/statusline-command.sh" "$DEST"
else
  curl -fsSL "$RAW_BASE/statusline-command.sh" -o "$DEST"
fi
chmod +x "$DEST"

# settings.json に statusLine をマージ（他の設定は保持）
[ -f "$SETTINGS" ] || echo '{}' > "$SETTINGS"
tmp=$(mktemp)
jq '.statusLine = {"type": "command", "command": "bash ~/.claude/statusline-command.sh"}' "$SETTINGS" > "$tmp"
mv "$tmp" "$SETTINGS"

echo "✅ statusline をインストールしました: $DEST"
echo "   Claude Code を再起動（または新しいセッションを開始）すると反映されます。"
