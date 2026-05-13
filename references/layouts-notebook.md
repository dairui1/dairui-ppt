# 风格 G · 笔记本（Notebook Tabs）布局与内容规范

模板：`assets/template-notebook.html`。单文件 HTML，横向翻页，**深色背景上一张奶色纸卡 + 左侧装订孔 + 右侧 6 个彩色标签**。字体走 Google Fonts CDN（Bodoni Moda / DM Sans / JetBrains Mono）。

## 设计语言

- **外底色**：暗灰 `--bg-outer: #2d2d2d`
- **纸面**：奶色 `--bg-page: #f8f6f1` + 轻一档 `--bg-page-tint: #efece4`
- **墨色**：`#1a1a1a` / `#2d2926` / `#555` / `#8c887e`
- **6 色标签**（左到右用、不必按序）：
  - mint `#98d4bb`
  - lavender `#c7b8ea`
  - pink `#f4b8c5`
  - sky `#a8d8ea`
  - cream `#ffe6a7`
  - peach `#f5b87a`
- **字体**：Bodoni Moda 衬线 (400/700, opsz 6-96) + DM Sans 无衬线 (400/500/700) + JetBrains Mono
- **关键质感**：装订孔 + 彩色侧 tab + 微旋转的 sticky note + 衬线下划线高亮

## 美学锚点

- 高质量手账 / Hobonichi / Field Notes 笔记本
- 北欧文具店调性（Papier / Moleskine / Leuchtturm1917）
- *Cereal* / *Kinfolk* 杂志的内页排版
- **不是**：Notion app 截图 / 通用 SaaS dashboard

## 6 种内置版式

| 序号 | 版式 | 用途 |
|---|---|---|
| 1 | 封面（Cover tab） | 第 1 页 |
| 2 | 章节封（Ch. tab）+ 下划线高亮大字 | 每章开头 |
| 3 | 编号笔记列表（Notes tab） | 论点 + 5 条要点 |
| 4 | 数据 sticky 网格（Data tab） | 3 张微旋转便签 |
| 5 | Pin 大引述（Pin tab）| 摘录 / 金句 |
| 6 | 收束（End tab）| 最后一页 |

## 关键组件

### 装订孔（`.binder`）

左侧固定 36-60px 宽，dashed 边线 + 3 个深色圆孔（顶部 / 中间 / 底部）。**必须保留**——是笔记本质感的标志。

### 彩色标签条（`.tabs`）

右侧 36-60px 宽，6 个等高彩色 `.tab`，每个 tab 旋转 90° 写章节名（mono uppercase）。

```html
<div class="tabs">
  <div class="tab active" data-i="0"><span>Cover</span></div>
  <div class="tab" data-i="1"><span>Ch. 01</span></div>
  ...
</div>
```

- `.tab.active` 是当前页的标签
- **点 tab 直接跳到对应 slide**（JS 已实现）
- 非 active tab 自动降饱和度（`filter: brightness(0.92) saturate(0.7)`）
- 标签文字 ≤ 8 个英文字符 / 4 个中文字，否则挤出

### 衬线下划线高亮（`.ul-accent`）

```html
<span class="ul-accent" style="color: var(--tab-1);">关键短语</span>
```

模拟用记号笔在纸上划下划线的效果——`background-image` 渐变在文字下方画一道色块。用法：

- 章节封的主题词
- 收束页的强调语
- 大引述里的关键短语
- **每页最多 1 处**，多了变 cheesy

颜色用 `var(--tab-1)` ~ `var(--tab-6)` 之一，保持和当前章节 tab 颜色呼应。

### Sticky Note 卡片（`.sticky`）

```html
<div class="sticky color-3">
  <span class="sticky-label">Metric A</span>
  <span class="sticky-title">87<span style="font-size: 0.55em;">%</span></span>
  <p class="sticky-note">说明...</p>
</div>
```

- 6 个色（`.color-1` ~ `.color-5`）
- 每张自动微旋转 (-0.6° / +0.4° / -0.3°)，hover 时归位 + 上浮 3px
- 3 张并排是最舒服密度，**禁止 4 张以上**

### 手写注脚（`.handwritten`）

```html
<p class="handwritten">— 作者首字母 · 日期</p>
```

衬线 italic + 暖灰色，像手写签名 / 边注。用在：
- 封面 / 收束的作者签名
- 笔记列表底部的反思 / 来源
- 大引述下方的出处

### 编号笔记列表（`.note-list`）

```html
<ul class="note-list">
  <li><strong>要点一标题。</strong>一句话陈述...</li>
  ...
</ul>
```

自动用 `01`, `02`, ... 编号（mono 字体），首词加粗。**最多 5 条**，超过拆页。

### 装订孔提示 + 标签信息条同步

每页 `.tabs` 里 6 个 tab 的 `.active` class 要手动改到当前页对应的 i。模板里 6 张 slide 已经做好——拷贝粘贴新页时记得改 active 位置。

## 写作风格

- **手写感、亲切**——不要 marketing 复制粘贴
- **第一人称、有反思**——"我在记笔记的时候发现..."
- **保留小细节**——日期、地点、谁说的，越具体越像真实笔记
- **可以有"未完成"感**——"待研究" / "下一次再写" 是允许的
- **不要写满**——纸面留白是笔记的灵魂

## 节奏推荐

```
1 封面（Cover tab, mint）
2 章节封（Ch.01 tab, lavender）
3 编号笔记（Notes tab, pink）
4 数据 sticky（Data tab, sky）
5 大引述（Pin tab, cream）
6 收束（End tab, peach）
```

6 个 tab 对应 6 张 slide 是甜点配置。如果要扩到 8-10 页，复用 tab（如 Ch. 01 / Ch. 02 / Ch. 03 共享 mint，Notes 复用 pink）。

## 自检清单

1. `<title>` 替换、无 `[必填]`
2. 占位符 `{{...}}` 全填
3. 装订孔在每页都可见
4. 每页对应的 tab 有 `.active` class
5. tab 文字 ≤ 8 字母 / 4 汉字
6. `.ul-accent` 每页 ≤ 1 处
7. sticky note ≤ 3 张并排
8. 至少 1 处用了 `.handwritten`（封面签名 / 注脚 / 出处）
9. 浏览器测试：点彩色 tab 能跳页、↑↓ ←→ 滚轮都能翻、字体加载完
10. 视觉确认：纸卡阴影自然、装订孔位置合理、tab 颜色饱和但不刺眼

## 不要做的事

- ❌ 不要换 Bodoni Moda / DM Sans 字体
- ❌ 不要把纸卡背景改成纯白（失去暖色质感）
- ❌ 不要把 tab 缩小成花边装饰——tab 是导航 UI
- ❌ 不要在装订孔位置放内容
- ❌ 不要超过 6 个 tab（视觉饱和）
- ❌ 不要 emoji（用 `.handwritten` 衬线 italic 代替）
- ❌ 不要把 sticky note 改成方方正正——失去手帐感
