# 风格 E · 编辑（Vintage Editorial）布局与内容规范

模板：`assets/template-editorial.html`。单文件 HTML，横向翻页，CSS/JS 全内联，字体从 Google Fonts CDN 加载（Fraunces / Work Sans / JetBrains Mono）。

## 设计语言（已固定，不要改）

- **底色**：奶米黄 `--bg-cream: #f5f3ee`
- **暗模式底色**：近黑 `--bg-deep: #1a1a1a`
- **墨色**：`--ink: #1a1a1a` / `--ink-soft: #2d2926` / `--ink-mid: #555`
- **强调色**：`--accent-ink: #b04a2f`（陶土红）+ `--accent-warm: #e8d4c0`（暖肌色块）
- **分割线**：`--rule: #c8c0b0`
- **字体**：
  - 衬线展示 `Fraunces`（700/900，opsz 9-144 可调）
  - 无衬线正文 `Work Sans`（400/500/600）
  - 等宽元数据 `JetBrains Mono`（400/500）
- **节奏**：明暗交替——封面 / 章封 / 正文 = light，pull quote = dark；建议 6-8 页之间放 ≥ 1 个 dark 页

## 美学锚点

- *The New Yorker* / *Monocle* / *Cereal* / *Wired* 文字感
- *Kinfolk* 的留白与排印
- Pentagram 的杂志改版作品
- **不是**：Apple Keynote / Webflow 模板 / 通用 SaaS 落地页

## 字号层级表

| Class | 字号 / 字重 | 用途 |
|---|---|---|
| `.h-hero` | `clamp(3rem, 8.5vw, 7rem)` / 900 | 封面唯一主标题；opsz=144 |
| `.h-display` | `clamp(2.4rem, 5.8vw, 4.5rem)` / 700 | 章节封 / 收束页 |
| `.h-section` | `clamp(1.8rem, 3.6vw, 2.8rem)` / 700 | 内页标题 |
| `.h-sub` | `clamp(1.1rem, 1.9vw, 1.5rem)` italic / 500 | 衬线斜体副标题，**这是编辑风的灵魂** |
| `.lead` | `clamp(0.95rem, 1.3vw, 1.18rem)` / 400 | 引导段 / 注解 |
| `.body-text` | `clamp(0.85rem, 1.1vw, 1rem)` / 400 | 正文，行高 1.6 |
| `.pullquote` | `clamp(1.8rem, 3.4vw, 2.6rem)` italic / 500 | 大引述，左边线 3px 陶土红 |
| `.eyebrow` | mono `clamp(0.68rem, 0.95vw, 0.85rem)` 500 / letter-spacing 0.22em uppercase | 章节编号 / 标签 |
| `.stat-number` | serif 700 `clamp(2.2rem, 4.5vw, 3.6rem)` opsz=48 | 大数字，陶土红 |

## 6 种内置版式

模板自带 6 个示例 slide：

| 序号 | 版式 | 何时用 |
|---|---|---|
| 1 | 封面 · `cover` + 几何装饰 | 第一页 |
| 2 | 章节封 · 大字 + accent-warm 块 | 每章开头 |
| 3 | 正文 · drop cap + 二栏列表 | 引论 / 核心论述 |
| 4 | 数据三栏 · 大衬线数字 + stat-card | "by the numbers" 页 |
| 5 | Pull Quote · dark 全屏大引述 | 引人停顿 / 受访摘录 |
| 6 | 收束 · CTA box + 几何装饰 | 最后一页 |

直接复制 `<section class="slide">` 改文案，**不要发明新版式**——先用现有 6 种组合到 8-12 页，已经够撑大多数场合。

## 关键组件

### Drop Cap（首字下沉）

```html
<p class="body-text dropcap">这里写一段较长的引导文...</p>
```

`.dropcap::first-letter` 自动放大 4.2× 衬线字、陶土红。**只用在一段较长正文的开头**，整份 deck 出现 1-3 次最佳；用多了变 cheesy。

### Pull Quote

```html
<p class="pullquote">这里放一句金句...</p>
```

- 30-50 字最有力，**不要超过 80 字**
- 默认用在 `.slide.dark` 页面（暗背景），陶土红改成 `accent-warm` 暖色边
- 一份 deck 用 1-2 个 pull quote 就够

### Stat Card

```html
<div class="stat-card">
  <span class="stat-label">指标名</span>
  <span class="stat-number">87<span style="font-size: 0.5em;">%</span></span>
  <p class="stat-note">说明...</p>
</div>
```

- 数字用衬线 + 陶土红
- 单位 / 百分号字号是数字的 50%
- 三个并排是最舒服的密度；四个开始挤

### CTA Box

```html
<a class="cta-box" href="#">联系方式 / 行动 <span class="arrow">→</span></a>
```

- 3px 黑色边框 + 衬线大字
- 悬停时反色（黑底白字）
- **整份 deck 只放 1 个 CTA**，多了破坏编辑感

### 几何装饰

模板提供 4 个装饰原件，绝对定位用：

| Class | 形状 |
|---|---|
| `.deco-circle` | 圆形描边（2px） |
| `.deco-dot` | 实心圆点，陶土红 |
| `.deco-rule` | 水平细线（2px） |
| `.deco-block` | 暖肌色块 |

**用法**：
- 一页最多 2-3 个装饰元素
- 不要用饱和度高的颜色（陶土红已经够锋利）
- 不要画箭头 / 心形 / 复杂图形——只用圆 / 点 / 线 / 矩形
- 位置用 `top/right/bottom/left` 百分比锚定，避开正文区

## 写作风格（重要！）

编辑风的核心不是视觉，是**文案语气**：

| 不要写 | 改成 |
|---|---|
| "我们提供 AI 驱动的解决方案" | "我们做的是一件简单的事：让 X 不再难" |
| "革新行业的颠覆性产品" | "我们试图回答一个具体的问题：为什么 X 还是这么慢？" |
| "联系我们了解更多" | "如果你也在想这件事，写信给我们" |
| "提升 30% 效率" | "把 8 小时压缩到 5.5 小时——我们记录了 47 次" |

要点：
- **有第一人称**——"我们 / 我"，不要永远第三人称
- **有具体细节**——"47 次"比"多次"有力
- **有观点**——不光陈述事实，要敢下判断
- **不写营销 hype 词**：颠覆 / 革新 / 行业领先 / 创新 / 赋能 / 一站式 全部禁用
- **保留一点克制的幽默**——这是 *Monocle* 跟 SaaS deck 最大的区别

## 节奏推荐

```
1 封面（light）
2 章节封 01（light）
3 正文 · 论点（light）
4 数据三栏（light）
5 pull quote（dark）  ← 明暗呼吸
6 章节封 02（light）
7 正文 · 案例（light）
8 收束（light）
```

8 页是一个甜点。

## 自检清单

写完一份 paper deck 后逐项过：

1. `<title>` 已替换，没有 `[必填]`
2. 所有 `{{...}}` 占位符都填了
3. drop cap 用了 1-3 次，不是每页都用
4. pull quote 出现 1-2 次，在 dark 页
5. CTA box 只出现 1 次
6. 衬线斜体副标 `.h-sub` 在每个章节里都出现至少一次
7. 文案没有"颠覆 / 革新 / 赋能"这类 marketing 词
8. 至少有一处具体细节（数字 / 时间 / 地点 / 人名）
9. 浏览器打开 `index.html`，6 种版式都能正常翻页、字体加载完成
10. dark 页和 light 页交替合理，整体看 8-12 页不疲劳

## 不要做的事

- ❌ 不要换字体——Fraunces + Work Sans 是这风格的灵魂
- ❌ 不要把陶土红换成"AI 默认紫"或"科技蓝"
- ❌ 不要加圆角 > 0
- ❌ 不要写实插画、3D 图标、卡通 IP
- ❌ 不要把 Stat Card 撑到 4 个以上
- ❌ 不要用 emoji 替代装饰
- ❌ 不要破坏明暗节奏——全 light 没呼吸，全 dark 太重
