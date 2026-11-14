#!/usr/bin/env bash
# check-privacy.sh — static privacy scan for a MindVault export
#
# Generic high-risk patterns (phone, ID, tokens) live in this script and are
# safe to ship. Instance-specific names, paths and identifiers must go in a
# private blocklist that is never exported:
#   20-CRM/Context/privacy-blocklist.txt
#   or --blocklist PATH
#   or $MINDVAULT_PRIVACY_BLOCKLIST
#
# Usage:
#   ./check-privacy.sh [--blocklist PATH] [TARGET_DIR]
# Exit codes:
#   0: no findings
#   1: possible sensitive terms found
#   2: usage error

set -euo pipefail

BLOCKLIST="${MINDVAULT_PRIVACY_BLOCKLIST:-}"
TARGET_DIR=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --blocklist)
      if [[ $# -lt 2 ]]; then
        echo "usage: $0 [--blocklist PATH] [TARGET_DIR]" >&2
        exit 2
      fi
      BLOCKLIST="$2"
      shift 2
      ;;
    -h|--help)
      echo "usage: $0 [--blocklist PATH] [TARGET_DIR]"
      exit 0
      ;;
    --)
      shift
      break
      ;;
    -*)
      echo "unknown option: $1" >&2
      exit 2
      ;;
    *)
      if [[ -n "$TARGET_DIR" ]]; then
        echo "usage: $0 [--blocklist PATH] [TARGET_DIR]" >&2
        exit 2
      fi
      TARGET_DIR="$1"
      shift
      ;;
  esac
done

TARGET_DIR="${TARGET_DIR:-.}"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

if [[ -z "$BLOCKLIST" ]]; then
  for cand in \
    "$SCRIPT_DIR/../../20-CRM/Context/privacy-blocklist.txt" \
    "$SCRIPT_DIR/privacy-blocklist.txt"; do
    if [[ -f "$cand" ]]; then
      BLOCKLIST="$cand"
      break
    fi
  done
fi

exec python3 - "$TARGET_DIR" "$BLOCKLIST" <<'PYSCAN'

import os
import re
import sys
from pathlib import Path

target_dir = sys.argv[1] if len(sys.argv) > 1 and sys.argv[1] else "."
blocklist_path = sys.argv[2] if len(sys.argv) > 2 else ""

# Generic patterns only. Instance-specific terms come from the blocklist.
REGEX_PATTERNS = [
    (r"\b1[3-9]\d{9}\b", "疑似中国手机号 (11位)"),
    (r"\b[1-9]\d{5}(?:19|20)\d{2}(?:0[1-9]|1[0-2])(?:0[1-9]|[12]\d|3[01])\d{3}[\dXx]\b", "疑似18位身份证号"),
    (r"sk-[a-zA-Z0-9_-]{20,}", "疑似 API Key / Token (sk-...)"),
    (r"ghp_[a-zA-Z0-9]{36}", "疑似 GitHub Personal Access Token"),
    (r"ou_[a-f0-9]{32}", "疑似飞书用户 Open ID (ou_...)"),
    (r"cli_[a-z0-9]{16}", "疑似飞书应用 App ID (cli_...)")
]

IGNORE_DIRS = {".git", ".obsidian", ".trash", "node_modules", "__pycache__"}
IGNORE_EXTS = {".png", ".jpg", ".jpeg", ".pdf", ".docx", ".pptx", ".xlsx", ".tar", ".gz", ".zip"}
SKIP_FILENAMES = {"privacy-blocklist.txt"}

def load_blocklist(path: str):
    if not path:
        return []
    p = Path(path)
    if not p.is_file():
        print(f"blocklist not found: {path}", file=sys.stderr)
        sys.exit(2)
    terms = []
    for raw in p.read_text(encoding="utf-8", errors="ignore").splitlines():
        line = raw.strip()
        if not line or line.startswith("#"):
            continue
        terms.append(line)
    return terms

FORBIDDEN_KEYWORDS = load_blocklist(blocklist_path)
violations = []

def scan_file(file_path: str) -> None:
    name = os.path.basename(file_path)
    if name in SKIP_FILENAMES:
        return
    try:
        with open(file_path, "r", encoding="utf-8", errors="ignore") as f:
            lines = f.readlines()
    except OSError:
        return

    for line_idx, line in enumerate(lines, 1):
        for kw in FORBIDDEN_KEYWORDS:
            if kw and kw in line:
                violations.append((file_path, line_idx, "blocklist keyword", line.strip()[:100]))
        for pattern, desc in REGEX_PATTERNS:
            if re.search(pattern, line):
                if "example" in line.lower() or "示例" in line:
                    continue
                violations.append((file_path, line_idx, f"pattern: {desc}", line.strip()[:100]))

if os.path.isfile(target_dir):
    scan_file(target_dir)
else:
    for root, dirs, files in os.walk(target_dir):
        dirs[:] = [d for d in dirs if d not in IGNORE_DIRS]
        for file in files:
            ext = os.path.splitext(file)[1].lower()
            if ext in IGNORE_EXTS or file.startswith("."):
                continue
            scan_file(os.path.join(root, file))

loaded = len(FORBIDDEN_KEYWORDS)
src = blocklist_path or "(none)"
if violations:
    print(f"FAIL: {len(violations)} finding(s); blocklist terms loaded: {loaded} from {src}")
    for path, line_no, reason, snippet in violations:
        print(f"  {path}:{line_no}: {reason}: {snippet}")
    sys.exit(1)

print(f"OK: no findings in {target_dir}; blocklist terms loaded: {loaded} from {src}")
sys.exit(0)
PYSCAN
