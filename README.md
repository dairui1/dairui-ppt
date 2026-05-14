# dairui-ppt

一份 Agent skill：用单文件 HTML 生成九种风格的网页 PPT。

- **A · 电子杂志 × 电子墨水** — 衬线 + WebGL 流体背景 + 暖色调；横向翻页
- **B · 瑞士国际主义** — 无衬线 + 网格点阵 + IKB/柠檬黄/柠檬绿/安全橙；横向翻页；22 个锁定版式
- **C · 思维导图** — 暖白底 + 前序遍历演示；纵向翻页；树结构即内容结构
- **D · 纸** — 羊皮纸底 + 墨水蓝 + 衬线层级；打印优先，浏览器 ⌘P 或 WeasyPrint 出 PDF
- **E · 编辑** — 奶米黄 + 陶土红 + Fraunces 衬线；横向翻页；drop cap / pull quote / 杂志精装
- **F · 暗夜植物** — 近黑 + 陶金/暖粉/古铜 + Cormorant italic；横向翻页；漂浮软渐变氛围
- **G · 笔记本** — 暗灰外底 + 奶纸卡 + 装订孔 + 6 色彩 tab；横向翻页；Bodoni Moda + sticky note
- **H · Bold Signal** — 暗灰渐变 + 鲜橙焦点卡 + 巨大编号；横向翻页；Archivo Black + 12 列 grid
- **I · 终端** — GitHub 暗底 + 终端绿 + 全程 JetBrains Mono + 扫描线；横向翻页；代码 demo 优先

九种风格都是**单文件 HTML**，浏览器直接打开就能用，不需要本地服务器或构建步骤。A/B/E/F/G/H/I 是交互演讲格式（横向翻页），C 是导图演讲格式（纵向前序展开），D 是打印阅读格式（PDF 出稿）。

**补充能力**：

- **Style Discovery** — 用户说不清要什么时，Agent 自动生成 3 个 mini preview 让指
- **Inline Editing 模式** — `node scripts/add-editing.mjs index.html` 给 deck 注入浏览器内编辑（A/B/E/F/G/H/I 适用）；Ctrl+S 导出干净 HTML
- **Viewport 自检** — `node scripts/check-overflow.mjs index.html` 在三档视口下测每页是否溢出
- **PPTX 导入** — `python scripts/extract-pptx.py file.pptx out/` 把已有 PowerPoint 转成 JSON + 图片
- **Vercel 部署** — `bash scripts/deploy-vercel.sh path/` 出 preview URL
- **Cloudflare Workers 部署到 `ppt.dairui1.com/<slug>/`** — `bash scripts/deploy-cloudflare.sh path/ --slug my-talk`（支持 `--dry-run`）
- **反 AI Slop 守则** — `references/anti-ai-slop.md` 跨风格通用的反平庸清单
- **动效配方手册** — `references/animation-patterns.md` 把"想要什么感觉"翻译成具体动效
- **Viewport 100vh 硬规则** — `references/viewport-rules.md` 跨风格 clamp + 不滚动约束

## 快速上手

```bash
mkdir -p 项目/XXX/ppt/images

# 选一个风格
cp dairui-ppt/assets/template-magazine.html   项目/XXX/ppt/index.html  # A
cp dairui-ppt/assets/template-swiss.html      项目/XXX/ppt/index.html  # B
cp dairui-ppt/assets/template-mindmap.html    项目/XXX/ppt/index.html  # C
cp dairui-ppt/assets/template-paper.html      项目/XXX/ppt/index.html  # D
cp dairui-ppt/assets/template-editorial.html  项目/XXX/ppt/index.html  # E
cp dairui-ppt/assets/template-botanical.html  项目/XXX/ppt/index.html  # F
cp dairui-ppt/assets/template-notebook.html   项目/XXX/ppt/index.html  # G
cp dairui-ppt/assets/template-signal.html     项目/XXX/ppt/index.html  # H
cp dairui-ppt/assets/template-terminal.html   项目/XXX/ppt/index.html  # I

# 打开预览
open 项目/XXX/ppt/index.html

# 可选 · 注入浏览器内编辑（A/B/E/F/G/H/I）
node dairui-ppt/scripts/add-editing.mjs 项目/XXX/ppt/index.html

# 可选 · 测视口溢出
node dairui-ppt/scripts/check-overflow.mjs 项目/XXX/ppt/index.html

# 可选 · 部署到 Vercel preview
bash dairui-ppt/scripts/deploy-vercel.sh 项目/XXX/ppt/

# 可选 · 部署到 ppt.dairui1.com/<slug>/
bash dairui-ppt/scripts/deploy-cloudflare.sh 项目/XXX/ppt/index.html --slug my-talk

# 可选 · 部署前只验证 Cloudflare Workers 配置，不发布
bash dairui-ppt/scripts/deploy-cloudflare.sh 项目/XXX/ppt/index.html --slug my-talk --dry-run
```

把这个 skill 交给 Agent，详细工作流见 `SKILL.md`。

## 目录结构

```
dairui-ppt/
├── SKILL.md
├── README.md                   ← 本文件
├── LICENSE
├── assets/
│   ├── template-magazine.html   (A)
│   ├── template-swiss.html      (B)
│   ├── template-mindmap.html    (C)
│   ├── template-paper.html      (D)
│   ├── template-editorial.html  (E)
│   ├── template-botanical.html  (F)
│   ├── template-notebook.html   (G)
│   ├── template-signal.html     (H)
│   ├── template-terminal.html   (I)
│   └── motion.min.js
├── references/
│   ├── anti-ai-slop.md       ← 跨风格 · 反 AI Slop 守则
│   ├── animation-patterns.md ← 跨风格 · 动效配方
│   ├── viewport-rules.md     ← 跨风格 · 100vh 硬约束
│   ├── style-discovery.md    ← Show-don't-tell 选风格流程
│   ├── inline-editing.md     ← 浏览器内编辑接入说明
│   ├── deploy.md             ← Vercel / Cloudflare 部署
│   ├── components.md
│   ├── layouts.md            ← 风格 A 布局骨架
│   ├── layouts-swiss.md      ← 风格 B 22 个版式说明
│   ├── layouts-mindmap.md    ← 风格 C 树结构与节点规范
│   ├── layouts-paper.md      ← 风格 D 纸排版规范与 PDF 出稿
│   ├── layouts-editorial.md  ← 风格 E 编辑风版式与写作风格
│   ├── layouts-botanical.md  ← 风格 F 暗夜植物风版式与组件
│   ├── layouts-notebook.md   ← 风格 G 笔记本版式与 tab 导航
│   ├── layouts-signal.md     ← 风格 H Bold Signal 版式与 12 列 grid
│   ├── layouts-terminal.md   ← 风格 I 终端版式与语法高亮
│   ├── swiss-layout-lock.md
│   ├── themes.md
│   ├── themes-swiss.md
│   ├── image-prompts.md
│   └── checklist.md
└── scripts/
    ├── validate-swiss-deck.mjs  ← 风格 B 静态校验
    ├── check-overflow.mjs       ← 通用 · 测每页是否溢出 100vh
    ├── extract-pptx.py          ← .pptx → JSON + 图片导入工具
    ├── add-editing.mjs          ← 注入浏览器内编辑 UI
    ├── deploy-vercel.sh         ← Vercel preview / production 部署
    └── deploy-cloudflare.sh     ← Cloudflare Workers · ppt.dairui1.com/<slug>/（含 dry-run）
```

## 操作

- 翻页：← →（A/B/E/F/G/H/I）/ ↑ ↓（C）/ 滚轮 / 触屏滑动
- 索引：ESC（A/B）
- 静态模式：B 键（A/B）
- 跳转节点：进度滑条（C）/ 点 tab 直跳（G）/ 点 crumb 直跳（H）
- 缩放：Zoom 滑条（C）
- 编辑模式（注入后）：左上角热区 → ✏️ 按钮 / 按 E
- 导出编辑后的 HTML：Ctrl/⌘+S
- 出 PDF：⌘P 或 `weasyprint index.html out.pdf`（D）

## 致谢

本 skill 的实现融合并改造自以下四个开源项目：

- **风格 A · 电子杂志风** 与 **风格 B · 瑞士国际主义风** 的模板、布局清单、组件手册和 Swiss layout lock 改造自 [op7418/guizang-ppt-skill](https://github.com/op7418/guizang-ppt-skill)（作者：歸藏 Guizang，MIT License）。
- **风格 C · 思维导图** 的前序遍历交互、节点二行体例、`@image` 元数据语法改造自 [agegr/mindmap-ppt](https://github.com/agegr/mindmap-ppt)（作者：agegr）；在本仓库里被适配为单文件 HTML，移除了对原仓库 `src/main.js` 与 `npm` 构建的依赖。
- **风格 D · 纸** 的羊皮纸底色、墨水蓝强调色、衬线层级、版式骨架（封面 / 两栏 / 2×2 / callout / 数据表）改造自 [tw93/kami](https://github.com/tw93/kami)（作者：Tw93，MIT License）；只取其 slide deck 部分，字体走 jsdelivr CDN，未在本仓库中分发原 18MB 字体文件。
- **风格 E · 编辑风**、**风格 F · 暗夜植物风**、**风格 G · 笔记本**、**风格 H · Bold Signal**、**风格 I · 终端** 的字体配对与视觉锚点，以及 **Style Discovery（Show-don't-tell）**、**反 AI Slop 守则**、**动效感觉→配方对照表**、**Viewport 100vh 硬规则**、**Inline Editing**、**PPTX 导入**、**Vercel 部署脚本** 等能力改造自 [zarazhangrui/frontend-slides](https://github.com/zarazhangrui/frontend-slides)（MIT License）；E/F/G/H/I 五个模板由本仓库重新实现，未直接复用原项目的 HTML 结构。

向四位原作者致敬。
