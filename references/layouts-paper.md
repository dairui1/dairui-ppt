# 风格 D · 纸（Paper）布局与排版规范

风格 D 不走"交互翻页"路线，它是**打印优先 / 浏览器可滚预览**的纸质感 deck：每个 `<section class="slide">` 在打印模式下是一张独立纸页（默认 280×158 mm），浏览器里则纵向罗列；最终通过浏览器 print-to-PDF 或 WeasyPrint 转成 PDF 分享。

模板：`assets/template-paper.html`。

## 设计语言（已固定，不要改）

- **底色**：暖灰羊皮纸 `--parchment: #f5f4ed`
- **强调色**：墨水蓝 `--brand: #1B365D`
- **正文色**：近黑 `#141413` / 暗暖 `#3d3d3a` / 橄榄 `#504e49` / 石灰 `#6b6a64`
- **字体**：
  - 衬线主字 `TsangerJinKai02`（仓颉今楷，已用 jsdelivr CDN 引入）
  - 等宽 `JetBrains Mono`
  - 英文 fallback `Charter / Georgia`
- **字号 / 行距 / 字距**：CJK 用 13pt + 1.55 行距 + 0.3pt 字距；`letter-spacing` 比 `font-size` 更影响中文密度感
- **页面尺寸**：默认 `280mm 158mm`（约 16:9 横版），可在 `@page` 和 `.slide` 里同步改

| 尺寸 | 用途 |
|---|---|
| `280mm 158mm` | 默认，标准密度，适合大多数 deck |
| `297mm 167mm` | 每页需要稍多空间 |
| `338mm 190mm` | 内容很重 / 多数据点 |

## 字号层级表

| 元素 | 字号 | 字重 | 备注 |
|---|---|---|---|
| `.cover h1` | 38pt | 500 | 封面主标题，居中 |
| `h2` | 24pt | 500 | 内页标题；`margin-bottom: 14pt` |
| `h3` | 15pt | 500 | 小节标题；颜色 `var(--brand)` |
| `.eyebrow` | 9.5pt | 400 | 等宽 mono，`letter-spacing: 2pt`，颜色石灰；用于章节编号 |
| `.lead` | 12pt | 400 | h2 下方引导语；颜色橄榄 |
| `.mt` | 16pt | 500 | 模块标题，搭配 `.ml` |
| `.ml` | 24pt | 500 | 模块前的大写字母前缀（A/B/C/D），墨水蓝 |
| `.ms` | 7.5pt mono | 400 | 模块小标，下边线 |
| `.mb` | 11pt | 400 | 模块正文 |
| `.mi` | 11pt | 400 | 模块行项目 |
| `.mc` | 9.5pt | 400 | 节奏 / 注脚，上边线 |
| `.co` | 11pt | 500 | 底部 callout 结论，绝对定位 `bottom: 12mm` |

## 内容版式（模板自带 4 种）

模板里给了 4 个示例 slide，直接复制粘贴改文案即可。

### 1. 封面（`.slide.cover`）

```html
<section class="slide cover">
  <h1>{{标题}}</h1>
  <div class="sub">{{副标题}}</div>
  <div class="meta">{{作者}} · {{日期}}</div>
</section>
```

- 居中三段式：主标题 / 副标题 / meta
- 不要加横线、装饰边框、logo block

### 2. 两栏（`.c2`）

```html
<section class="slide">
  <span class="eyebrow">01 · {{章节}}</span>
  <h2>{{页面标题}}</h2>
  <p class="lead">{{引导语}}</p>
  <div class="c2">
    <div><h3>{{左栏标题}}</h3><p class="mb">{{左栏内容}}</p></div>
    <div><h3>{{右栏标题}}</h3><p class="mb">{{右栏内容}}</p></div>
  </div>
  <div class="page-num">01</div>
  <div class="footer-mark">{{项目名称}}</div>
</section>
```

- `.c2` 用 CSS Grid `1fr 1fr` + `gap: 22pt`
- 两栏内容高度可以不同

### 3. 2×2 模块（`table.t2x2`）

```html
<table class="t2x2">
  <tr>
    <td><div class="mt"><span class="ml">A</span>{{模块标题}}</div><p class="mb">{{模块描述}}</p></td>
    <td><div class="mt"><span class="ml">B</span>{{模块标题}}</div><p class="mb">{{模块描述}}</p></td>
  </tr>
  <tr>
    <td><div class="mt"><span class="ml">C</span>{{模块标题}}</div><p class="mb">{{模块描述}}</p></td>
    <td><div class="mt"><span class="ml">D</span>{{模块标题}}</div><p class="mb">{{模块描述}}</p></td>
  </tr>
</table>
```

- **必须用 `<table class="t2x2">` 而不是 CSS Grid**。Grid 不保证跨格行高一致，纸质感最忌错位。

### 4. 底部 callout（`.co`）

```html
<section class="slide">
  <span class="eyebrow">03 · {{章节}}</span>
  <h2>{{页面标题}}</h2>
  <p class="mb">{{正文内容}}</p>
  <div class="co">{{底部结论或关键判断}}</div>
</section>
```

- `.co` 绝对定位 `bottom: 12mm; left: 20mm; right: 20mm`
- 上面的留白是有意的，不要往里塞东西去填

### 5. 数据表（`table.data`）

```html
<table class="data">
  <tr><td>{{维度}}</td><td>{{内容}}</td><td>{{备注}}</td></tr>
  <tr><td>{{维度}}</td><td>{{内容}}</td><td>{{备注}}</td></tr>
</table>
```

- 首列墨水蓝、字重 500，作为索引
- 用 `border-bottom: 0.3pt solid var(--border)`，不画完整网格线

## 硬规则（违反会破坏纸质感）

| 规则 | 细节 |
|---|---|
| 不要章节分隔大蓝页 | 用 `.eyebrow` 写章节编号代替；省一页 |
| 不要中文括号 | `（...）` 替换为 `·` 或 `,` |
| 每个 bullet 一行 | 太长就压缩，宁可拆点也不要换行 |
| 2×2 用 table 不用 grid | 行高对齐 |
| 不要在羊皮纸底色上加白卡片 | 用 1px 边线分隔即可 |
| 不要 emoji | 用排印代替 |
| 不要圆角阴影渐变 | 全直角、薄边线 |

## 留白处理

页面留白原则（按优先级）：

1. 缩小 `@page` 尺寸（从 338→297→280）
2. 钉一个 `.co` 底部 callout
3. 加内容
4. 合并两页

不要靠加 `margin` 硬撑。

## SVG 约束（嵌入图表 / diagram 时）

- `viewBox` 宽度固定 920，高度按内容
- `svg` 元素加 `max-height: 105mm` 防溢出
- **不支持** `fill="url(#gradient)"`、SVG 内的 CSS Grid（如果用 WeasyPrint 出 PDF）
- 箭头必须用 `<path>` 元素显式画，`marker-end` 在 WeasyPrint 里不会旋转

## 三种出稿路径

### A. 浏览器预览（开发态）

```bash
open index.html
```

直接在浏览器里纵向滚动看效果，所见即所改。

### B. 浏览器 print-to-PDF（最简单）

1. 浏览器打开 `index.html`
2. ⌘P → 目标"另存为 PDF"
3. 纸张大小选"自定义" → 输入 `280×158 mm`（或你设置的尺寸）
4. 边距选"无"
5. 勾选"背景图形"，否则羊皮纸底色丢失

### C. WeasyPrint（最稳，字体最准）

```bash
pip install weasyprint
weasyprint index.html out.pdf
```

WeasyPrint 严格遵守 `@page` 规则，输出像素级精准。中文字距、字重、CJK 间距都和浏览器一致。

## 自检清单

写完一份 paper deck 后逐项过：

1. `<title>` 已替换，不再含 `[必填]`
2. 所有 `{{...}}` 占位符都已填充，没有遗留
3. 没有中文全角括号 `（）`
4. 每个 bullet 都是一行
5. `.eyebrow` 用做章节编号，没有出现整页蓝色分隔页
6. 2×2 布局用的是 `<table class="t2x2">` 而不是 `<div>` + grid
7. `.co` callout 上方留白是有意的，没被塞内容
8. 没有 emoji
9. 浏览器打开 `index.html`，4 种版式都正常显示，字体加载完成（CDN 字体首次加载略慢）
10. ⌘P 预览：每页是独立 280×158 mm，背景羊皮纸色正常，页码 `.page-num` 在右下角

## 不需要做的事

- 不需要装 npm / 启服务器——单文件 HTML
- 不需要本地字体——已用 jsdelivr CDN（首次加载需要联网）
- 不需要交互翻页 JS——这是打印优先格式；如果要在浏览器演讲时翻页，用 macOS 预览/Adobe 的全屏 PDF 模式
- 不需要 Motion One / WebGL——风格 D 没有动画
