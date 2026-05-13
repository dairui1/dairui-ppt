---
name: dairui-ppt
description: Use when the user wants to generate a single-file HTML PPT/deck for a sharing session, demo day, internal talk, project report, white paper, annual recap, equity research, investor memo, editorial article, brand lookbook, hackathon demo, dev talk, or anything that should be "做完直接发，不用翻页工具"。Triggers on "做 PPT / 做 deck / 网页 PPT / 演讲 / 分享 / 发布会 / 路演 / 一次做完 / horizontal swipe deck"，更具体地"杂志风 / Monocle 感 / 瑞士风 / Swiss Style / Helvetica / 极简数据 / 思维导图 / mindmap / 脑图 / 把文章讲成 PPT / 纸风格 / 白皮书 / 印刷感 / 打印 PDF / 异步阅读 / 编辑风 / Fraunces / 暗夜风 / dark botanical / 高端品牌 / lookbook / 笔记本风 / notebook / hobonichi / 手账 / Bold Signal / 大字 / 橙色焦点 / demo day / 终端风 / terminal / 黑客 / 极客 talk / 代码 demo / 把 PPTX 转成网页 / 部署到我自己域名"。不适合：大量表格数据、培训课件、需要多人协作编辑的场景。
---

# Dairui PPT

## 这个 Skill 做什么

生成一份**单文件 HTML**演示文稿，九种可选的视觉/交互形态：

### 风格 A · 电子杂志 × 电子墨水

- **WebGL 流体 / 等高线 / 色散背景**（hero 页可见）
- **衬线标题（Noto Serif SC + Playfair Display）+ 非衬线正文 + 等宽元数据**
- 横向翻页（键盘 ← →、滚轮、触屏、ESC 索引）
- 适合：人文分享、行业观察、商业发布、需要"杂志感"的演讲
- 模板：`assets/template-magazine.html` · 主题色：`references/themes.md` · 布局：`references/layouts.md`
- 美学锚点：像 *Monocle* 杂志贴上了代码

### 风格 B · 瑞士国际主义（Swiss Style）

- **WebGL 极细网格 + 点阵背景**（信息驱动设计）
- **全程无衬线（Inter + Helvetica + Noto Sans SC）+ 极致字号对比**
- **高反差功能色**：克莱因蓝 IKB / 柠檬黄 / 柠檬绿 / 安全橙（四选一）
- 横向翻页，22 个锁定版式 S01-S22
- 适合：科技产品、数据汇报、设计/工程领域分享、年度总结
- 模板：`assets/template-swiss.html` · 主题色：`references/themes-swiss.md` · 布局：`references/layouts-swiss.md`
- 美学锚点：像 Massimo Vignelli + Helvetica Forever

### 风格 C · 思维导图（Mindmap）

- **暖白底 + 四角漂浮的彩色 blob**，浅色 presentation 风
- **整张 PPT 是一棵树**，按前序遍历展开：先 root → 左子树 → 右子树
- **纵向翻页**（↑ ↓、Page Up/Down、滚轮、移动端上下划）
- 节点两行（副标题 / 主标题），可选附图，图片可点击放大
- 适合：项目汇报、产品讲解、长文提炼、需要"展示思考结构"的演讲
- 模板：`assets/template-mindmap.html` · 内容规范：`references/layouts-mindmap.md`
- 美学锚点：把脑图变成可播放的故事线

### 风格 D · 纸（Paper）

- **暖灰羊皮纸底 `#f5f4ed` + 墨水蓝 `#1B365D`**，克制、克制、再克制
- **衬线层级**：TsangerJinKai02（中文）+ Charter / Georgia（英文）+ JetBrains Mono（等宽元数据）
- **打印优先**：每个 `.slide` 是一张独立纸页（默认 280×158 mm），浏览器可滚动预览，最终 print-to-PDF 或 WeasyPrint 出稿
- 适合：白皮书、年度总结、研报、PDF 分享 / 异步阅读、需要"看起来像正式文件"的 deck
- 模板：`assets/template-paper.html` · 排版规范：`references/layouts-paper.md`
- 美学锚点：编辑部纸张 + 墨水印刷

### 风格 E · 编辑（Vintage Editorial）

- **奶米黄底 `#f5f3ee` + 陶土红 `#b04a2f` + 暖肌色块**，杂志精装感
- **Fraunces 衬线展示（900）+ Work Sans 无衬线正文 + 斜体副标**
- **横向翻页**（← →、滚轮、触屏），明暗页面交替
- 关键组件：drop cap 首字下沉 / pull quote / stat card / 抽象几何装饰 / 3px boxed CTA
- 适合：行业观察、调研文章、有"个人态度"的分享、需要"杂志精装"质感的 deck
- 模板：`assets/template-editorial.html` · 排版规范：`references/layouts-editorial.md`
- 美学锚点：*The New Yorker* / *Monocle* / *Cereal* / Pentagram 改版

### 风格 F · 暗夜植物（Dark Botanical）

- **近黑底 `#0f0f0f` + 陶金 / 暖粉 / 古铜暖色三档** + 漂浮软渐变球氛围
- **Cormorant 衬线斜体大字 + IBM Plex Sans 轻字重正文**
- **横向翻页**，blur + fade 入场，多层 atmos 球慢速漂移
- 关键组件：italic hero / spec card 顶部 hairline / 极简 timeline / CTA link（不是 box）/ accent-line 章节标识
- 适合：高端品牌、艺术 / 设计 / 香水 / 酒店调性、需要"被打动"的演讲
- 模板：`assets/template-botanical.html` · 排版规范：`references/layouts-botanical.md`
- 美学锚点：Aman / Aesop lookbook / *The Gentlewoman* / *Anothermag*

### 风格 G · 笔记本（Notebook Tabs）

- **暗灰外底 + 奶色纸卡 + 左侧装订孔 + 右侧 6 个彩色 tab**
- **Bodoni Moda 衬线 + DM Sans 无衬线 + 衬线下划线高亮**
- **横向翻页 + 点彩色 tab 直跳页**
- 关键组件：装订孔 / 6 色 tab 导航 / sticky note 微旋转 / 编号 note 列表 / 手写注脚
- 适合：手账感 / 编辑专栏 / 季度回顾 / 学习笔记 / 个人 newsletter
- 模板：`assets/template-notebook.html` · 排版规范：`references/layouts-notebook.md`
- 美学锚点：Hobonichi / Field Notes / Moleskine / 北欧文具店

### 风格 H · Bold Signal

- **暗灰渐变底 + 鲜橙焦点卡 `#FF5722` + 巨大编号 + 12 列 grid**
- **Archivo Black 全大写 + Space Grotesk 正文**
- **横向翻页 · 顶部 crumb 面包屑可点跳页 · 底部分段进度**
- 关键组件：section number 大编号 / signal-card 橙焦点 / signal-list 编号列表 / KPI hero / progress segments
- 适合：发布会 / demo day / 路演 pitch / 强势主张
- 模板：`assets/template-signal.html` · 排版规范：`references/layouts-signal.md`
- 美学锚点：Nike 发布会 / YC demo day / *Wired* 早期

### 风格 I · 终端（Terminal Green）

- **GitHub 暗底 + 终端绿 `#39d353` + 全程 JetBrains Mono + 扫描线 + 闪烁光标**
- **完全等宽字体**，没有任何衬线 / 无衬线混入
- **横向翻页 · prompt 行 + output 块 + 代码语法高亮 + ASCII art divider**
- 关键组件：window titlebar / `$ prompt` / 语法高亮 code-block / git diff 块 / KPI 三栏 panel / cursor 闪烁
- 适合：技术 demo / 黑客松 / 开发者 talk / 工程团队内部分享 / 命令行工具发布
- 模板：`assets/template-terminal.html` · 排版规范：`references/layouts-terminal.md`
- 美学锚点：90s BBS / Linux TTY / VS Code / Neovim 全屏 demo

**九种风格共享**：单文件 HTML，无需服务器，浏览器直接打开即可。A/B/E/F/G/H/I 是交互演讲格式（横向翻页），C 是导图演讲格式（纵向前序展开），D 是打印阅读格式（PDF 出稿）。

## 何时使用

**合适的场景**：
- 线下分享 / 行业内部讲话 / 私享会（A/B/C 都行）
- AI 新产品发布 / demo day（A 或 B）
- 项目汇报 / 论点结构展示（C 最合适）
- 带有强烈个人风格的演讲（A）
- 需要"一次做完，不用翻页工具"的网页版 slides

**不合适的场景**：
- 大段表格数据、图表叠加（用常规 PPT）
- 培训课件（信息密度不够）
- 需要多人协作编辑（这是静态 HTML）

## 工作流

### Step 0 · 输入分流（**如果用户给了 .pptx**）

如果用户提供了 PowerPoint 文件（`.pptx`），先做导入再进 Step 1：

```bash
pip install python-pptx     # 若未安装
python <SKILL_ROOT>/scripts/extract-pptx.py <input.pptx> <output_dir>
```

输出：
- `<output_dir>/extracted-slides.json` — 每张 slide 的标题、文本、图片路径、speaker notes
- `<output_dir>/assets/` — 抽取出的图片，按 `slide{N}_img{M}.{ext}` 命名

读 `extracted-slides.json`，**和用户确认导入结果**（每张 slide 的标题 + 内容摘要 + 图片数量），再进 Step 1 让他选目标风格。生成新 deck 时按原 slide 顺序填充，图片走 `assets/` 相对路径，speaker notes 作为 HTML 注释保留。

如果用户没有 `.pptx`，跳过本步。

### Step 1 · 需求澄清（**动手前必做**）

**如果用户已经给了完整的大纲 + 图片**，可以跳过直接进 Step 2。

**如果用户只给了主题或一个模糊想法**，用下面几问对齐后再动手。不要基于猜测就开始写——一旦风格或结构定错，后期翻修代价很高。

#### 运行环境适配

- **在 Codex / 命令行环境**：用普通对话直接询问，一次最多问 1-3 个最关键问题；如果信息缺口不影响开工，先做合理假设并在回复里说明。
- **在 Claude Code 中**：可以用 `AskUserQuestion` 工具逐项澄清。

#### 澄清清单

| # | 问题 | 为什么要问 |
|---|------|-----------|
| 1 | **风格 A-I 选一种**：A 杂志 / B 瑞士 / C 导图 / D 纸 / E 编辑 / F 暗夜植物 / G 笔记本 / H Bold Signal / I 终端。如果用户说不清，启动 **Style Discovery**——见 `references/style-discovery.md` | **必须先确定**，决定模板和后续工作流 |
| 2 | **受众是谁？分享场景？**（行业内部 / 商业发布 / demo day / 私享会） | 决定语言风格和深度 |
| 3 | **分享时长？** | A/B：15 分钟 ≈ 10 页，30 分钟 ≈ 20 页；C：按节点数算，每节点约 30-60 秒；D 是阅读格式，按内容密度算 |
| 4 | **有没有原始素材？**（文档 / 数据 / 旧 PPT / 文章链接） | 有素材就基于素材，没有就帮他搭 |
| 5 | **有没有图片？放在哪？** | 详见下方"图片约定" |
| 6 | **想要哪套主题色 / 配色基调？** | A：5 套 `themes.md`；B：4 套 `themes-swiss.md`；C-I 都是内置一套配色，**不接受自定义** |
| 7 | **需要浏览器内编辑文字 + Ctrl+S 导出吗？** | 默认 No；说 Yes 时部署后跑 `node scripts/add-editing.mjs index.html` 注入（A/B/E/F/G/H/I 适用，C/D 不需要） |
| 8 | **部署到哪里？** | 不部署只本地预览 / Vercel（preview URL）/ Cloudflare Workers（`ppt.dairui1.com/<slug>/`，dairui1 默认）/ 其他 |
| 7 | **有没有硬约束？**（必须包含 XX 数据 / 不能出现 YY） | 避免返工 |

#### Style Discovery（用户说不清要什么时启动）

如果用户的描述跨多个风格（典型："想要看起来专业但又有点设计感"），或者明确说"随便 / 你看着办"——**不要拿 A/B/C/D/E/F 抽象选项去为难他**，启动 Show-don't-tell 流程：

1. 先问 1 个**感觉**问题：印象深刻 / 兴奋激动 / 安静专注 / 被打动（multiSelect ≤ 2）
2. 把感觉映射到 2-3 个候选风格
3. 为每个候选生成 1 个 mini preview（单张代表性 slide，**用真实主题，不要 Lorem Ipsum**），保存到 `.dairui-design/previews/style-*.html`，自动 `open`
4. 让用户指一个

完整流程、Preview 模板生成原则、失败兜底见 `references/style-discovery.md`。

#### 风格选择参考（问题 1）

| 如果用户说... | 推荐风格 |
|---|---|
| "杂志感" / "人文" / "Monocle 风" / 不指定 | **A · 电子杂志风** |
| "瑞士风" / "Swiss Style" / "Helvetica" / "极简" / "网格" / "信息图" / "数据驱动" | **B · 瑞士国际主义风** |
| "思维导图" / "mindmap" / "脑图" / "结构展示" / "汇报演示" / "把文章讲成 PPT" / "前序遍历" | **C · 思维导图** |
| "纸感" / "白皮书" / "PDF 分享" / "印刷感" / "kami 风" / "正式文件" / "异步阅读" / "墨水蓝" | **D · 纸** |
| "编辑风" / "杂志精装" / "*New Yorker* 感" / "*Monocle* 但更厚重" / "Fraunces" / "drop cap" / "pull quote" / "有态度的分享" | **E · 编辑** |
| "暗夜" / "暗黑优雅" / "Aman / Aesop 感" / "lookbook" / "高端品牌" / "斜体衬线大字" / "Cormorant" / "暖色软渐变" | **F · 暗夜植物** |
| "手账" / "笔记本" / "Hobonichi" / "Field Notes" / "贴 sticky" / "彩色标签" / "Bodoni Moda" / "个人 newsletter" | **G · 笔记本** |
| "发布会感" / "demo day" / "路演 pitch" / "大字 + 橙色" / "Archivo Black" / "Nike 风" / "高反差暗底大字" | **H · Bold Signal** |
| "终端" / "terminal" / "黑客感" / "命令行" / "JetBrains Mono" / "代码 demo" / "技术分享" / "极客" / "BBS / TTY" | **I · 终端** |
| "随便 / 都行 / 你来决定" / "想看一下再说" / 关键词跨多种风格 | **启动 Style Discovery** — 见 `references/style-discovery.md` |
| 内容是 AI 产品 / 技术 / 工程 / 数据汇报 | B |
| 内容是行业观察 / 人文 / 故事 / 文化 | A |
| 内容是长文 / 调研 / 论证 / 课程笔记 | **C**（C 最擅长把线性长文转成可播放的树） |
| 内容是白皮书 / 年度报告 / 研报 / 投资备忘录 / 要发给客户阅读 | **D**（D 的纸质感最适合"看起来像正式文件"） |
| 用户明确说"不要动画"、"要打印出来分享" / "要 PDF" | **D** |
| 内容是行业观察 / 调研报告 / 长文采访 / 杂志专栏 | **E**（E 的 drop cap + pull quote 适合长文叙事） |
| 内容是品牌故事 / 艺术展览 / 香水 / 酒店 / 设计工作室 | **F**（F 的优雅 italic + atmos 球适合"被打动"的演讲） |
| 内容是个人 newsletter / 季度回顾 / 学习笔记 / 读书摘录 | **G**（G 的手账质感最贴合"翻开一本本子读到的内容"） |
| 内容是 demo day / pitch deck / 强调一次性 wow / 路演 | **H**（H 的大字 + 橙焦点 + 大编号最有"会议室全场静下来"的感觉） |
| 内容是技术分享 / 代码 demo / 工程团队内部 talk / CLI 工具发布 | **I**（I 的等宽 + 代码块 + 终端绿是开发者向唯一对的选择） |
| 用户给了大量 KPI 数字 / 路线图 / 流程 | B（`Data Hero` 布局是瑞士风专长） |
| 用户给了大量纪实照片 / 人文图片 | A（图片网格、左文右图是杂志风专长） |
| 用户需要用 AI 生成截图再设计 / 信息图 / 证据墙 | B 也合适 |

#### 大纲协助（适用于风格 A/B）

如果用户没有大纲，用"叙事弧"模板搭骨架：

```
钩子(Hook)       → 1 页   : 抛一个反差 / 问题 / 硬数据让人停下来
定调(Context)    → 1-2 页 : 说明背景 / 你是谁 / 为什么讲这个
主体(Core)       → 3-5 页 : 核心内容，用 Layout 4/5/6/9/10 穿插
转折(Shift)      → 1 页   : 打破预期 / 提出新观点
收束(Takeaway)   → 1-2 页 : 金句 / 悬念问题 / 行动建议
```

#### 大纲协助（适用于风格 C）

思维导图不走叙事弧，走**逻辑树**：

```
root           → 文档/演讲主题（1 行副标题 + 1 行主张）
├── 章 1        → 通常 2-4 个，按原文 chapter 顺序
│    ├── 节点  → 细分论点 / 证据 / 例子 / 步骤
│    └── ...
├── 章 2
└── ...
```

要点：
- **沿用原文顺序**，preorder 父先于子，不要把后文结论提前到父节点 label
- 每个父节点 ≤ 5 个子节点，超过就加分组节点
- 父节点做判断、子节点放证据/原因/例子
- 详细规则见 `references/layouts-mindmap.md`

#### 图片约定（告知用户）

在动手前向用户说清：

- **文件夹位置**：`项目/XXX/ppt/images/`（和 `index.html` 同级）
- **命名规范**：
  - A/B：`{页号}-{语义}.{ext}`，例如 `01-cover.jpg` / `03-figma.jpg`
  - C：语义化短名，例如 `cover.png` / `agent-workflow.png` / `diagrams/flow.svg`
- **规格建议**：
  - 单张 ≥ 1600px 宽（避免大屏模糊）
  - JPG 用于照片/截图，PNG 用于透明 UI/图表，SVG 用于占位几何
  - 总大小控制在 10MB 内（影响翻页流畅度）
- **如何替换**：保持同名覆盖最稳；如果文件名变了，记得全局搜 `images/旧名` 改成新名
- **没图怎么办**：A/B 可以先用占位色块；C 直接省掉 `@image` 行就好（导图节点自动不留图位）

#### AI 生成配图（可选）

完成 deck 初稿后，主动问用户是否需要 AI 生成配图。**不要默认生成**。

推荐询问方式：

> 要不要为这份 PPT 生成几张配图？可以做成人文纪实照片、杂志风信息图、流程/对比/系统关系图，或把截图再设计成统一的视觉。

生成配图时遵守：

- 提示词保持简短，只框定主题、用途、风格和比例
- **图片风格必须贴合当前 deck 风格**：A 用 `references/image-prompts.md` 杂志风模板；B 用瑞士风模板；C 用 `references/layouts-mindmap.md` 末尾的 mindmap 配图模板
- 信息图、图表、截图再设计里的文字语言必须跟随用户正在使用的语言
- 配图比例必须匹配最终落位
- 生成后的图片放到 `images/` 下，命名遵守上述规则

### Step 2 · 拷贝模板

根据 Step 1 选定的风格，把对应模板拷到目标位置（通常是 `项目/XXX/ppt/index.html`），同时在同级建一个 `images/` 文件夹。

```bash
mkdir -p "项目/XXX/ppt/images"

# 风格 A · 电子杂志风
cp "<SKILL_ROOT>/assets/template-magazine.html" "项目/XXX/ppt/index.html"

# 风格 B · 瑞士国际主义风
cp "<SKILL_ROOT>/assets/template-swiss.html" "项目/XXX/ppt/index.html"

# 风格 C · 思维导图
cp "<SKILL_ROOT>/assets/template-mindmap.html" "项目/XXX/ppt/index.html"

# 风格 D · 纸
cp "<SKILL_ROOT>/assets/template-paper.html" "项目/XXX/ppt/index.html"

# 风格 E · 编辑
cp "<SKILL_ROOT>/assets/template-editorial.html" "项目/XXX/ppt/index.html"

# 风格 F · 暗夜植物
cp "<SKILL_ROOT>/assets/template-botanical.html" "项目/XXX/ppt/index.html"

# 风格 G · 笔记本
cp "<SKILL_ROOT>/assets/template-notebook.html" "项目/XXX/ppt/index.html"

# 风格 H · Bold Signal
cp "<SKILL_ROOT>/assets/template-signal.html" "项目/XXX/ppt/index.html"

# 风格 I · 终端
cp "<SKILL_ROOT>/assets/template-terminal.html" "项目/XXX/ppt/index.html"
```

九个模板都是**完整可运行**的单 HTML 文件。**九种风格不能混用**——CSS 类名和结构都不一样。一份 deck 只能选一套。

#### 2.1 · 必改占位符（**容易漏**）

拷贝后立刻改掉 `<title>` 里的 `[必填] 替换为...`，否则浏览器 Tab 会显示尴尬的占位文字。

| 风格 | 占位符位置 | 改成 |
|---|---|---|
| A | `<title>[必填] 替换为 PPT 标题 · Deck Title</title>` | 实际 deck 标题 |
| B | 同上 | 同上 |
| C | `<title>[必填] 替换为思维导图 PPT 标题 · Mindmap Deck Title</title>` | 实际 deck 标题 |
| D | `<title>[必填] 替换为纸风格 PPT 标题 · Paper Deck Title</title>` | 实际 deck 标题 |
| E | `<title>[必填] 替换为编辑风 PPT 标题 · Editorial Deck Title</title>` | 实际 deck 标题 |
| F | `<title>[必填] 替换为暗夜植物风 PPT 标题 · Dark Botanical Deck Title</title>` | 实际 deck 标题 |
| G | `<title>[必填] 替换为笔记本风 PPT 标题 · Notebook Deck Title</title>` | 实际 deck 标题 |
| H | `<title>[必填] 替换为 Bold Signal PPT 标题 · Bold Signal Deck Title</title>` | 实际 deck 标题 |
| I | `<title>[必填] 替换为终端风 PPT 标题 · Terminal Green Deck Title</title>` | 实际 deck 标题 |

每次拷贝完一定要 grep 一下 `[必填]` 确认全部替换。

#### 2.2 · 选定主题色

- **风格 A**：5 套预设（不允许自定义），见 `references/themes.md`
- **风格 B**：4 套预设，见 `references/themes-swiss.md`
- **风格 C**：内置一套暖色（深青 + 暖白 + 橙 + 浅绿），不需要选，**不接受自定义**
- **风格 D**：内置羊皮纸 + 墨水蓝（`#f5f4ed` + `#1B365D`），不需要选，**不接受自定义**
- **风格 E**：内置奶米黄 + 陶土红 + 暖肌色块（`#f5f3ee` + `#b04a2f` + `#e8d4c0`），不需要选，**不接受自定义**
- **风格 F**：内置近黑 + 陶金/暖粉/古铜（`#0f0f0f` + `#d4a574` + `#e8b4b8` + `#c9b896`），不需要选，**不接受自定义**
- **风格 G**：内置暗灰外底 + 奶纸 + 6 色 tab（mint/lavender/pink/sky/cream/peach），**不接受自定义**
- **风格 H**：内置暗灰渐变 + 鲜橙 `#FF5722` + amber `#FFC107`，**不接受自定义**
- **风格 I**：内置 GitHub 暗 `#0d1117` + 终端绿 `#39d353` + 标准语法高亮色板，**不接受自定义**

A/B 的硬规则：
- 一份 deck 只用一套主题，不要中途换色
- 不要接受用户给的任意 hex 值——委婉拒绝并展示预设让选
- 不要混搭不同主题里的颜色

C 的硬规则：
- 不要改 `<style>` 块里的颜色变量；要改也只改 `:root` 顶部的 `--node-image-*` 尺寸

D 的硬规则：
- 不要改 `:root` 里的色变量、字号、字距
- 改 `@page size` 时必须同步改 `.slide width/height`

E 的硬规则：
- 不要换 Fraunces / Work Sans / JetBrains Mono 字体（CDN 已配置）
- 不要把陶土红换成 AI 默认紫 / 科技蓝
- 不要破坏明暗节奏（建议 6-8 页里有 ≥1 个 dark）

F 的硬规则：
- 不要换 Cormorant / IBM Plex Sans 字体（CDN 已配置）
- 不要删光 atmos 软渐变球（这是该风格的灵魂）
- 不要用 `font-weight ≥ 600` 的大字（违反克制原则）
- 不要混入饱和度高的颜色（紫 / 蓝 / 绿）——只用暖色三档

G 的硬规则：
- 不要把纸卡改成纯白（失去暖色质感）
- 不要删左侧装订孔（笔记本质感锚点）
- 不要超过 6 个 tab（视觉饱和）
- 每页 `.ul-accent` 高亮 ≤ 1 处

H 的硬规则：
- 不要把 Archivo Black 换成其他字体——丢失 signage 质感
- **大字必须全大写**（`.h-hero` / `.h-display` / `.h-section` / `.h-sub`）
- 整份 deck `.signal-card` 颜色统一 · `.cta-big` 只用 1 个
- 不要圆角 > 0

I 的硬规则：
- **只许用 JetBrains Mono**——任何混入衬线 / 无衬线都翻车
- 不要把终端绿换成别的霓虹色
- 不要把背景换成浅色（CRT 质感全失）
- ASCII art 用 box-drawing 字符（`─│┌┐└┘╔╗╚╝═║`），用 `--fg-mute` 颜色不要染绿
- 代码块语法高亮 class 必须用对（`.kw` / `.fn` / `.str` / `.cm` / `.ty`），不要把全部染同一色

### Step 3 · 填充内容

#### 3.0 · 反 AI Slop 预检（**所有风格通用**）

**先读 `references/anti-ai-slop.md`**——这是适用于全部 6 种风格的反模式守则。LLM 在生成前端时会收敛到分布中心（Inter 字体、紫色渐变、居中 hero、4 列卡片网格）。预检要确认：

- 没用 Inter / Roboto / Arial / system-ui 当 display 字体（除风格 B 的 Inter 本身就是其灵魂外）
- 没用 `#6366f1` indigo / 紫粉渐变 / 默认 Tailwind 配色
- 没把内容全居中堆叠
- 没盲目用圆角 + drop-shadow + 玻璃拟态
- 没用 emoji 当装饰
- 整份 deck 有 1 个明确的视觉决定（主字 + 主色 + 一种动效语言）

如果有"想加点动效"的冲动，先读 `references/animation-patterns.md` 的"感觉 → 动效配方"对照表，按风格挑配方而不是默认 fade-in。

#### 风格 A · 电子杂志风

走杂志风的完整流程。**先 Read `assets/template-magazine.html` 的 `<style>` 块**确认类名都存在，再去 `references/layouts.md` 挑布局粘贴，按 `references/components.md` 调细节。

风格 A 常见容易遗漏的类（必须存在于 template 的 `<style>` 里）：
`h-hero` / `h-xl` / `h-sub` / `h-md` / `lead` / `kicker` / `meta-row` / `stat-card` / `stat-label` / `stat-nb` / `stat-unit` / `stat-note` / `pipeline-section` / `pipeline-label` / `pipeline` / `step` / `step-nb` / `step-title` / `step-desc` / `grid-2-7-5` / `grid-2-6-6` / `grid-2-8-4` / `grid-3-3` / `grid-6` / `grid-3` / `grid-4` / `frame` / `frame-img` / `img-cap` / `callout` / `callout-src` / `chrome` / `foot`

强制主题节奏：每页 section 必须带 `light` / `dark` / `hero light` / `hero dark` 之一；连续 3 页以上同主题 = 视觉疲劳；8 页以上必须有 ≥1 个 `hero dark` + ≥1 个 `hero light`。

布局清单（见 `references/layouts.md`）：

| Layout | 用途 |
|---|---|
| 1. 开场封面 | 第 1 页 |
| 2. 章节幕封 | 每幕开场 |
| 3. 数据大字报 | 抛硬数据 |
| 4. 左文右图（Quote + Image） | 身份反差 / 故事 |
| 5. 图片网格 | 多图对比 / 截图实证 |
| 6. 两列流水线（Pipeline） | 工作流程 |
| 7. 悬念收束 / 问题页 | 幕末 / 收尾 |
| 8. 大引用页（Big Quote） | 衬线金句 / takeaway |
| 9. 并列对比（Before / After） | 旧模式 vs 新模式 |
| 10. 图文混排（Lead Image + Side Text） | 信息密集的图文页 |

#### 风格 B · 瑞士国际主义风

**先读 `references/swiss-layout-lock.md`**，再读 `references/layouts-swiss.md`。

瑞士主题默认进入 **Swiss locked mode**：

- 正文页只能使用原始登记的 22 个版式 `S01-S22`；新增首页/尾页只能用 Skill 明确提供的 `SWISS-COVER-ASCII` / `SWISS-CLOSING-ASCII`
- 每个 `<section class="slide">` 必须写 `data-layout="Sxx"`
- 不允许临时发明新结构，除非用户明确要求实验版式
- SVG 只负责几何图形，不要在 SVG 里写文字标签

版式多样性硬规则：
- 7-8 页 deck 至少使用 **6 个不同 S 编号版式**；10 页以上至少使用 8 个
- 不允许连续 3 页使用同一种主体结构
- 开写 HTML 前先列一张 `页码 → data-layout → 选用理由 → 图片槽位` 草稿；交付前运行 `node <SKILL_ROOT>/scripts/validate-swiss-deck.mjs index.html`

22 个版式速查、字号分档、图片比例规范、组件细节全部在 `references/layouts-swiss.md`。

#### 风格 C · 思维导图

唯一编辑点：模板里的 `sourceMarkdown` 模板字符串。完整规则见 `references/layouts-mindmap.md`，核心：

```md
- 副标题
  主标题
  @image cover.png
    - 子节点副标题
      子节点主标题
```

- 每行 `- text` 是一个节点，缩进决定父子关系
- 节点下方缩进的非 `-` 文本是该节点的主标题
- `@image path` 紧跟在标题行后、子节点之前；短路径解析为 `./images/<path>`
- 不要修改 `<style>` 和后面的渲染脚本
- 不要把未转义的反引号或 `${...}` 写进 markdown，否则会破坏 JS 模板字符串

风格 C 没有"挑版式"的步骤——形状由树本身决定。把精力放在：
- 树的层级是否反映了作者的真实逻辑
- 每个父节点子数 ≤ 5
- 高信息量节点配图，细枝末节不配
- 中文输入产中文、英文输入产英文，不混翻

#### 风格 D · 纸

完整规范见 `references/layouts-paper.md`。模板自带 5 种版式骨架（封面 / 两栏 / 2×2 模块 / 底部 callout / 数据表），直接复制 `<section>` 改文案。

关键硬规则：
- 用 `.eyebrow` 写章节编号，**不要**整页蓝色分隔页
- 中文括号 `（...）` 一律替换为 `·` 或 `,`
- 每个 bullet 一行，太长就压缩
- 2×2 必须用 `<table class="t2x2">`，不要用 CSS Grid
- 羊皮纸底色上不要再叠白卡片，用 1px 边线即可
- 不要 emoji / 圆角 / 阴影 / 渐变

输出 PDF 的两条路径见 `references/layouts-paper.md` 末尾："浏览器 ⌘P 自存 PDF" 或 "WeasyPrint"。

#### 风格 E · 编辑

完整规范见 `references/layouts-editorial.md`。模板自带 6 种版式骨架（封面 / 章节封 / drop-cap 两栏 / stat 三栏 / pull quote dark / CTA box 收束），直接复制 `<section class="slide">` 改文案。

关键硬规则：
- 衬线展示用 Fraunces 900；副标用 `.h-sub` 斜体 italic + 陶土红
- drop cap 整份 deck 只用 1-3 次
- pull quote 用在 `.slide.dark` 页面，1-2 次
- CTA box 整份 deck 只放 1 个
- 文案禁用 marketing 词（颠覆 / 革新 / 赋能）；要有第一人称 + 具体细节 + 观点

写作风格比视觉更重要——见 `layouts-editorial.md` 的"写作风格"段落。

#### 风格 F · 暗夜植物

完整规范见 `references/layouts-botanical.md`。模板自带 6 种版式骨架（居中 italic 封面 / accent-line 章封 / 两栏论述 / spec 三栏 / 极简 timeline / italic + CTA link 收束）。

关键硬规则：
- **不要删光 atmos 软渐变球**——这风格的灵魂
- 衬线大字必须用 `font-weight: 400 italic` 或 `500`，**禁止** 600+
- italic 是主要强调通道（hero / display em / sub / em），不要用 bold 替代
- CTA 是 `<a class="cta-link">` 下划线形式，**不是 boxed**
- 颜色只在 `--accent-warm/-pink/-gold` 三档暖色里选，禁止混入紫/蓝/绿
- 整份 deck 不要超过 12 页（密度低，长了就稀薄）

#### 风格 G · 笔记本

完整规范见 `references/layouts-notebook.md`。模板自带 6 种版式（封面 / 章节封 + 下划线高亮 / 编号笔记列表 / 数据 sticky 网格 / 大引述 / 收束），右侧 6 个彩色 tab 是导航。

关键硬规则：
- **每页 `.tabs` 里有且只有 1 个 `.active`**（拷贝粘贴新页时记得改 active 位置）
- tab 文字 ≤ 8 字母 / 4 汉字
- `.ul-accent` 衬线下划线高亮每页 ≤ 1 处
- sticky note ≤ 3 张并排
- 至少 1 处用 `.handwritten`（签名 / 注脚 / 出处）
- 文案要有"翻开一本本子读到"的亲切感，不要 marketing

#### 风格 H · Bold Signal

完整规范见 `references/layouts-signal.md`。模板自带 6 种版式（封面 hero / 章封 5+7 split / signal list / hero KPI 橙卡 / 全宽 statement / CTA + Q&A 橙卡），12 列 grid 精确对齐。

关键硬规则：
- 顶部 `.section-num` 大编号 + `.crumbs` 面包屑每页必加
- `.signal-card` 整份 deck 颜色统一（建议都 orange，不要混 coral）
- `.cta-big` 整份 deck 只放 1 个
- 大字（`.h-hero` / `.h-display` / `.h-section` / `.h-sub`）**必须 uppercase**
- 文案要短、直接、有具体数字——"3 个工程师，8 周，1 次重写"比"经过深入研究"强 10 倍

#### 风格 I · 终端

完整规范见 `references/layouts-terminal.md`。模板自带 6 种版式（封面 `$ pwd` / ASCII 章封 / `grep` + bullet / 代码 + diff / `stats` KPI / `exit` 收束）。

关键硬规则：
- **只用 JetBrains Mono**——任何其他字体都翻车
- 每页 `.titlebar` 必加（红黄绿点 + 路径 + line:col）
- 代码块用对语法高亮 class（`.kw` / `.fn` / `.ty` / `.str` / `.cm` / `.err`）
- ASCII art 用 box-drawing 字符 + 暗灰色，**不要染绿**
- 闪烁 `.cursor` 整份 deck ≤ 2 处
- 文案要 dev voice：commit message 风、有 stack trace 感、不要 marketing 词

### Step 4 · 对照检查清单自检

- **所有风格**：先过 `references/anti-ai-slop.md` 末尾的"收敛检测"5 问
- **所有横向 / 纵向翻页风格**（A/B/C/E/F/G/H/I）：跑 `node <SKILL_ROOT>/scripts/check-overflow.mjs index.html` 测三个视口下的溢出（依赖 `puppeteer`）
- **风格 A**：用 `references/checklist.md` 全部 P0/P1 自检
- **风格 B**：先跑 `node <SKILL_ROOT>/scripts/validate-swiss-deck.mjs index.html`，再过 `references/checklist.md` 瑞士部分
- **风格 C**：过 `references/layouts-mindmap.md` 末尾的 10 条自检清单
- **风格 D**：过 `references/layouts-paper.md` 末尾的自检清单 + ⌘P 预览看 PDF 出稿效果
- **风格 E**：过 `references/layouts-editorial.md` 末尾的 10 条自检清单
- **风格 F**：过 `references/layouts-botanical.md` 末尾的自检清单
- **风格 G**：过 `references/layouts-notebook.md` 末尾的自检清单
- **风格 H**：过 `references/layouts-signal.md` 末尾的自检清单
- **风格 I**：过 `references/layouts-terminal.md` 末尾的自检清单

**所有风格都必须打开网页看效果**，不只看代码：

1. 用 `open index.html` 打开
2. 等入场动效稳定（约 1-2 秒）再判断
3. 逐页/逐节点检查视觉是否舒服
4. 别扭就回去改版式/树结构/字号，不要靠加 margin 硬救

### Step 4.5 · 可选 · 启用浏览器内编辑

如果用户在 Step 1 选了"需要浏览器内编辑"（适用 A/B/E/F/G/H/I，**不适用 C/D**）：

```bash
node <SKILL_ROOT>/scripts/add-editing.mjs 项目/XXX/ppt/index.html
```

脚本会在 deck 里注入：

- 左上角隐藏热区 + ✏️ 浮动按钮 + 编辑横条
- 全部文字元素的 `contenteditable` 切换
- 自动 800ms debounce 存 localStorage
- `Ctrl/⌘+S` 导出**剥离了 edit 状态的干净 HTML**

完整说明见 `references/inline-editing.md`。脚本幂等——重复跑不会重复注入。

### Step 5 · 本地预览

```bash
open "项目/XXX/ppt/index.html"
```

A/B/C/D/E/F 都不需要本地服务器，图片走相对路径 `images/xxx.png`（A/B/C/D）或 `assets/xxx.png`（E/F）。

风格 D 想出 PDF 时，用浏览器 ⌘P 选"另存为 PDF"+ 自定义纸张 280×158mm + 边距"无" + 勾选"背景图形"；或装 `weasyprint` 跑 `weasyprint index.html out.pdf`。

风格 E/F 字体走 Google Fonts CDN，**首次打开需要联网**等字体加载完。预览离线场景请先 `curl` 下来本地化处理。

### Step 6 · 迭代

根据用户反馈修改。模板的 CSS / JS 已经高度参数化：

- **A/B**：90% 的调整是改 inline style（字号 `font-size:Xvw` / 高度 `height:Yvh` / 间距 `gap:Zvh`）
- **C**：90% 的调整是改 `sourceMarkdown` 的树结构（移动节点、合并、拆分、加图）
- **D**：90% 的调整是改 `<body>` 里的文案；版式相关只动 `.c2` / `.t2x2` / `.co` 的选择，不要改 `<style>` 里的 token
- **E**：90% 的调整是改文案 + 增删 `.slide` `<section>`；版式不要发明新的，从内置 6 种中组合
- **F**：90% 的调整是改文案 + italic 强调位置；不要破坏 atmos 球的氛围
- **G**：调 tab 颜色组合 + sticky note 顺序；不要改纸卡阴影 / 装订孔
- **H**：调 signal-card 数量（≤ 1/页） + crumb 标签；不要把大字从 uppercase 改成 lowercase
- **I**：调代码示例 + ASCII art 内容；不要混入任何非 mono 字体

### Step 7 · 可选 · 部署到 URL

完整路径见 `references/deploy.md`。两条路：

**Vercel**（preview URL，~30s）：

```bash
bash <SKILL_ROOT>/scripts/deploy-vercel.sh 项目/XXX/ppt/
# 加 --prod 直接出 production alias
```

**Cloudflare Workers · `ppt.dairui1.com/<slug>/`**（dairui1 默认）：

```bash
bash <SKILL_ROOT>/scripts/deploy-cloudflare.sh 项目/XXX/ppt/index.html --slug my-talk
# 默认 domain = ppt.dairui1.com / zone = dairui1.com
# 一次性准备：CF 后台加 Custom Domain `ppt.dairui1.com` + `npx wrangler login`
```

两个脚本都有 `--help`。Cloudflare 部署完每个 deck 是独立 worker，可以单独删（`npx wrangler delete --name ppt-<slug>`）。

---

## 资源文件导览

```
dairui-ppt/
├── SKILL.md                  ← 你正在读
├── assets/
│   ├── template-magazine.html  ← 风格 A · 电子杂志风模板
│   ├── template-swiss.html     ← 风格 B · 瑞士国际主义风模板
│   ├── template-mindmap.html   ← 风格 C · 思维导图模板（CSS/JS 已内联）
│   ├── template-paper.html     ← 风格 D · 纸模板（打印优先，字体走 CDN）
│   ├── template-editorial.html ← 风格 E · 编辑风模板（Fraunces，字体走 CDN）
│   ├── template-botanical.html ← 风格 F · 暗夜植物风模板（Cormorant，字体走 CDN）
│   ├── template-notebook.html  ← 风格 G · 笔记本模板（Bodoni Moda + 彩色 tab）
│   ├── template-signal.html    ← 风格 H · Bold Signal 模板（Archivo Black + 橙焦点）
│   ├── template-terminal.html  ← 风格 I · 终端模板（JetBrains Mono only）
│   └── motion.min.js           ← Motion One 本地副本（A/B 离线兜底，约 64KB）
├── scripts/
│   ├── validate-swiss-deck.mjs ← 风格 B 静态校验
│   ├── check-overflow.mjs      ← 通用 · puppeteer 测每页是否溢出 100vh
│   ├── extract-pptx.py         ← .pptx → JSON + 图片的导入工具
│   ├── add-editing.mjs         ← 给 deck 注入 inline editing UI（A/B/E/F/G/H/I）
│   ├── deploy-vercel.sh        ← 部署到 Vercel preview / production
│   └── deploy-cloudflare.sh    ← 部署到 ppt.dairui1.com/<slug>/（Workers）
└── references/
    ├── anti-ai-slop.md       ← 所有风格通用 · 反 AI Slop 守则（先读）
    ├── animation-patterns.md ← 所有风格通用 · 感觉→动效配方对照表
    ├── viewport-rules.md     ← 所有翻页风格通用 · 100vh 硬约束 + clamp() 规则
    ├── style-discovery.md    ← 用户说不清要什么时的 Show-don't-tell 流程
    ├── inline-editing.md     ← 浏览器内编辑 + Ctrl+S 导出的接入说明
    ├── deploy.md             ← Vercel / Cloudflare 两条部署路径
    ├── components.md         ← 组件手册（风格 A 适用）
    ├── layouts.md            ← 风格 A · 10 种页面布局骨架
    ├── swiss-layout-lock.md  ← 风格 B · 原始 22P 版式锁
    ├── layouts-swiss.md      ← 风格 B · 原始 22P 骨架说明 + 实验区
    ├── layouts-mindmap.md    ← 风格 C · 思维导图内容规范与树结构原则
    ├── layouts-paper.md      ← 风格 D · 纸排版规范与 PDF 出稿
    ├── layouts-editorial.md  ← 风格 E · 编辑风版式与写作风格
    ├── layouts-botanical.md  ← 风格 F · 暗夜植物风版式与组件规范
    ├── layouts-notebook.md   ← 风格 G · 笔记本版式 + tab 导航 + sticky note
    ├── layouts-signal.md     ← 风格 H · Bold Signal 版式 + 12 列 grid + 橙焦点
    ├── layouts-terminal.md   ← 风格 I · 终端版式 + 语法高亮 + ASCII art
    ├── themes.md             ← 风格 A · 5 套主题色预设
    ├── themes-swiss.md       ← 风格 B · 4 套瑞士风主题色预设
    ├── image-prompts.md      ← 配图类型、比例和提示词（A/B 共用，C 在 layouts-mindmap.md 末尾）
    └── checklist.md          ← 质量检查清单（P0/P1/P2/P3 分级，A/B 适用）
```

**加载顺序建议**：

1. 先读完 `SKILL.md`（这个文件）了解整体
2. **必读三件套**：`references/anti-ai-slop.md` + `references/viewport-rules.md` + `references/animation-patterns.md`——所有风格通用
3. Step 1 第一问确定风格 A / B / C / D / E / F / G / H / I；如果用户说不清，读 `references/style-discovery.md` 启动 Show-don't-tell 流程
4. **动手前 Read 对应模板**：
   - A → `assets/template-magazine.html` 的 `<style>` 块
   - B → `assets/template-swiss.html` 的 `<style>` 块
   - C → `assets/template-mindmap.html` 直接看 `sourceMarkdown` 那个 `<script type="module">`
   - D → `assets/template-paper.html` 看 `<style>` 顶部的 `:root` token 和 `<body>` 里的 5 种版式骨架
   - E → `assets/template-editorial.html` 看 `<style>` 的 token + `<body>` 里的 6 种版式
   - F → `assets/template-botanical.html` 看 atmos 球的写法 + 6 种版式
   - G → `assets/template-notebook.html` 看 page card + tabs 结构
   - H → `assets/template-signal.html` 看 12 列 grid + signal-card 结构
   - I → `assets/template-terminal.html` 看 titlebar + 代码块语法高亮 class
5. 读对应布局/内容规范：A→`themes.md`+`layouts.md`；B→`themes-swiss.md`+**先 `swiss-layout-lock.md`**+`layouts-swiss.md`；C→`layouts-mindmap.md`；D→`layouts-paper.md`；E→`layouts-editorial.md`；F→`layouts-botanical.md`；G→`layouts-notebook.md`；H→`layouts-signal.md`；I→`layouts-terminal.md`
6. 配图时读 `image-prompts.md`（A/B/E/H 共用）或 mindmap prompt（C）；D/F/I 通常不配大量图，G 配 sticky 风格
7. 用户需要浏览器内编辑：`node scripts/add-editing.mjs index.html`，配 `references/inline-editing.md`
8. 用户要分享 / 部署：`references/deploy.md` → Vercel 或 Cloudflare Workers
9. 生成后跑校验：`node scripts/check-overflow.mjs index.html`（通用）+ `node scripts/validate-swiss-deck.mjs`（仅 B）
10. **所有风格**：交付前过 `anti-ai-slop.md` 末尾的"收敛检测"5 问 + 对应 layouts 末尾的自检清单

## 核心设计原则（哲学）

### 风格 A · 电子杂志风

1. **克制优于炫技** — WebGL 背景只在 hero 页透出
2. **结构优于装饰** — 不用阴影、浮动卡片、padding box，靠**大字号 + 字体对比 + 网格留白**
3. **内容层级由字号和字体共同定义** — 衬线 = 标题，非衬线 = 正文，等宽 = 元数据
4. **图片是第一公民** — 图片只裁底部，网格用 `height:Nvh` 固定
5. **节奏靠 hero 页** — hero 和 non-hero 交替
6. **术语统一** — Skills 就是 Skills，不要中英混合翻译

### 风格 B · 瑞士国际主义风

1. **单一锚点色** — 一份 deck 只用一个 accent
2. **极致字号对比** — 主标题与正文比例 ≥ 8:1
3. **无衬线只此一家** — Inter / Helvetica / Noto Sans SC
4. **直角纯色** — 不允许渐变 / 阴影 / 圆角（rule 横线除外）
5. **网格至上** — 所有元素吸附到 12-col grid
6. **Hairline 是手术刀** — 1px 极细分割线就够
7. **点阵装饰只在 hero 页透出**

### 风格 C · 思维导图

1. **树结构 = 内容结构** — 不要为了形状而牺牲逻辑，也不要为了塞内容硬拆树
2. **preorder 是叙事顺序** — 父先于子，不要让父节点剧透
3. **父节点导览、子节点揭细节** — 别把判断放在叶子上
4. **图片只放高信息量节点** — 框架 / 对比 / 流程 / 架构，不要在细枝末节配图
5. **节点不是句子** — 一个节点一个完整小论点（约 10-80 字）
6. **不要改样式** — 视觉已经调好，改了反而容易翻车

### 风格 D · 纸

1. **打印是第一公民** — 所有版式按 280×158 mm 单页设计，不是为屏幕滚动设计
2. **字距比字号重要** — 中文字距 `0.3pt` 是密度感的关键，不要碰
3. **章节编号用 `.eyebrow`** — 不要整页大蓝色分隔页
4. **羊皮纸 + 墨水蓝 + 衬线** — 三个变量决定一切，不要混入别的色
5. **2×2 用 table** — Grid 行高不对齐，纸面最忌错位
6. **留白是有意的** — 底部 `.co` callout 上方那块空白是结构，不是 bug

### 风格 E · 编辑

1. **文案 > 视觉** — Fraunces 字体只是壳；杂志感的灵魂在写作语气
2. **第一人称 + 具体细节 + 观点** — 不要 marketing hype
3. **斜体衬线副标是节奏点** — `.h-sub` italic 是 *Monocle* 跟 SaaS 的分界
4. **drop cap / pull quote / CTA box 各只用 1-3 次** — 用多了就 cheesy
5. **明暗交替** — 全 light 没呼吸，全 dark 太重
6. **几何装饰用圆 / 点 / 线 / 矩形** — 不要画箭头 / 心形 / 复杂图形

### 风格 F · 暗夜植物

1. **优雅 > 高效** — 这风格不卖效率，卖品味
2. **斜体是主强调通道** — 不要用 bold 替代 italic
3. **轻字重** — 衬线 400-500、无衬线 300-400；font-weight ≥ 600 = 立刻翻车
4. **atmos 球是氛围** — 不要删光、不要换成实色块
5. **暖色三档** — accent-warm / accent-pink / accent-gold；混进紫蓝绿 = 失去 Aman / Aesop 调性
6. **不要超过 12 页** — 这风格密度低，长了就稀薄

### 风格 G · 笔记本

1. **手感是灵魂** — 装订孔 / 微旋转 sticky / 手写注脚不能丢
2. **彩色 tab 是导航 + 视觉锚** — 不要美化成花边
3. **下划线高亮 ≤ 1/页** — 用多了变 cheesy
4. **保留"未完成"感** — 笔记本是活的，不要写满
5. **第一人称、有反思** — 像在记自己的本子，不是写给广告主

### 风格 H · Bold Signal

1. **大字 + 橙焦点 = 单一视觉决定** — 一份 deck 不要冲突
2. **大字必须 uppercase** — Archivo Black 的灵魂
3. **每页 ≤ 1 个 signal-card / ≤ 1 个 CTA** — 焦点失守 = 风格失守
4. **数字 + 短句** — "3 个工程师，8 周" > "经过深入研究"
5. **12 列 grid 精确对齐** — 不要居中堆叠

### 风格 I · 终端

1. **只用 JetBrains Mono** — 混任何其他字体都翻车
2. **每页有 titlebar** — 红黄绿点 + 路径 + line:col
3. **代码块语法高亮要用对** — 不是把全部染绿
4. **ASCII art 用暗灰不染色** — 终端绿留给真正的 accent
5. **dev voice 写作** — 像写 commit message / README，不写营销

## 风格锚点

可以把这些当做九种风格的美学参照：

- **A**：*Monocle* 杂志版式
- **B**：Massimo Vignelli / *Helvetica Forever* / Josef Müller-Brockmann；当代 Acne Studios / Off-White / IKEA / Beck Design
- **C**：用树结构组织叙事节奏的演讲脚本
- **D**：editorial 杂志的纸面排版、研究所白皮书、TsangerJinKai02 的中文衬线现代化
- **E**：*The New Yorker* / *Cereal* / *Wired* / *Kinfolk* / Pentagram 改版
- **F**：Aman / Aesop lookbook / *The Gentlewoman* / *Anothermag* / 香水广告
- **G**：Hobonichi / Field Notes / Moleskine / 北欧文具店
- **H**：Nike 发布会 / YC demo day / *Wired* 早期 / 体育杂志大字封面
- **I**：90s BBS / Linux TTY / VS Code / Neovim 全屏 demo / 黑客松 demo day
