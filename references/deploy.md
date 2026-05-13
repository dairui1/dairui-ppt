# 部署 · Sharing a Deck

> 把单文件 HTML deck 发给别人看的两条路。本仓库自带 Vercel 和 Cloudflare Workers 两个脚本。

## 决策表

| 场景 | 推荐 |
|---|---|
| 临时分享 1 次，不在意 URL | **Vercel preview** |
| 自己域名下的固定地址（如 `ppt.dairui1.com/<slug>/`） | **Cloudflare Workers** |
| 一次发布多份 deck，集中管理 | **Cloudflare Workers**（每份独立 worker） |
| 完全离线 / 不联网部署 | 浏览器 ⌘P 出 PDF 然后微信 / 邮件 |
| 公司内网 / 不能上公网 | 复制 HTML 文件，自己挂内网静态服务器 |

## Vercel

最快的"贴一个链接给同事"方式。**首次部署会让你登录 Vercel 账号（浏览器弹窗，30 秒搞定）**，之后 1 行命令出链接。

### 用法

```bash
# 部署单个 HTML（脚本会自动包成临时目录）
bash scripts/deploy-vercel.sh path/to/deck.html

# 部署整个 deck 目录（含 images/ 等）
bash scripts/deploy-vercel.sh path/to/deck-folder/

# 命名 + 直接 prod
bash scripts/deploy-vercel.sh path/to/deck.html --name annual-2025 --prod
```

### 输出

部署完打印 preview URL，类似：

```
✓ Production: https://annual-2025-{hash}.vercel.app
```

### 默认行为

- 项目名从 `<title>` 自动提取（去掉占位符 `[必填]`），fallback 到目录名
- 默认 preview 模式；加 `--prod` 才更新生产 alias
- 自动写一个最小 `vercel.json`（`cleanUrls: true`），不需要你手动配
- 已存在 `vercel.json` 时不覆盖

### 删除

Vercel 后台 → Project → Settings → Advanced → Delete。或者 `npx vercel rm <project-name>`.

---

## Cloudflare Workers（部署到 ppt.dairui1.com）

每个 deck 部署成独立 worker（`ppt-{slug}`），通过路由挂在 `ppt.dairui1.com/<slug>/*` 下。互不影响、按需删。

### 一次性准备

1. Cloudflare 账号下 `dairui1.com` 已经接入（DNS 由 CF 管理）
2. CF 后台 → Workers & Pages → 一个临时 Worker → Settings → Triggers → Custom Domains → 加 `ppt.dairui1.com`（**只需要做一次**；之后所有 `ppt.dairui1.com/<slug>` 路由都能挂上去）
3. `npx wrangler login` 一次（首次跑脚本会自动触发）

### 用法

```bash
# 部署到 https://ppt.dairui1.com/<slug>/
bash scripts/deploy-cloudflare.sh path/to/deck.html --slug <slug>

# 不指定 slug，脚本会从 <title> 推
bash scripts/deploy-cloudflare.sh path/to/deck-folder/

# 换域名（如果以后要发布到别的子域）
bash scripts/deploy-cloudflare.sh deck.html --slug talk --domain talks.dairui1.com --zone dairui1.com
```

### 默认参数

| 参数 | 默认值 |
|---|---|
| `--domain` | `ppt.dairui1.com` |
| `--zone`   | `dairui1.com` |
| `--slug`   | 从 `<title>` 自动提取，fallback 到目录/文件名 |

### 输出

```
✓ 部署完成
  访问:   https://ppt.dairui1.com/<slug>/
  管理:   https://dash.cloudflare.com → Workers → ppt-<slug>
  删除:   npx wrangler delete --name ppt-<slug>
```

### 工作机制

脚本做的事：

1. 创建临时目录 `assets/<slug>/`，把 `deck.html` 拷成 `assets/<slug>/index.html`
2. 把同级的 `images/` 或 `assets/` 子目录也拷进去
3. 生成 `wrangler.toml`，配 `[assets] directory = "./assets"` + 路由 `ppt.dairui1.com/<slug>*`
4. 跑 `npx wrangler deploy`

URL 路径 `/{slug}/anything.png` → 找 `./assets/{slug}/anything.png`，完美对齐。

### 删除

```bash
npx wrangler delete --name ppt-<slug>
```

只删那一个 worker，其他不受影响。

### 多 deck 并存

每次跑脚本 = 新 worker。`ppt.dairui1.com/talk-2025` 和 `ppt.dairui1.com/report-q3` 互不影响，共享同一个自定义域名。

## 比较

| | Vercel | Cloudflare Workers |
|---|---|---|
| 域名 | `*.vercel.app` 或绑自定义域名 | `ppt.dairui1.com/<slug>/`（已绑） |
| 部署速度 | ~30s | ~10s |
| 删除 | 手动 / `vercel rm` | `wrangler delete --name ...` |
| 免费额度 | 100GB 带宽/月、100 部署/天 | 100k 请求/天、Workers 免费 |
| 适合场景 | 临时分享、不在意 URL | 长期挂着、自己域名 |
| 离线兜底 | ❌ | ❌ |

## 注意事项

- 部署到公网的 deck **任何人都能访问**。包含敏感数据时先评估
- 字体 CDN（Google Fonts / jsdelivr）首次需要联网；Cloudflare Workers 自身不阻止
- 风格 D（纸）部署后用户可以浏览器 ⌘P 自己出 PDF
- 风格 C（思维导图）部署没问题，URL 不变
- 内嵌图片用相对路径（`images/x.png`）部署时自动一起带上；用绝对路径（`/Users/...`）会失败
- 用 Cloudflare 时 `<slug>` 后面**必须有斜杠**：`https://ppt.dairui1.com/<slug>/`；不带斜杠也行但风格 C 的内部链接会错

## 如果两个都用不了

- **GitHub Pages**：把 deck 推到一个 repo 的 `gh-pages` 分支
- **Surge.sh**：`npx surge deck-folder/`
- **Netlify Drop**：拖文件夹到 https://app.netlify.com/drop
- **本地静态服务器**：`npx http-server deck-folder -p 8080`
