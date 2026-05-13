# 风格 I · Terminal Green 布局与内容规范

模板：`assets/template-terminal.html`。单文件 HTML，横向翻页，**GitHub 暗底 + 终端绿 + 全程等宽字体 + 扫描线**。开发者向 / 极客 demo 专用。

## 设计语言

- **底色**：GitHub 暗 `--bg-deep: #0d1117` + 面板 `#161b22` + 行高亮 `#1f262e`
- **主文字**：`#c9d1d9` 暖白 + 次级 `#8b949e` + 弱 `#565f6a`
- **terminal green**：`--green: #39d353` · 主 accent
- **语法高亮色**（沿用 GitHub dark theme）：
  - blue `#58a6ff` (link/type)
  - purple `#d2a8ff` (keyword)
  - orange `#ffa657` (function/number)
  - rose `#ff7b72` (error/rem)
  - green `#39d353` (string/add)
  - amber `#d2a106` (warning)
- **字体**：**只有 JetBrains Mono**（300/400/500/700 + italic 400/500）。**不许混任何衬线 / 无衬线**
- **质感**：CRT 扫描线 + 微弱 phosphor 暗角 + 闪烁光标 + ASCII art divider

## 美学锚点

- 90 年代 BBS / Linux TTY
- VS Code / Neovim 全屏代码 demo
- TLDraw / Ink & Switch 极客 talk
- 黑客松 demo day
- **不是**：fintech app / 通用 SaaS / 学术 poster / marketing 落地页

## 6 种内置版式

| 序号 | 版式 | 用途 |
|---|---|---|
| 1 | 封面 · `$ pwd` + cursor 闪烁 | 第 1 页 |
| 2 | 章节封 · ASCII border + `cd ./ch01` | 每章开头 |
| 3 | Key points · `grep` 命令 + bullet 列表 | 论点列表 |
| 4 | 代码 + diff | 案例 / 技术展示 |
| 5 | KPI 三栏 panel + `stats` 命令 | 数据 |
| 6 | 收束 · `cat CONTACT.md` + `exit` cursor | 最后一页 |

## 关键组件

### Title bar（窗口顶条）

```html
<div class="titlebar">
  <div class="dots"><span></span><span></span><span></span></div>
  <span class="path">~/talks/topic/path</span>
  <span class="pos">3/6</span>
</div>
```

- 左 3 个红黄绿点（macOS 窗口风格）
- 中间显示"当前文件路径"
- 右边显示 line:col 或页码
- **每页必加**——是 terminal 质感的锚点

### Prompt 行

```html
<div class="prompt">
  <span class="cmd"><span class="flag">grep</span> <span class="arg">-E</span> <span class="arg">'pattern'</span></span>
</div>
```

`$` 自动加在前面（绿色）。`.flag` 橙、`.arg` 蓝、其余暖白。**每页 1-2 个 prompt** 作为节奏分隔。

### Output 块

```html
<div class="output">
  <strong>highlighted note</strong>: regular text. <em>warning</em>: amber italic.
</div>
```

绿色左边线 + 缩进 + 次级灰色。配合 prompt 用："命令 → 输出"的对偶。

### Cursor（闪烁光标）

```html
<span class="cursor"></span>
```

`▊` 字符 + 1.05s 节奏闪烁。用在：
- 封面 prompt 末尾
- 收束 `exit` 命令后
- 每张 slide **最多 1 个**——多了变烦人

### Code Block（语法高亮）

```html
<pre class="code-block">
<span class="kw">function</span> <span class="fn">name</span>(<span class="ty">Type</span>) {
  <span class="cm">// comment</span>
  <span class="kw">return</span> <span class="str">'value'</span>;
}
</pre>
```

class 速查：
- `.kw` purple · keyword
- `.fn` orange · function name
- `.ty` blue · type
- `.str` green · string
- `.num` orange · number
- `.cm` dim italic · comment
- `.err` rose · error

### Diff 块

```html
<pre class="diff">
<span class="rem">- old line</span>
<span class="add">+ new line</span>
<span class="ctx">  context</span>
</pre>
```

红删 / 绿增 / 灰上下文——standard `git diff` 风。

### ASCII Divider

```html
<pre class="ascii-div">
╔════════════════════════════╗
║   SECTION 01               ║
╚════════════════════════════╝
</pre>
```

用 box-drawing 字符画的章节封 / contact block。注意：

- 宽度建议 50-60 字符，太宽手机端会换行
- 颜色用 `--fg-mute` 暗灰，**不要绿**
- 内部文字可以放 section number / 联系方式

### KPI Panel（数据三栏）

```html
<div class="kpi-grid">
  <div class="kpi-panel">
    <span class="label">throughput</span>
    <span class="num">2.4×</span>
    <p class="desc">对比基线说明</p>
  </div>
  ...
</div>
```

- label 极小 mono uppercase
- num 绿色大字
- desc 次级灰

## 写作风格

| ✓ 这样写 | ✗ 不要这样 |
|---|---|
| `8 weeks. 3 engineers. 1 rewrite.` | "经过 8 周的不懈努力，我们的团队..." |
| `latency: -87% (12s → 1.6s)` | "我们大幅提升了响应速度" |
| `// before: blocked the event loop` | "原方案存在性能瓶颈" |
| 短句、命令式、有 stack trace 感 | 复合长句、形容词 |

要点：
- **像在写 README / 写 commit message**——简洁、直接、有信息量
- **数据 + 上下文**——只给"快 87%"不够，要给"从 12s 到 1.6s"
- **代码本身做主角**——示例代码可以略长，但要能 stand-alone
- **不要营销词**——颠覆 / 革新 / 创新 / 赋能 全部禁

## 节奏推荐

```
1 封面（$ pwd · cursor）
2 章节封（ASCII border + cd）
3 列表（grep + bullet）
4 代码 + diff
5 KPI 三栏
6 收束（cat CONTACT + exit）
```

6 页是 demo talk 的甜点。**适合 15-20 分钟技术分享**——超过这个量观众会累。

## 自检清单

1. `<title>` 替换、无 `[必填]`
2. 占位符 `{{...}}` 全填
3. 每页都有 `.titlebar`
4. cursor 闪烁元素整份 deck ≤ 2 处
5. ASCII art 在 chrome / 终端等宽渲染下对齐（用 box-drawing 字符 `─│┌┐└┘╔╗╚╝═║` ）
6. 代码示例语法高亮 class 用对了（不是把全部染绿）
7. 所有字体都是 JetBrains Mono——没混入其他字体
8. `prefers-reduced-motion` 测试：scanlines 消失、cursor 停止闪
9. 浏览器拉到 1024×640 还能看清代码块
10. 文案是 dev voice（短句 + 数字 + 上下文）不是 marketing voice

## 不要做的事

- ❌ 不要混入衬线或其他无衬线字体——**只有 JetBrains Mono**
- ❌ 不要把 terminal-green 换成"AI 默认紫"或别的霓虹色
- ❌ 不要把背景变浅（白底）——CRT 质感全失
- ❌ 不要圆角 > 0（除红黄绿点）——直角是 terminal 灵魂
- ❌ 不要超过 2 个闪烁 cursor
- ❌ 不要 emoji 替代 ASCII art
- ❌ 不要把 ASCII art 染成绿色——`--fg-mute` 暗灰
- ❌ 不要 marketing 长句
- ❌ 不要在代码块里全染同一色——`.kw` / `.fn` / `.str` / `.cm` 必须用对应
- ❌ 不要超过 12 页——开发者注意力比一般观众更短
