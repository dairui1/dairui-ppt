# 风格 H · Bold Signal 布局与内容规范

模板：`assets/template-signal.html`。单文件 HTML，横向翻页，**深灰底 + 巨大编号 + 橙色焦点卡 + 12 列 grid**。字体走 Google Fonts CDN（Archivo Black / Space Grotesk / JetBrains Mono）。

## 设计语言

- **底色**：暗灰渐变 `linear-gradient(135deg, #1a1a1a, #2d2d2d, #1a1a1a)`
- **焦点色**：vivid orange `#FF5722`（卡片背景、KPI 大数字、accent 强调）
- **辅助色**：`#FF7043` coral、`#FFC107` amber（h-sub 副标）
- **字体**：
  - 展示用 `Archivo Black`（**只有 weight 900，全部大写**）
  - 正文 `Space Grotesk`（400/500/700）
  - 等宽 `JetBrains Mono`
- **关键质感**：12 列 grid 精确对齐 + 巨大编号 + 高反差 + 全部 uppercase

## 美学锚点

- 体育杂志 / Nike 发布会视觉
- 极客大会的 keynote slides
- Y Combinator demo day deck
- *Wired* 早期版面
- **不是**：SaaS 营销页 / 招股书 / 学术 poster

## 字号层级表

| Class | 字号 | 用途 |
|---|---|---|
| `.section-num` | display 900 `clamp(2.8rem, 5.5vw, 4.6rem)` | 顶部大编号 |
| `.h-hero` | display 900 `clamp(3.6rem, 9vw, 7.8rem)` uppercase | 封面 / statement |
| `.h-display` | display 900 `clamp(2.6rem, 6vw, 4.8rem)` uppercase | 章节 / 收束 |
| `.h-section` | display 900 `clamp(2rem, 4vw, 3rem)` uppercase | 内页标题 |
| `.h-sub` | sans 700 `clamp(1rem, 1.6vw, 1.3rem)` amber uppercase | 副标，**高对比强调** |
| `.lead` | sans 400 `clamp(1rem, 1.35vw, 1.18rem)` | 引导段 |
| `.body-text` | sans 400 `clamp(0.92rem, 1.15vw, 1.05rem)` | 正文 |
| `.kpi-num` / `.card-num` | display 900 巨大 + orange | 数据 |

**核心比例**：display 字号 ÷ 正文字号 ≥ 8:1，这是 Bold Signal 的灵魂。

## 6 种内置版式

| 序号 | 版式 | 用途 |
|---|---|---|
| 1 | 封面（big number 00）+ 全宽 hero | 第 1 页 |
| 2 | 章节封 · 5+7 split + 橙卡 | 每章开头 |
| 3 | 编号 signal list（4 条） | 关键论点 |
| 4 | Hero KPI 橙卡 + KPI stack | 数据集中页 |
| 5 | 全宽 statement / pull quote | 强势主张 |
| 6 | 收束 CTA + 橙卡（Q&A） | 最后一页 |

## 关键组件

### Section number（巨大编号）

```html
<div class="section-num">01</div>
```

每页顶部左侧的大编号（00 / 01 / 02 ...）。**必保留**——是这风格的视觉锚点。

### Crumbs（顶部面包屑）

```html
<div class="crumbs">
  <span class="item">Cover</span>
  <span class="item active">01</span>
  ...
</div>
```

每页 6 项面包屑，`.active` 是当前页。**点击直接跳页**（JS 实现）。

### Signal Card（橙色焦点卡）

```html
<div class="signal-card">
  <div class="card-label">Section 01</div>
  <div class="card-num">01</div>
  <div>
    <div class="card-title">章节短名</div>
    <div class="card-note">说明</div>
  </div>
</div>
```

- **整页只能有 1 个 signal-card**——多了失去"焦点"
- 用在：章节封左侧 5 列 / 数据页左侧 4 列 / 收束页右侧 5 列
- 颜色 default 是 `--card-orange`，必要时换 `--card-coral` 或 `--card-amber`，但**整份 deck 只用一种 card 颜色**

### Signal List（编号列表）

```html
<ul class="signal-list">
  <li><span class="num">01</span><span class="text"><strong>标题。</strong>陈述。</span></li>
  ...
</ul>
```

- 编号是 orange、mono、带空隙
- 标题加粗（白色），描述次级灰
- **4-5 条最佳**，6 条以上拆页

### KPI Row（数据条目）

```html
<div class="kpi-row">
  <span class="kpi-num">2.4×</span>
  <div class="kpi-meta">
    <span class="label">指标 B</span>
    <span class="desc">对比基线 / 归因</span>
  </div>
</div>
```

- 左大数字（orange，display 900）+ 右描述
- 行间 hairline 分隔
- **最多 3 行** + 一个 signal-card 已经够撑一页数据

### CTA Big（橙色大按钮）

```html
<a class="cta-big" href="#">GET IN TOUCH <span class="arrow">→</span></a>
```

- 橙底黑字 + display 字体 + uppercase
- hover 右移 6px
- **整份 deck 只放 1 个**

### Progress Segments（底部分段进度条）

```html
<div class="progress-segments">
  <span class="seg active"></span>
  <span class="seg"></span>
  ...
</div>
```

每段是一格小方块（不连贯条），更"硬朗"。`.active` 是当前页。

## 写作风格

| ✓ 这样写 | ✗ 不要这样 |
|---|---|
| "我们做了一件事：把 X 砍到 1/3。" | "我们提供创新的解决方案" |
| "8 周。3 个工程师。1 次重写。" | "经过深入的调研和精心的设计..." |
| "你不需要更多功能。你需要更少错误。" | "持续优化，赋能用户" |
| 短句、命令式、有数字 | 复合长句、形容词堆砌 |

要点：
- **大字承担情绪**——文案要配得上大字
- **每页一个 statement**——不要塞 5 个论点
- **uppercase 是节奏**——`.h-hero` / `.h-display` / `.h-section` / `.h-sub` 全部大写
- **数字越具体越好**——"提升 60%" 不如 "从 12 秒压到 4.8 秒"
- **直接 / 短促**——Bold Signal 不是"绕弯说"

## 节奏推荐

```
1 封面（00 · 大字 hero）
2 章节封 01（橙卡 + 5+7 split）
3 编号 signal list（论点）
4 KPI hero（橙卡大数 + KPI stack）
5 statement（全宽大字主张）
6 收束（CTA + 橙卡 Q&A）
```

6 页是甜点。8-10 页需要复用：多个章节封共享橙卡版式、多个 statement 共享布局。**不要超过 12 页**——这风格密度高，容易疲劳。

## 自检清单

1. `<title>` 替换、无 `[必填]`
2. 占位符 `{{...}}` 全填
3. 每页顶部都有 `.section-num`
4. 每页 `.crumbs` 里有且只有 1 个 `.active`
5. 每页 `.progress-segments` 里有且只有 1 个 `.active`，位置和当前页对齐
6. 整份 deck `.signal-card` 颜色统一（建议都用 orange，不要混 coral）
7. 整份 deck `.cta-big` 只出现 1 次
8. 所有 `.h-hero` / `.h-display` / `.h-section` / `.h-sub` 都是 uppercase
9. 文案用了具体数字 + 短句
10. 浏览器测试：点 crumb 跳页、滚轮、键盘、触屏都能用

## 不要做的事

- ❌ 不要把 Archivo Black 换成 Inter Bold——丢失"signage"质感
- ❌ 不要把橙色换成"AI 默认紫"
- ❌ 不要在同一份 deck 里用两个不同颜色的 signal-card
- ❌ 不要让大字变 lowercase（违反风格灵魂）
- ❌ 不要超过 1 个 CTA / 1 个 signal-card per page
- ❌ 不要圆角 > 0
- ❌ 不要 emoji
- ❌ 不要用衬线字体
- ❌ 不要 marketing 复合长句（赋能 / 颠覆 / 革新 全部禁）
