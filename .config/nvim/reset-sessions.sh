#!/usr/bin/env bash
# Shatur/neovim-session-manager のセッションを /tmp に退避する (削除ではなく移動)

set -euo pipefail
shopt -s nullglob

SESSION_DIR="${HOME}/.local/share/nvim/sessions"
BACKUP_DIR="/tmp/nvim-sessions-backup-$(date +%Y%m%d-%H%M%S)"

if [[ ! -d "$SESSION_DIR" ]]; then
  echo "セッションディレクトリが存在しません: $SESSION_DIR"
  exit 0
fi

files=("$SESSION_DIR"/*)

if (( ${#files[@]} == 0 )); then
  echo "退避対象のセッションファイルはありません。"
  exit 0
fi

mkdir -p "$BACKUP_DIR"
mv "${files[@]}" "$BACKUP_DIR/"

echo "${#files[@]} 件のセッションを退避しました:"
echo "  from: $SESSION_DIR"
echo "  to:   $BACKUP_DIR"
