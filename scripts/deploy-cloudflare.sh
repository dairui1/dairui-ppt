#!/usr/bin/env bash
# deploy-cloudflare.sh — Deploy a deck to Cloudflare Workers under ppt.dairui1.com
#
# Usage:
#   bash scripts/deploy-cloudflare.sh <path-to-folder-or-html> [--slug <slug>] [--domain <root-domain>] [--zone <zone-name>]
#
# Each deck becomes its own Worker named `ppt-<slug>` with a route at
#   <root-domain>/<slug>/*
# By default root-domain = ppt.dairui1.com and zone = dairui1.com.
#
# Final URL:    https://ppt.dairui1.com/<slug>/
#
# Requirements:
#   · npx (Node.js)
#   · `wrangler login` 一次（首次跑会自动触发）
#   · Cloudflare 账号下已经把 dairui1.com 接入；ppt.dairui1.com 已有 DNS 指向 Workers
#     （Cloudflare 后台 → Workers → Custom Domains 加 ppt.dairui1.com 即可）

set -euo pipefail

TARGET=""
SLUG=""
DOMAIN="ppt.dairui1.com"
ZONE="dairui1.com"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --slug)   SLUG="${2:-}"; shift 2 ;;
    --domain) DOMAIN="${2:-}"; shift 2 ;;
    --zone)   ZONE="${2:-}"; shift 2 ;;
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
  echo "  用法: bash scripts/deploy-cloudflare.sh <deck.html or folder> [--slug <slug>] [--domain ppt.dairui1.com] [--zone dairui1.com]" >&2
  exit 1
fi

if ! command -v npx >/dev/null 2>&1; then
  echo "✗ 找不到 npx。先装 Node.js (brew install node)" >&2
  exit 2
fi

# 解析源 deck
SRC_INDEX=""
SRC_DIR=""
if [[ -d "$TARGET" ]]; then
  if [[ ! -f "$TARGET/index.html" ]]; then
    echo "✗ 文件夹里没有 index.html: $TARGET" >&2; exit 3
  fi
  SRC_INDEX="$TARGET/index.html"
  SRC_DIR="$TARGET"
elif [[ -f "$TARGET" && "$TARGET" == *.html ]]; then
  SRC_INDEX="$TARGET"
  SRC_DIR="$(dirname "$TARGET")"
else
  echo "✗ 路径既不是文件夹，也不是 .html: $TARGET" >&2; exit 4
fi

# slug：用户给了就用，否则从 title 提取，再 fallback 到文件名
if [[ -z "$SLUG" ]]; then
  EXTRACTED="$(grep -oE '<title>[^<]*</title>' "$SRC_INDEX" 2>/dev/null | head -1 | sed -E 's/<\/?title>//g')"
  if [[ -n "$EXTRACTED" && "$EXTRACTED" != *"必填"* ]]; then
    # 提取主标题里的拉丁字符或中文，转 kebab
    SLUG="$(echo "$EXTRACTED" | tr ' ' '-' | tr -cd 'A-Za-z0-9一-龥_-' | head -c 40 | tr 'A-Z' 'a-z')"
  fi
  if [[ -z "$SLUG" ]]; then
    BASE="$(basename "$SRC_DIR")"
    [[ "$BASE" == "." || -z "$BASE" ]] && BASE="$(basename "$SRC_INDEX" .html)"
    SLUG="$(echo "$BASE" | tr 'A-Z' 'a-z' | tr -cd 'a-z0-9-')"
  fi
fi

if [[ -z "$SLUG" ]]; then
  echo "✗ 无法推断 slug，请用 --slug <name> 显式指定" >&2; exit 5
fi

WORKER_NAME="ppt-${SLUG}"

echo ""
echo "═══════════════════════════════════════"
echo "  Cloudflare Workers · 部署 dairui-ppt"
echo "═══════════════════════════════════════"
echo "  Slug:    ${SLUG}"
echo "  Worker:  ${WORKER_NAME}"
echo "  Domain:  ${DOMAIN}"
echo "  Zone:    ${ZONE}"
echo "  URL:     https://${DOMAIN}/${SLUG}/"
echo "═══════════════════════════════════════"
echo ""

# 临时工作目录：assets/{slug}/index.html，让 URL 路径和文件结构对齐
WORK_DIR="$(mktemp -d -t dairui-cf-XXXXXX)"
trap 'rm -rf "$WORK_DIR"' EXIT

mkdir -p "$WORK_DIR/assets/$SLUG"
cp "$SRC_INDEX" "$WORK_DIR/assets/$SLUG/index.html"
# 带上同目录下的 images / assets 子目录
for sub in images assets; do
  if [[ -d "$SRC_DIR/$sub" ]]; then
    cp -R "$SRC_DIR/$sub" "$WORK_DIR/assets/$SLUG/"
  fi
done

# 生成 wrangler.toml
cat > "$WORK_DIR/wrangler.toml" <<TOML
name = "${WORKER_NAME}"
compatibility_date = "2025-05-01"

[assets]
directory = "./assets"
not_found_handling = "404-page"

routes = [
  { pattern = "${DOMAIN}/${SLUG}", zone_name = "${ZONE}" },
  { pattern = "${DOMAIN}/${SLUG}/*", zone_name = "${ZONE}" }
]
TOML

echo "ℹ 临时工作目录: $WORK_DIR"
echo ""

cd "$WORK_DIR"

# 首次跑会触发 wrangler login
set +e
npx --yes wrangler deploy
RC=$?
set -e

if [[ $RC -ne 0 ]]; then
  echo "" >&2
  echo "✗ Cloudflare 部署失败 (exit $RC)" >&2
  echo "  常见原因:" >&2
  echo "    · 未登录:        npx wrangler login" >&2
  echo "    · zone 错:       --zone <root-domain>" >&2
  echo "    · 没接入 Workers:  Cloudflare 后台 → Workers → Custom Domains 加 ${DOMAIN}" >&2
  echo "    · Worker 名冲突: --slug <other>" >&2
  exit $RC
fi

echo ""
echo "═══════════════════════════════════════"
echo "✓ 部署完成"
echo "  访问:   https://${DOMAIN}/${SLUG}/"
echo "  管理:   https://dash.cloudflare.com → Workers → ${WORKER_NAME}"
echo "  删除:   npx wrangler delete --name ${WORKER_NAME}"
echo "═══════════════════════════════════════"
