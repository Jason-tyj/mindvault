#!/usr/bin/env bash
# sync-agents-md.sh — 从 CLAUDE.md 生成 AGENTS.md
#
# CLAUDE.md 是唯一真源；AGENTS.md 是派生产物，请勿手改。
# 二者仅开头两处不同：H1 标题、第 3 行工具描述；其余正文完全一致。
#
# 用法：
#   sync-agents-md.sh          # 生成 / 覆盖 AGENTS.md
#   sync-agents-md.sh --check  # 只校验一致性，不写入；漂移则退出码 1（供周巡检只读兜底用）
set -euo pipefail

VAULT="$(cd "$(dirname "$0")/../.." && pwd)"
SRC="$VAULT/CLAUDE.md"
DST="$VAULT/AGENTS.md"

# 渲染：复制 CLAUDE.md 正文，仅替换标题行与工具描述行
render() {
  sed -e '1s|^# CLAUDE\.md.*|# AGENTS.md|' \
      -e 's|^This file provides guidance to Claude Code.*|This file provides guidance to Codex when working with code in this repository.|' \
      "$SRC"
}

if [[ "${1:-}" == "--check" ]]; then
  if diff -q <(render) "$DST" >/dev/null 2>&1; then
    echo "OK: AGENTS.md 与 CLAUDE.md 一致"
    exit 0
  else
    echo "DRIFT: AGENTS.md 与 CLAUDE.md 不一致（运行 sync-agents-md.sh 无参数可修复）"
    exit 1
  fi
fi

render > "$DST"
echo "已从 CLAUDE.md 生成 AGENTS.md（真源：CLAUDE.md）"
