#!/usr/bin/env bash
# deploy-cloudflare.sh — Deploy a deck to Cloudflare Workers under ppt.dairui1.com
#
# Usage:
#   bash scripts/deploy-cloudflare.sh <path-to-folder-or-html> [--slug <slug>] [--domain <hostname>] [--zone <zone-name>] [--dry-run]
#
# Each deck becomes its own Worker named `ppt-<slug>` with routes at
#   <hostname>/<slug> and <hostname>/<slug>/*
# By default domain = ppt.dairui1.com and zone = dairui1.com.
#
# Final URL:    https://ppt.dairui1.com/<slug>/
#
# Requirements:
#   · npx (Node.js)
#   · `wrangler login` 一次（首次跑会自动触发）
#   · Cloudflare 账号下已经把 dairui1.com 接入；ppt.dairui1.com 已有可被 Workers Route 匹配的橙云 DNS 记录

set -euo pipefail

TARGET=""
SLUG=""
DOMAIN="ppt.dairui1.com"
ZONE="dairui1.com"
COMPATIBILITY_DATE="$(date +%F)"
DRY_RUN=0
KEEP_WORKDIR=0

print_help() {
  cat <<'HELP'
deploy-cloudflare.sh — Deploy a deck to Cloudflare Workers under ppt.dairui1.com

Usage:
  bash scripts/deploy-cloudflare.sh <path-to-folder-or-html> [--slug <slug>] [--domain <hostname>] [--zone <zone-name>] [--dry-run]

Each deck becomes its own Worker named `ppt-<slug>` with routes at:
  <hostname>/<slug>
  <hostname>/<slug>/*

Defaults:
  --domain ppt.dairui1.com
  --zone dairui1.com

Options:
  --slug <slug>                    URL path and Worker suffix. ASCII lowercase is enforced.
  --domain <hostname>              Hostname for routes. Default: ppt.dairui1.com
  --zone <zone-name>               Cloudflare zone name. Default: dairui1.com
  --compatibility-date <date>      Wrangler compatibility date. Default: today.
  --dry-run                        Generate assets/config and run `wrangler deploy --dry-run`.
  --keep-workdir                   Do not delete the temporary work directory.

Requirements:
  npx / Node.js
  npx wrangler login
  A proxied DNS record or Worker Custom Domain for the hostname in the Cloudflare zone.
HELP
}

slugify() {
  printf '%s' "$1" \
    | LC_ALL=C tr '[:upper:]' '[:lower:]' \
    | LC_ALL=C sed -E 's/[[:space:]_]+/-/g; s/[^a-z0-9-]+/-/g; s/-+/-/g; s/^-+//; s/-+$//' \
    | LC_ALL=C cut -c 1-48 \
    | LC_ALL=C sed -E 's/-+$//'
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --slug)
      [[ $# -ge 2 && "$2" != --* ]] || { echo "✗ --slug 缺少值" >&2; exit 1; }
      SLUG="$2"; shift 2 ;;
    --domain)
      [[ $# -ge 2 && "$2" != --* ]] || { echo "✗ --domain 缺少值" >&2; exit 1; }
      DOMAIN="$2"; shift 2 ;;
    --zone)
      [[ $# -ge 2 && "$2" != --* ]] || { echo "✗ --zone 缺少值" >&2; exit 1; }
      ZONE="$2"; shift 2 ;;
    --compatibility-date)
      [[ $# -ge 2 && "$2" != --* ]] || { echo "✗ --compatibility-date 缺少值" >&2; exit 1; }
      COMPATIBILITY_DATE="$2"; shift 2 ;;
    --dry-run) DRY_RUN=1; shift ;;
    --keep-workdir) KEEP_WORKDIR=1; shift ;;
    -h|--help)
      print_help
      exit 0 ;;
    *)
      if [[ -z "$TARGET" ]]; then TARGET="$1"; shift
      else echo "✗ 未知参数: $1" >&2; exit 1
      fi ;;
  esac
done

if [[ -z "$TARGET" ]]; then
  echo "✗ 缺少参数：deck 文件或文件夹路径" >&2
  echo "  用法: bash scripts/deploy-cloudflare.sh <deck.html or folder> [--slug <slug>] [--domain ppt.dairui1.com] [--zone dairui1.com] [--dry-run]" >&2
  exit 1
fi

if [[ -z "$DOMAIN" || -z "$ZONE" ]]; then
  echo "✗ --domain 和 --zone 不能为空" >&2
  exit 1
fi

if [[ ! "$COMPATIBILITY_DATE" =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]]; then
  echo "✗ --compatibility-date 必须是 YYYY-MM-DD: $COMPATIBILITY_DATE" >&2
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
    SLUG="$(slugify "$EXTRACTED")"
  fi
  if [[ -z "$SLUG" ]]; then
    BASE="$(basename "$SRC_DIR")"
    [[ "$BASE" == "." || -z "$BASE" ]] && BASE="$(basename "$SRC_INDEX" .html)"
    SLUG="$(slugify "$BASE")"
  fi
else
  NORMALIZED_SLUG="$(slugify "$SLUG")"
  if [[ -z "$NORMALIZED_SLUG" ]]; then
    echo "✗ slug 规范化后为空，请使用小写英文、数字、短横线（例如 --slug q3-report）" >&2
    exit 5
  fi
  if [[ "$NORMALIZED_SLUG" != "$SLUG" ]]; then
    echo "ℹ 已规范化 slug: $SLUG → $NORMALIZED_SLUG"
  fi
  SLUG="$NORMALIZED_SLUG"
fi

if [[ -z "$SLUG" ]]; then
  echo "✗ 无法推断合法 slug，请用 --slug <ascii-name> 显式指定（例如 --slug q3-report）" >&2; exit 5
fi

if [[ ! "$SLUG" =~ ^[a-z0-9]([a-z0-9-]{0,46}[a-z0-9])?$ ]]; then
  echo "✗ slug 只能包含小写字母、数字、短横线，且不能以短横线开头或结尾: $SLUG" >&2
  exit 5
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
echo "  Compat:  ${COMPATIBILITY_DATE}"
echo "  Mode:    $([ $DRY_RUN -eq 1 ] && echo dry-run || echo deploy)"
echo "  URL:     https://${DOMAIN}/${SLUG}/"
echo "═══════════════════════════════════════"
echo ""

# 临时工作目录：assets/{slug}/index.html，让 URL 路径和文件结构对齐
WORK_DIR="$(mktemp -d -t dairui-cf-XXXXXX)"
if [[ $KEEP_WORKDIR -eq 0 ]]; then
  trap 'rm -rf "$WORK_DIR"' EXIT
else
  trap 'echo "ℹ 保留临时工作目录: $WORK_DIR"' EXIT
fi

mkdir -p "$WORK_DIR/assets/$SLUG"
cat > "$WORK_DIR/assets/.assetsignore" <<'IGNORE'
.DS_Store
**/.DS_Store
.git
.git/**
node_modules
node_modules/**
IGNORE

if [[ -d "$TARGET" ]]; then
  cp -R "$SRC_DIR"/. "$WORK_DIR/assets/$SLUG/"
else
  cp "$SRC_INDEX" "$WORK_DIR/assets/$SLUG/index.html"
  # 单 HTML 输入时只带上同目录下 deck 常用的相对资源目录，避免把项目根目录全量上传。
  for sub in images assets; do
    if [[ -d "$SRC_DIR/$sub" ]]; then
      cp -R "$SRC_DIR/$sub" "$WORK_DIR/assets/$SLUG/"
    fi
  done
fi

# 生成 wrangler.toml
cat > "$WORK_DIR/wrangler.toml" <<TOML
name = "${WORKER_NAME}"
compatibility_date = "${COMPATIBILITY_DATE}"
workers_dev = false

[[routes]]
pattern = "${DOMAIN}/${SLUG}"
zone_name = "${ZONE}"

[[routes]]
pattern = "${DOMAIN}/${SLUG}/*"
zone_name = "${ZONE}"

[assets]
directory = "./assets"
html_handling = "auto-trailing-slash"
not_found_handling = "404-page"
TOML

echo "ℹ 临时工作目录: $WORK_DIR"
echo ""

cd "$WORK_DIR"

# 首次跑会触发 wrangler login
WRANGLER_ARGS=(deploy)
if [[ $DRY_RUN -eq 1 ]]; then
  WRANGLER_ARGS+=(--dry-run)
fi

set +e
npx --yes wrangler "${WRANGLER_ARGS[@]}"
RC=$?
set -e

if [[ $RC -ne 0 ]]; then
  echo "" >&2
  echo "✗ Cloudflare $([ $DRY_RUN -eq 1 ] && echo dry-run || echo 部署)失败 (exit $RC)" >&2
  echo "  常见原因:" >&2
  echo "    · 未登录:        npx wrangler login" >&2
  echo "    · zone 错:       --zone <zone-name>" >&2
  echo "    · DNS 未准备好:   ${DOMAIN} 需要在 ${ZONE} 下有橙云 DNS，或已有同 hostname 的 Worker Custom Domain" >&2
  echo "    · Worker 名冲突: --slug <other>" >&2
  exit $RC
fi

echo ""
echo "═══════════════════════════════════════"
echo "✓ $([ $DRY_RUN -eq 1 ] && echo "dry-run 通过" || echo "部署完成")"
echo "  访问:   https://${DOMAIN}/${SLUG}/"
echo "  管理:   https://dash.cloudflare.com → Workers → ${WORKER_NAME}"
echo "  删除:   npx wrangler delete --name ${WORKER_NAME}"
echo "═══════════════════════════════════════"
