# Viewport 硬规则 · 每张 slide ≤ 100vh

> 适用全部横向 / 纵向翻页风格（A / B / C / E / F / G / H / I）。**不适用 D 纸**——D 是打印优先，每页 280×158 mm 不是 100vh。

## 第一原则

**每张 `<section class="slide">` 必须严格在一个屏内显示，禁止内部滚动。**

观众看不到下半页，就等于那部分内容不存在；让浏览器自动滚动只会让翻页节奏崩溃。

## 三条硬规则

### 1. `.slide` 容器 100vw × 100vh + `overflow: hidden`

```css
.slide {
  width: 100vw;
  height: 100vh;
  height: 100dvh; /* 移动端动态视口高度 */
  overflow: hidden; /* 不可省略 */
}
```

`100dvh` 是给移动端浏览器用的——iOS Safari 的地址栏收起 / 展开会改 `100vh`，`100dvh` 能动态适应。

### 2. 所有字号 / 间距用 `clamp()`

```css
.h-hero    { font-size: clamp(3rem, 8.5vw, 7rem); }
.body-text { font-size: clamp(0.85rem, 1.1vw, 1rem); }
--pad-x:   clamp(2rem, 6vw, 5rem);
--gap:     clamp(0.5rem, 1.5vw, 1.5rem);
```

`clamp(min, ideal, max)` 让排版随视口缩放，避免**小屏溢出 / 大屏过大**。

### 3. 内容溢出 → 拆页，不是滚动

如果一页内容塞不下，**写到下一页**，不要靠：

- ❌ 减小字号
- ❌ 缩 padding
- ❌ 加 `overflow: auto`
- ❌ 让用户滚动

正确处理：

- 长列表 4-6 条一拆
- 长引用拆成多张 pull quote
- 数据卡片超过 6 个分两页
- 图文混排压缩到只保留主图 + 一句话标题

## 各风格的"安全内容量"

经验值——一页放这么多东西，大概率在 1280×720 / 1920×1080 都装得下：

| 风格 | 标题 | 正文 | 列表项 | 卡片 |
|---|---|---|---|---|
| A 杂志 | 1 个 h-hero / h-xl | 2 段 lead | 5-6 项 | 3-4 个 stat-card |
| B 瑞士 | 1 个大字 hero | 1 段 | 7-8 项 | 4-6 个 card-fill |
| C 思维导图 | — | — | — | 节点自动布局 |
| E 编辑 | 1 个 h-section + h-sub | 1-2 段 body + 1 个 pull quote | 4-5 项 | 3 个 stat-card |
| F 暗夜植物 | 1 个 h-display | 1 段 lead + 1 段 body | 3-4 项 timeline | 3 个 spec-card |
| G Notebook | 1 个 h-section | 1 段 | 4-5 项 | 5 个 tab + 主内容 |
| H Bold Signal | 1 个 h-hero | 1 段 | 4-5 项 | 1 个橙卡 + 2-3 个 grid |
| I Terminal | 5-6 行 mono | 10-12 行代码 | 4-5 项 prompt | — |

超过这个量 → 拆页。

## 容器规则

### 卡片 / 容器 max 限制

```css
.card, .container, .content-box {
  max-width: min(90vw, 1000px);
  max-height: min(80vh, 700px);
}
```

不要让单个组件吃满整个屏——给标题 / 导航 / nav-hint 留地方。

### 图片硬约束

```css
img {
  max-width: 100%;
  max-height: min(50vh, 400px);
  object-fit: contain;
}
```

`object-fit: contain` 而非 `cover`：宁可留白，不要裁掉关键内容。

### 网格自适应

```css
.grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(min(100%, 250px), 1fr));
  gap: clamp(0.5rem, 1.5vw, 1.5rem);
}
```

`auto-fit` + `minmax` 让网格在窄屏自动堆叠成单列。

## 短视口断点

```css
/* < 700px 高（笔记本横屏外接屏）*/
@media (max-height: 700px) {
  :root {
    --slide-padding: clamp(0.75rem, 3vw, 2rem);
    --title-size: clamp(1.25rem, 4.5vw, 2.5rem);
  }
}

/* < 600px 高（演讲投影 4:3）*/
@media (max-height: 600px) {
  :root {
    --slide-padding: clamp(0.5rem, 2.5vw, 1.5rem);
    --title-size: clamp(1.1rem, 4vw, 2rem);
  }
  .nav-hint, .progress, .decorative { display: none; }
}

/* < 500px 高（手机横屏）*/
@media (max-height: 500px) {
  :root {
    --slide-padding: clamp(0.4rem, 2vw, 1rem);
    --title-size: clamp(1rem, 3.5vw, 1.5rem);
  }
}
```

## CSS 函数取负的陷阱

```css
/* ✗ 错——浏览器静默忽略 */
right: -clamp(28px, 3.5vw, 44px);

/* ✓ 对——必须用 calc */
right: calc(-1 * clamp(28px, 3.5vw, 44px));
```

CSS 不允许函数前直接加 `-`，**整条声明被丢弃也不报错**。所有取负必须 `calc(-1 * ...)`。

## Reduced Motion

```css
@media (prefers-reduced-motion: reduce) {
  *, *::before, *::after {
    animation-duration: 0.01ms !important;
    transition-duration: 0.2s !important;
  }
  html { scroll-behavior: auto; }
}
```

所有模板必须支持——macOS / iOS 用户的"减少动态效果"系统偏好要尊重。

## 自动检测

跑 `scripts/check-overflow.mjs` 模拟 3 个视口（1920×1080 / 1280×720 / 1024×640），用 Puppeteer 加载 deck，对每张 `.slide` 测量是否溢出 viewport：

```bash
node scripts/check-overflow.mjs path/to/deck.html
```

输出：

```
[1920×1080] slide 1: ✓ fits
[1920×1080] slide 2: ✗ overflow by 47px vertically
[1280×720]  slide 1: ✓ fits
...
```

任何 ✗ 都要回去拆页 / 缩内容，不要靠加 overflow: auto。

## 视觉确认 checklist

打开 deck 后翻一遍，每页问：

1. 有任何文字被截断（看到 `…` 或半个字）吗？
2. 滚动条出现过吗？
3. 大字标题贴边了吗？应该有至少 padding 一档的留白
4. 底部 `.nav-hint` / `.foot` / `.page-num` 跟内容打架了吗？
5. 在窗口缩到 1024×640 时还成立吗？（按 ⌘+ / ⌘- 测一下）
6. macOS "减少动态效果"开启时，动画退化合理吗？

任一答 yes → 改。
