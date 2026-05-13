# 风格 C · 思维导图（Mindmap）布局与内容规范

风格 C 不像 A/B 用版式骨架填内容，它只有一个东西需要写：`sourceMarkdown` 模板字符串。一切结构由这棵 Markdown 树决定，运行时按**前序遍历**逐个展开。

模板：`assets/template-mindmap.html`（单文件 HTML，CSS/JS 已内联）。

## 编辑点（只改这一处）

打开拷贝出来的 `index.html`，搜 `sourceMarkdown`，替换模板字符串里的内容。**不要碰** `<style>`、`<script>` 内的其它代码，也不要把 `</script>` 写进 markdown。

```html
<script type="module">
  const sourceMarkdown = `
- 主题
  一句话主张
  @image cover.png
    - 第一章
      讲清楚为什么要做
        - 背景
          一句话点题
        - 痛点
          列两到三条
    - 第二章
      方案与做法
      @image solution.svg
  `;
  // 下面是渲染逻辑，不要动
  ...
</script>
```

## Markdown 语法（这是唯一的内容输入格式）

| 形式 | 含义 |
|---|---|
| `- text` | 创建一个节点，缩进决定父子关系 |
| 在节点下方加一行缩进文本 | 作为该节点的第二行（主标题） |
| `  @image path` | 给当前节点附一张图（紧跟在标题行后，子节点之前） |

### 节点两行体例

```md
- 副标题
  主标题
```

- 第一行 = 副标题（小字、上方），第二行 = 主标题（大字、下方）
- 单行节点直接当主标题渲染
- 每行尽量 ≤ 30 个中文字符或 ≤ 8 个英文词
- 控件面板里多行 label 会被合并为 `副标题 / 主标题` 行内预览

### 图片路径解析

- 短路径 `cover.png` → `./images/cover.png`
- 嵌套 `diagrams/flow.svg` → `./images/diagrams/flow.svg`
- 显式开头（`./`、`../`、`/`、`http(s):`、`data:`）原样使用
- 同一节点出现多个 `@image`，**最后一个生效**

> 风格 C 用 `./images/` 解析图片（和 A/B 一致）。把图片放到拷贝 `index.html` 同级的 `images/` 文件夹下。

### 缩进规范

- 用空格缩进，不要混用 Tab
- 每层缩进至少 2 个空格，建议 4 个，保持视觉一致
- continuation 行（主标题、@image）必须比 `- ` 自身缩进更深

## 树结构原则

> 决定播放顺序、决定每页内容形状的是树本身。这里的规则比"节点两行体例"更重要。

- **不要强制 root → L1 → L2 → L3 四层**。让层级表达作者的逻辑结构。
- **沿用原文顺序**：preorder 是父先于子，不要把后文结论提前到父节点 label。
- **不要重复 root 主题**：根节点已经点题了，子节点要推进故事。
- **同主题就近聚拢**：背景 / 标准 / 风险 / 工具盘点 / 建议 / 结论各成一支。
- **父节点做判断，子节点放证据/原因/例子**。如果 B 是在解释 A，就把 B 写成 A 的子节点，不是兄弟。
- **每个父节点 ≤ 5 个子节点**，超过就加分组节点。
- **不要逐句切**：一个节点承载一个完整小论点（大致对应原文 10-80 字）。
- **不要让父节点剧透**：父节点是导览，子节点才揭细节。
- **图片放在高信息量节点上**：框架 / 对比 / 清单 / 推荐 / 风险模型。小细节节点不配图。

## 图片选用

- 节点图片是**可选**，整个 deck 一般 3-8 张图，短 demo 0-2 张
- 优先做信息图、流程图、对比图、架构图、时间线、概念模型——而不是装饰照
- 用 PNG（生成插图） / SVG（占位几何） / JPG（写实照片）
- 图比例尽量 16:10 / 4:3，避免极端长宽比
- 图里不要写文字标签，标签留给节点 label
- 全部放 `images/` 文件夹下，文件名 kebab-case：`overview.png` / `agent-workflow.png`

### GPT-Image 配图提示词（沿用 mindmap-ppt 原版）

```text
Create a clean presentation illustration for a light PPT mind-map node.
Subject: <node main idea>.
Include: <2-4 concrete visual elements from the source text>.
Style: restrained vector-like editorial illustration, warm off-white background,
       dark teal #183a4a, muted green #eef7f3, orange accent #d8894f,
       simple geometric shapes, thin shadows, small 8px-radius card-like forms,
       no photorealism, no text, no logos, no busy decorations.
Composition: centered, generous whitespace, readable at thumbnail size, aspect ratio 16:10.
```

### SVG 占位（没有图像生成能力时）

- 画布 1280×800
- 配色：暖白底 `#fffdf8` + 深青 `#183a4a` + 暖绿 `#eef7f3` + 橙 `#d8894f`
- 内容：抽象的流程块、箭头、卡片、时间线
- 不写文字、不画 logo、不要写实

## 视觉风格（已内置，不需要改）

模板已固定的视觉语言：

- 暖白渐变背景 + 四角缓慢漂移的彩色 blob
- 选中节点：深青 `#183a4a` + 白字 + 橙描边 `#d8894f`
- 路径节点：近白填充 `#fffdf8` + 深青描边
- 已访问的非路径节点（已完成分支）：浅绿 `#eef7f3` + 绿描边
- 节点圆角 8px，链接是 SVG 立方贝塞尔曲线
- 字体：Inter / 苹方 / Microsoft YaHei

不要改 `<style>` 块。如果用户坚持要换色，告诉他改 `:root` 里的 `--node-image-*` 变量或者那几个深青/橙值，但不要混入大量装饰。

## 播放交互（已内置）

- 上/下方向键、Page Up/Down、滚轮、移动端上下划：前后切换节点
- 顶部进度滑条：直接跳到任意节点
- Zoom 滑条：70%-140% 整体缩放
- 选中节点放大倍率：1.00x-2.00x（默认 1.50x）
- 点击非选中节点：仅移动相机视角，不改变播放进度
- 节点上的图片：点击放大全屏，ESC 或点击背景关闭

## 自检清单（风格 C）

写完 / 改完 `sourceMarkdown` 后逐项过：

1. `<title>` 已替换，不再含 `[必填]`
2. `sourceMarkdown` 模板字符串里没有未转义的反引号或 `${...}`（会破坏 JS）
3. 每个 `@image` 文件都真实存在于 `images/` 下
4. 根节点只有一个（最外层只有一行 `- xxx`）
5. 子节点缩进比父节点多至少 2 个空格
6. 每个父节点子节点数 ≤ 5
7. 节点标签平均长度合理（10-80 字 / 8 英文词为佳），没有"逐句切"的碎块
8. 图片节点是高信息量节点，不是细枝末节
9. 用浏览器直接打开 `index.html`，按方向键能从根节点一路播到结尾
10. 中文输入产出中文，英文输入产出英文，不要混翻

## 不需要做的事

- 不需要 `npm install` / `npm run dev` / 本地服务器——这是单文件 HTML
- 不需要拷贝 `src/main.js` / `styles.css`——已经内联进模板
- 不需要建 `project/` 目录——图片用 `images/`
- 不需要校验脚本——`validate-swiss-deck.mjs` 只服务风格 B
