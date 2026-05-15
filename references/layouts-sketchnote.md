# 风格 J · Sketchnote（手绘笔记）布局与内容规范

模板：`assets/template-sketchnote.html`。横向翻页 PPT，**米色方格纸 + 手抖墨线方块 + 高光记号笔背景 + sticky note + 胶带角**。字体走 Google Fonts CDN（Kalam 印刷体手写）+ jsDelivr（LXGW WenKai 笔锋楷书）+ JetBrains Mono。

不是 Hobonichi 整洁手账（那是风格 G · Notebook）。这一支更"草图本"——会议白板、解释技术系统的便条纸、设计师的 thinking sketch。**追求"在 paper 上随手画的"质感**，不追求"做得像印刷品"。

## 美学锚点

- Tim Brown / IDEO 的 design thinking 草图
- *Visual Meetings* / *The Back of the Napkin* 那种解释复杂系统用的草绘
- David Bayles & Ted Orland *Art & Fear* 的内页手记
- **不是**：Notion app 截图、Excalidraw 默认 demo、Coggle 思维导图

## 设计语言（已固定，不要改）

### 底色 + 网格纸

```css
--paper:#fbf9f0;
--paper-2:#f5f1e0;
--grid:#c3d9e8;
```

```css
body{
  background-image:
    repeating-linear-gradient(0deg, transparent 0, transparent 27px, var(--grid) 27px, var(--grid) 28px),
    repeating-linear-gradient(90deg, transparent 0, transparent 27px, var(--grid) 27px, var(--grid) 28px),
    radial-gradient(circle at 80% 10%, rgba(255,200,150,.18), transparent 50%),
    radial-gradient(circle at 10% 90%, rgba(255,220,150,.18), transparent 50%);
  background-size: 28px 28px, 28px 28px, 100% 100%, 100% 100%;
}
body::before{
  content:'';position:fixed;inset:0;pointer-events:none;
  box-shadow: inset 0 0 80px rgba(120,90,40,.08), inset 0 0 200px rgba(120,90,40,.04);
}
```

28px 网格 + 双向暖光晕 + 边缘内阴影 = 翻开的笔记本纸感。

### 墨色 + 强调色

```css
--ink:#1a1a1a;        /* 主墨色 */
--ink-2:#3a3a3a;      /* 次墨色 */
--ink-3:#6b6b6b;      /* 三级灰 */
--blue:#1e5fa6;       /* 蓝笔 */
--red:#c43a2d;        /* 红笔 / 强调 */
--green:#3a8e3a;      /* 绿笔 / ✓ */
--orange:#e07b1f;     /* 橙笔 / ⚠ */
```

### 高光记号笔色（背景刷涂用，半透明）

```css
--hl-yellow:rgba(255,224,80,.55);
--hl-pink:rgba(255,140,160,.45);
--hl-cyan:rgba(120,210,230,.45);
/* sticky note / 实色版本 */
--hl-yellow-solid:#fff5a3;
--hl-pink-solid:#ffd2db;
--hl-cyan-solid:#bff0f7;
```

**用法**：`<b>` `<u>` `<em>` 不再代表语义粗体下划线，重新定义成三种荧光笔色：

```css
.body b{font-weight:400;background:var(--hl-pink);padding:0 3px;color:var(--ink)}
.body u{text-decoration:none;background:var(--hl-cyan);padding:0 3px}
.body em{font-style:normal;background:var(--hl-yellow);padding:0 3px;color:var(--ink)}
```

这样写"标记重点"就一行 HTML：`<u>用 update_goal</u> 的 status 锁成 <em>只能写 complete</em>`。

## 字体（三支，靠字重做层级）

```css
:root{
  --hand: 'Kalam', 'LXGW WenKai', 'PingFang SC', cursive;
  --mono: 'JetBrains Mono', 'LXGW WenKai Mono', 'PingFang SC', monospace;
}
```

```html
<link href="https://fonts.googleapis.com/css2?family=Kalam:wght@300;400;700&family=JetBrains+Mono:wght@400;500;600;700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/lxgw-wenkai-webfont@1.7.0/style.css">
```

| 字体 | 角色 | 字重 |
|---|---|---|
| **Kalam** | 英文手写主字体 | 300 / 400 / 700 |
| **LXGW WenKai** 霞鹜文楷 | 中文配对（笔锋楷书） | 单字重，靠 Kalam 那边定权重 |
| **JetBrains Mono** | 代码 / 标识符 / file:line / 时间戳 | 400 / 500 / 600 / 700 |

### 字重 → 角色映射

| 角色 | 字重 | 字号 |
|---|---|---|
| Display 大标题（封面 h1） | 700 | 48-64px |
| Section 标题（h2） | 700 | 30-40px |
| 子标题 / sticky note 标题 | 700 | 19-24px |
| 正文 / 标签 / 旁注 | 400 | 15-19px |
| 极细补充（日期 / metadata） | 300 | 12-14px |

### 不要犯的坑

- **绝对不要** 在 LXGW WenKai 单字重上设 `font-weight: 500/600`。浏览器合成粗体在小字号下会糊成一团黑（这一坑踩过）。
- **绝对不要** 用 Patrick Hand / Architects Daughter / Shadows Into Light 这些单字重 Google Fonts 当主字体——同上，权重一上就糊。
- **不要** 用 Caveat：它是连写草体，在 14-18px 这种 body 字号下技术标识符（`update_goal` 这种）字母全连起来读不清。Kalam 是印刷体手写，字母分得开。
- **代码 / 函数名 / 表名 / file:line 永远用 mono**，哪怕在散文中 inline 也用 `<code>` 套住。不要把 `update_goal` 写成手写体。

## 关键组件

### 抖动滤镜（hand-drawn rectangle）

```html
<svg width="0" height="0" style="position:absolute" aria-hidden="true">
  <defs>
    <filter id="wobble" x="-2%" y="-2%" width="104%" height="104%">
      <feTurbulence type="fractalNoise" baseFrequency="0.018" numOctaves="2" seed="3"/>
      <feDisplacementMap in="SourceGraphic" scale="1.6"/>
    </filter>
  </defs>
</svg>
```

任意 `<rect>` 加 `class="sk-rect"`（带 `filter:url(#wobble)`）就变成"手画的方块"。

```css
.sk-rect{
  fill: rgba(255,253,242,.85);
  stroke: var(--ink);
  stroke-width: 2.4;
  filter: url(#wobble);
}
```

### ⚠ 关于 filter / stroke 的两个大坑

SVG 的 `filter` 和 `stroke` 属性会**继承**到子元素，HTML 的 `border` 不会。所以：

> **不要把 `.sk-rect` / `filter` / `stroke` 这类规则放在 `<g>` 上。**

如果你把 `filter:url(#wobble)` 挂在一个包含 `<text>` 的 `<g>` 上，每一个字都会被 `feDisplacementMap` 位移成糊状。同理 `stroke:var(--ink); stroke-width:1.8` 挂在 `<g>` 上，所有子 `<text>` 都会被一圈黑墨水描边，在 12-16px 字号下看起来像"特别加粗的糊字"，根本读不清。

**做法**：把 `filter` / `stroke` 放在内部承载视觉的 `<rect>` / `<circle>` / `<path>` 上，**绝不放在含文本的 group 上**。如果一个 class 既挂在 group 又挂在 rect 上（比如 `.sk-tool` 同时给 `<g>` 做 opacity transition 又给 `<rect>` 做 fill/stroke），**拆成两个 class**：

```css
/* 给 rect 用 */
.sk-tile{fill:rgba(255,253,242,.7); stroke:var(--ink); stroke-width:1.8; filter:url(#wobble)}
/* 给 group 用 */
.sk-tile-grp{opacity:0; transition:opacity .35s}
.sk-tile-grp.shown{opacity:1}
```

### Sticky Note（便签）

```html
<div class="sticky">
  <span class="who">⚠ 注意</span>
  这条 enum 在 SQL 层就锁死了，不是 prompt 教育。
</div>
```

```css
.sticky{
  background: var(--hl-yellow-solid);
  padding: 12px 14px;
  font-family: var(--hand);
  font-size: 15px; color: var(--ink); line-height: 1.45;
  box-shadow: 2px 3px 4px rgba(0,0,0,.18);
  transform: rotate(-2deg);
  max-width: 220px;
  border: 1px solid rgba(0,0,0,.08);
}
.sticky.pink{background: var(--hl-pink-solid); transform: rotate(2deg)}
.sticky.cyan{background: var(--hl-cyan-solid); transform: rotate(-1.5deg)}
.sticky .who{
  display: block; margin-bottom: 4px;
  font-weight: 700; color: var(--red);
}
```

每个 sticky 旋转角度 `-3deg` 到 `+3deg` 随机一点，避免对得太齐。

### 胶带角（Tape Corner）

便签四角或纸卡顶角的"贴胶带"装饰：

```html
<span class="tape tl"></span>
<span class="tape tr"></span>
```

```css
.tape{
  position: absolute;
  width: 70px; height: 18px;
  background: rgba(255,220,140,.7);
  border: 1px dashed rgba(0,0,0,.18);
  pointer-events: none;
}
.tape.tl{top:-8px; left:-12px; transform: rotate(-14deg)}
.tape.tr{top:-8px; right:-12px; transform: rotate(12deg)}
```

### 笔记卡（Page Card）

每页内容卡：`box-shadow + dashed border` 假装是从笔记本撕下来的纸。

```css
.page-card{
  background: rgba(255,253,242,.55);
  border: 2px dashed var(--ink-3);
  box-shadow: 4px 4px 0 rgba(0,0,0,.06);
  padding: 36px 40px;
  position: relative;
}
```

### 旋转抖动（Hand Imperfection）

所有"重要元素"轻微旋转 `-1deg` 到 `+1deg` 之间，模拟手画时手腕的不稳定：

```css
.head h1{transform: rotate(-.4deg)}
.head .date{transform: rotate(-1deg)}
.scene-card h2{transform: rotate(-.3deg)}
```

不要旋转得太狠，0.3-1.2deg 是甜区，过了就显刻意。

## 标准版式

### V1 · 封面（Cover）

```
┌──────────────────────────────────────┐
│                                       │
│        — 副标 / date / context —     │
│                                       │
│        ⟦ 主标题 - Display 64px ⟧      │
│                                       │
│        sub-tagline / aside           │
│                                       │
└──────────────────────────────────────┘
```

- 主标题用 Kalam 700 大字号，关键词套 `<span class="hl">` 高光黄背景
- 上方放小日期 / 上下文（Kalam 300 12-14px）
- 下方放一行 sub（不要写 marketing tagline——参考 `anti-ai-slop.md`）

### V2 · 章节封 / 大标语

满版一张大字标语：用 highlighter strokes 涂关键词。最多 2 行。

### V3 · 编号笔记列表（Numbered Notes）

```
1. 第一条要点  ─────────────────────────
   ↳ 一句补充：file_path:line + 锚点

2. 第二条要点  ─────────────────────────
   ↳ 一句补充

…
```

```html
<ol class="notes">
  <li>
    <div class="head">第一条要点</div>
    <div class="ref">↳ 补充 · <code>file_path:line</code></div>
  </li>
  ...
</ol>
```

```css
.notes li{padding: 16px 0; border-bottom: 1px dashed rgba(0,0,0,.15)}
.notes li .head{font-size: 22px; font-weight: 700}
.notes li .ref{font-size: 14px; color: var(--ink-3); margin-top: 4px}
```

### V4 · Sticky 网格（3-4 张便签）

3 张或 4 张 sticky note 散布在页面上，每张一个 micro-fact。便签之间错开角度 + 错开位置，不要排成网格。可叠加 `<svg>` 手画箭头连接。

### V5 · 大引述 / 金句（Pull-quote）

```html
<blockquote class="pq">
  <span class="mark">"</span>
  这句话是关键 punchline，控制在 20 字以内。
  <cite>— 出处 / file:line</cite>
</blockquote>
```

字号 32-48px，旋转 -1deg，外加一个圆圈或方框手画框（用 SVG path + wobble）。

### V6 · 代码 + 注解（Code with Annotation）

代码块用 mono，左侧贴一条 sticky note 解释 trap / 关键行。

```html
<div class="code-anno">
  <pre><code class="lang-rust">
fn continuation_candidate_if_idle() {
  if !Feature::Goals { return None; }   <span class="hl">// L1 总闸</span>
  if mode == Plan { return None; }       <span class="hl">// kill</span>
}
  </code></pre>
  <div class="sticky pink">
    <span class="who">⚠ trap</span>
    Plan 模式是红 KILL，不放行。
  </div>
</div>
```

### V7 · 收束（End / Sign-off）

简单一句 + 手画签名（`Shadows Into Light` 这种 brush 字体一次性出现可以——但仅此一次）。

## 何时用这个风格

适合：
- **解释复杂系统 / 流程**：边讲边画的感觉
- **设计思考 / 头脑风暴汇报**：草稿气质
- **会议演示 / 内部分享**：友善、不正式
- **技术博客的"图解"**：单页或几页插图

不适合：
- 正式发布会 / 投资人路演 → 走风格 B（瑞士）或风格 E（编辑）
- 数据 / 表格密集型 → 走风格 B 或风格 D
- 需要打印 PDF 异步阅读 → 走风格 D（Paper），打印背景色会浪费墨水

## Anti-AI-Slop 应用到本风格

**手绘风格特别容易让 LLM 生成"AI 味"中文**：

- 不写 `X · Y · Z 都还在` 这种中点列举
- 不写 `被 X 接住、被 Y 包起来、被 Z 按下` 这种排比被动句
- 不写 "把整条管线压缩成一句" 的 punchline summary
- 不让每个组件都成精拟人化（"SQLite 守门员"、"Runtime 的天下"——一次以内还行，整篇这样就 AI 了）

具体反例和正例见 `anti-ai-slop.md`。

## 自检清单

发出去前过一遍：

- [ ] 整个 deck 只用 **3 个字体**（Kalam + LXGW WenKai + JetBrains Mono），没混进 Patrick Hand / Caveat / Architects Daughter / Shadows Into Light（除非签名页那一次）
- [ ] 没有任何 `<g>` 上有 `filter:url(#wobble)`（应该挂在内部 rect/path 上）
- [ ] 没有任何 `<g>` 上有 `stroke:` 描边（同上）
- [ ] 没有任何 Kalam / LXGW WenKai 元素被设 `font-weight: 500` 或 `600`（这俩字重 Kalam 不存在，会合成粗体糊掉）
- [ ] 技术标识符（函数名、表名、`file:line`）都在 `<code>` / mono 里
- [ ] 副标 / 段落 / colophon 没有 AI 味中文（参考 `anti-ai-slop.md`）
- [ ] 旋转角度都在 `-1.5deg` 到 `+1.5deg`，没有 5deg 这种过度旋转
- [ ] 至少 3 处用了 highlighter `<b>` / `<u>` / `<em>` 标记重点，不是全篇平铺
- [ ] 每页至少一个 sticky note 或胶带角，提示这是"手贴上去的"
- [ ] 没有 `text-shadow` / 渐变背景（这风格的视觉粗砺感不要被柔化）

## 进阶：和"多幕动画 pattern"组合

这个风格可以和 `references/animation-multi-scene.md` 描述的多幕动画 pattern 组合，做成"边讲边演"的动态 demo——左讲右演、自动播放、手抖墨线动画。canonical 例子见 README 里链接的 demo。
