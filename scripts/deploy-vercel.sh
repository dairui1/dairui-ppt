#!/usr/bin/env bash
# deploy-vercel.sh — Deploy a deck to Vercel as a static project.
#
# Usage:
#   bash scripts/deploy-vercel.sh <path-to-folder-or-html> [--prod] [--name <project-name>]
#
# Notes:
#   - If you pass a single .html file, it's wrapped into a temp folder before deploy.
#   - First run will trigger Vercel CLI login (interactive).
#   - Default deploys to a preview URL; pass --prod for production alias.

set -euo pipefail

TARGET=""
PROD=0
NAME=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --prod)        PROD=1; shift ;;
    --name)        NAME="${2:-}"; shift 2 ;;
    -h|--help)
      grep -E '^# ' "$0" | sed 's/^# //'
      exit 0 ;;
    *)
      if [[ -z "$TARGET" ]]; then TARGET="$1"; shift
      else echo "✗ 未知参数: $1" >&2; exit 1
      fi ;;
  esac
done

if [[ -z "$TARGET" ]]; then
  echo "✗ 缺少参数：deck 文件或文件夹路径" >&2
  echo "  用法: bash scripts/deploy-vercel.sh <deck.html or folder> [--prod] [--name <project-name>]" >&2
  exit 1
fi

# Vercel CLI check
if ! command -v npx >/dev/null 2>&1; then
  echo "✗ 找不到 npx。先装 Node.js:" >&2
  echo "    macOS:    brew install node" >&2
  echo "    其他:     https://nodejs.org" >&2
  exit 2
fi

# Resolve target → deploy directory
DEPLOY_DIR=""
CLEANUP_TMP=0

if [[ -d "$TARGET" ]]; then
  DEPLOY_DIR="$TARGET"
  if [[ ! -f "$DEPLOY_DIR/index.html" ]]; then
    echo "✗ 文件夹里没有 index.html: $DEPLOY_DIR" >&2
    exit 3
  fi
elif [[ -f "$TARGET" && "$TARGET" == *.html ]]; then
  # 包成临时目录
  DEPLOY_DIR="$(mktemp -d -t dairui-deck-XXXXXX)"
  CLEANUP_TMP=1
  cp "$TARGET" "$DEPLOY_DIR/index.html"
  # 如果同目录有 images/ 或 assets/，也带上
  SRC_DIR="$(dirname "$TARGET")"
  for sub in images assets; do
    if [[ -d "$SRC_DIR/$sub" ]]; then
      cp -R "$SRC_DIR/$sub" "$DEPLOY_DIR/"
    fi
  done
  echo "ℹ 已把 $TARGET 包到临时目录: $DEPLOY_DIR"
else
  echo "✗ 路径既不是文件夹，也不是 .html 文件: $TARGET" >&2
  exit 4
fi

# 默认 project name 从 deck title 提取，再 fallback 到目录名
if [[ -z "$NAME" ]]; then
  EXTRACTED="$(grep -oE '<title>[^<]*</title>' "$DEPLOY_DIR/index.html" 2>/dev/null | head -1 | sed -E 's/<\/?title>//g' | tr ' ' '-' | tr -cd 'A-Za-z0-9一-龥_-' | head -c 40)"
  if [[ -n "$EXTRACTED" && "$EXTRACTED" != *"必填"* ]]; then
    NAME="$EXTRACTED"
  else
    NAME="$(basename "$DEPLOY_DIR" | tr -cd 'A-Za-z0-9_-')"
  fi
  # 全部 lower-case，Vercel 项目名约束
  NAME="$(echo "$NAME" | tr 'A-Z' 'a-z')"
fi

# 写一个最小 vercel.json 让它当 static project（如果还没有）
if [[ ! -f "$DEPLOY_DIR/vercel.json" ]]; then
  cat > "$DEPLOY_DIR/vercel.json" <<'JSON'
{
  "cleanUrls": true,
  "trailingSlash": false
}
JSON
fi

echo ""
echo "═══════════════════════════════════════"
echo "  Vercel · 部署 dairui-ppt deck"
echo "═══════════════════════════════════════"
echo "  目录:  $DEPLOY_DIR"
echo "  项目:  $NAME"
echo "  模式:  $([ $PROD -eq 1 ] && echo production || echo preview)"
echo "═══════════════════════════════════════"
echo ""

cd "$DEPLOY_DIR"

# 首次会触发 login（交互式）
ARGS=(deploy --yes --name "$NAME")
[[ $PROD -eq 1 ]] && ARGS+=(--prod)

set +e
npx --yes vercel "${ARGS[@]}"
RC=$?
set -e

if [[ $CLEANUP_TMP -eq 1 ]]; then
  echo "ℹ 清理临时目录: $DEPLOY_DIR"
  rm -rf "$DEPLOY_DIR"
fi

if [[ $RC -ne 0 ]]; then
  echo "" >&2
  echo "✗ Vercel 部署失败 (exit $RC)" >&2
  echo "  常见原因:" >&2
  echo "    · 未登录:   npx vercel login" >&2
  echo "    · 项目名冲突:  --name 换一个" >&2
  exit $RC
fi

echo ""
echo "✓ 部署完成。Preview/Prod URL 已打印在上方。"
