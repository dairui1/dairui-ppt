# 风格 F · 暗夜植物（Dark Botanical）布局与内容规范

模板：`assets/template-botanical.html`。单文件 HTML，横向翻页，深色底色 + 漂浮软渐变 + 衬线斜体大字。字体走 Google Fonts CDN（Cormorant / IBM Plex Sans / IBM Plex Mono）。

## 设计语言（已固定，不要改）

- **底色**：近黑 `--bg-primary: #0f0f0f`，配两档浅 `#161514` / `#1c1a18`
- **正文色**：`--text-primary: #e8e4df`（暖白）/ `--text-secondary: #9a9590` / `--text-muted: #6e6862`
- **强调色**（**3 色暖系**）：
  - `--accent-warm: #d4a574`（陶金）
  - `--accent-pink: #e8b4b8`（暖粉）
  - `--accent-gold: #c9b896`（古铜）
- **氛围装饰**：3 个软渐变球（atmos-1/2/3），blur(80px) + opacity 0.5，慢速漂移
- **字体**：
  - 衬线展示 `Cormorant`（400/500/600 + italic 400/500，**优雅是核心**）
  - 无衬线正文 `IBM Plex Sans`（300/400/500，**轻字重是核心**）
  - 等宽 `IBM Plex Mono`（300/400，做章节编号 / 元数据）
- **分割**：1px hairline `rgba(232, 228, 223, 0.12)` 或 `0.28`，没有实色块

## 美学锚点

- 高端酒店 lookbook（Aman / Aesop）
- *Cereal* / *Anothermag* 的暗夜版面
- 香水广告 / 艺术画廊宣传册
- *The Gentlewoman* 杂志
- **不是**：科技产品 demo / SaaS 落地页 / 暗色 IDE 主题

## 字号层级表

| Class | 字号 / 字重 | 用途 |
|---|---|---|
| `.h-hero` | serif italic 400 `clamp(3.5rem, 10vw, 8.5rem)` | 封面唯一主标题；italic 是灵魂 |
| `.h-display` | serif 500 `clamp(2.6rem, 6.5vw, 5rem)`；`em` 子元素 italic 400 + 陶金色 | 章节封 / 收束页 |
| `.h-section` | serif 500 `clamp(2rem, 4.2vw, 3.2rem)` | 内页标题 |
| `.h-sub` | serif italic 400 `clamp(1.2rem, 2.1vw, 1.7rem)` 陶金色 | 副标题，**italic + accent** |
| `.lead` | sans 300 `clamp(1rem, 1.35vw, 1.22rem)` | 引导段 |
| `.body-text` | sans 300 `clamp(0.88rem, 1.15vw, 1.05rem)` 行高 1.7 | 正文；`strong` 是 500 暖白 |
| `.signature` | serif italic 400 暖粉色 | 作者签名 |
| `.spec-value` | serif 500 `clamp(1.4rem, 2.8vw, 2.2rem)` | 大数字 / spec 值 |
| `.eyebrow` | mono 400 0.28em letter-spacing 陶金色 | 章节编号 / 标签 |

## 6 种内置版式

| 序号 | 版式 | 何时用 |
|---|---|---|
| 1 | 封面 · 居中大字 italic + signature | 第一页 |
| 2 | 章节封 · 左对齐 + 纵向 accent-line | 每章开头 |
| 3 | 正文 · 两栏（概念 + 阐释） | 引论 / 论述对照 |
| 4 | Spec 三栏 · 顶部 hairline + 衬线大字 | 数据 / 规格 / 特性 |
| 5 | Timeline · 极简竖列 + 年份 mono | 演进 / 历程 |
| 6 | 收束 · 居中 italic + CTA 下划线 | 最后一页 |

## 关键组件

### 氛围软渐变（必须保留）

每页 1-3 个 `.atmos` 球，位置和数量可调，**但不要删光**——它们是这风格的灵魂。

```html
<div class="atmos atmos-1"></div>  <!-- 左上陶金 -->
<div class="atmos atmos-2"></div>  <!-- 右下暖粉，慢速漂移 -->
<div class="atmos atmos-3"></div>  <!-- 中心古铜，反向漂移 -->
```

3 个球同时出现适合封面 / 收束页；正文页用 1-2 个就够。

### 纵向 accent-line（章节封专用）

```html
<div class="accent-line"></div>
```

一条 1px 陶金竖线，两端各一个 7px 圆点。**只在章节封页用**，正文不要。

### Italic Emphasis

衬线斜体是这风格的标志，用在三处：
1. `.h-hero` 整段斜体（封面）
2. `.h-display em` 子元素（章节封 / 收束 → 第二行 italic + 陶金）
3. `.h-sub` 整段斜体 + 陶金色（副标题）

正文段落里的 `<em>` 自动是 italic + secondary 色，可以放引用。

### Spec Card

```html
<div class="spec-card">
  <span class="spec-name">维度名</span>
  <span class="spec-value">87<span style="font-size: 0.55em;">%</span></span>
  <p class="spec-note">说明...</p>
</div>
```

特点：
- 顶部 1px hairline（不是边框包围）
- 数字用衬线 500，**不用 700/900**（违反暗夜植物的克制）
- 单位用 55% 字号 + muted 色

### Timeline Row

```html
<div class="timeline-row">
  <span class="timeline-year">2024</span>
  <p class="timeline-text">主判断 / 事件<em> · 补充说明</em></p>
</div>
```

- 左侧 mono 年份 + 右侧衬线主文 + `<em>` italic 补充
- 行间 1px hairline 分隔，没有圆点 / 箭头 / 图标

### CTA Link（不是按钮）

```html
<a class="cta-link" href="#">回信 · 联系方式 <span class="arrow">→</span></a>
```

- 斜体衬线 + 陶金色 + 1px 下划线（hover 转暖粉）
- **不是 boxed CTA**——boxed CTA 是编辑风（E），植物风用 link
- 整份 deck 只放 1 个

## 写作风格

| 不要写 | 改成 |
|---|---|
| 直白陈述 "我们是 X" | "我们一直在想一件事——X" |
| Marketing 词（颠覆 / 革新 / AI 驱动） | 具体动作 / 感官细节 |
| 全段都用同一字体 | 长段配 `<strong>`（暖白 500）打破节奏 |
| 短促命令句 "立即行动" | 邀请性收束 "如果你也在想这件事" |

要点：
- **优雅 > 高效**——这风格不卖效率，卖品味
- **感性细节**——可以写"上午十点的光线"、"指间停留 0.3 秒"这种
- **保留一点神秘感**——不要全部说透，留白
- **大量斜体强调**——意识流式的强调而非 marketing 高亮
- **第一人称单数（"我"）也 OK**——这风格容得下

## 节奏推荐

```
1 封面（深色 + 大字 italic + signature）
2 章节封 01（accent-line）
3 正文 · 两栏论述
4 spec 三栏
5 timeline
6 收束（CTA link + signature）
```

6-8 页是甜点。**不要超过 12 页**——这风格密度低，长了就稀薄。

## 自检清单

1. `<title>` 已替换
2. 占位符 `{{...}}` 全填
3. 每页至少 1 个 `.atmos` 球
4. 至少 3 处用到了 italic（hero / display em / sub / em）
5. 整份 deck 没用过 `font-weight: 700+`（违反克制原则）
6. CTA 是 link 形式，不是 box
7. 没有圆角 > 0、没有 box-shadow
8. 没有 emoji
9. 文案没有 marketing 高亮词
10. 浏览器 fade-in 看着舒服，软渐变 atmos 在漂移

## 不要做的事

- ❌ 不要换字体——Cormorant + IBM Plex 是灵魂
- ❌ 不要加饱和度高的颜色（绝对不要紫 / 蓝 / 绿）
- ❌ 不要把 atmos 球替换成实色块——失去氛围
- ❌ 不要用 `<strong>` 替代 italic 来强调——这风格的强调通道是 italic
- ❌ 不要 `font-weight >= 600` 的大字
- ❌ 不要圆角、阴影、渐变边框
- ❌ 不要 emoji、图标库（除非真的需要 1-2 个 Lucide 极细线条）
- ❌ 不要 grid pattern 背景——和 atmos 软渐变冲突
- ❌ 不要超过 12 页——稀释氛围
