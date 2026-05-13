# Style Discovery · "Show, don't tell"

> 当用户说不清要什么风格时，**别拿抽象选项让他选——直接做出 3 个具体的预览让他指**。

## 何时启动 Discovery 流程

满足以下任一条件：

- 用户说"随便 / 都行 / 你来决定"
- 用户描述的关键词在 A/B/C/D/E/F 都对得上一点（典型例子："想要看起来专业但又有点设计感"）
- 用户给的素材里有图但没说风格倾向
- 用户明确说"不知道 / 不会选 / 看一下再决定"

**反过来**：如果用户明确说了"瑞士风" / "杂志风" / "mindmap" / "白皮书" / 等关键词，直接进 Step 2，**不要启动 discovery**——他已经选了。

## 流程（4 步）

### Step D1 · 抓"感觉"，不要抓"风格"

问 1 个**感觉**问题（最多 2 项 multiSelect），把"风格选择"翻译成"听众应该有的感受"：

> 这份 deck 你希望听众有什么感觉？（最多选 2 项）
> - 印象深刻 · 沉稳、有重量
> - 兴奋激动 · 锐利、有冲击
> - 安静专注 · 留白、有思考空间
> - 被打动 · 优雅、有情绪

环境适配：
- **Claude Code**：用 `AskUserQuestion` 工具，`multiSelect: true`
- **Codex / 命令行**：用普通对话问，让用户回答两个词

### Step D2 · 把感觉映射到 2-3 个候选风格

| 感觉 | 候选风格（按推荐度排） |
|---|---|
| 印象深刻 | A 杂志 / B 瑞士 / D 纸 |
| 兴奋激动 | A 杂志 / E 编辑 |
| 安静专注 | B 瑞士 / D 纸 / F 暗夜植物 |
| 被打动 | F 暗夜植物 / E 编辑 / A 杂志 |

**用户选了两个感觉**：取两表交集，最多取 3 个；没交集就并集去重。

**用户没素材内容**：基于感觉直接推。
**用户有素材**：还要考虑素材形态——
- 大量数据 / 图表 → 优先 B
- 大量人文照片 → 优先 A
- 长文转 PPT → 优先 C
- 要打印 / PDF 分享 → 优先 D
- 杂志感文章 → 优先 E
- 高端品牌 / 调性 → 优先 F

### Step D3 · 生成 3 个 mini preview

为每个候选风格生成**一张代表性 slide**，保存到工作目录 `.dairui-design/previews/`：

```
.dairui-design/
  previews/
    style-A-magazine.html   ← 候选 1 的封面/章节封
    style-B-swiss.html      ← 候选 2 的封面
    style-F-botanical.html  ← 候选 3 的封面
```

每个 preview 是 **单独一份完整 HTML**，单 slide，约 50-100 行。可以直接从对应的 `template-{style}.html` 抽出第一张 `<section class="slide">`，把 `{{占位符}}` 替换成用户的真实主题，删掉翻页 JS，保留入场动效。

**填充内容用什么**：
- 如果用户给了 deck 标题/副标题 → 用它
- 如果用户只说了主题 → 用主题做标题，副标用"A Field Note on {{主题}}" / "{{主题}} · 2026" 这类编辑风默认
- 不要写"Lorem Ipsum"——必须是用户真实主题的样子，否则 preview 失去意义

生成后**自动打开**：

```bash
open .dairui-design/previews/style-A-magazine.html
open .dairui-design/previews/style-B-swiss.html
open .dairui-design/previews/style-F-botanical.html
```

（Claude Code 里用 Bash 工具；Codex 里可以让用户自己 open，或者依赖环境的 `open` 命令。）

### Step D4 · 让用户指一个

用 `AskUserQuestion`（Claude Code）或普通对话（Codex）：

> 哪个预览最接近你想要的？
> - A 杂志风 — 衬线大字 + 杂志感
> - B 瑞士风 — Helvetica + 网格 + 高反差
> - F 暗夜植物 — 优雅斜体 + 暖色软渐变
> - 都不喜欢 — 重新生成 / 我自己选

如果用户选了具体一个 → 进 Step 2 拷贝对应模板。

如果选"都不喜欢"：
- 先问哪里不对："是颜色 / 字体 / 整体气质？"
- 根据反馈调整候选（颜色不对 → 换风格而不是改色；字体太松 → 换更紧的风格）
- 重新生成 3 个 → 重复 Step D3/D4

**最多迭代 2 轮**——再不行就直接展示所有 6 种风格的封面截图或描述，让用户挑。

### Step D5 · 清理

确认风格后：
- 删除 `.dairui-design/previews/` 整个目录
- 进 SKILL.md Step 2 正常流程

## Preview 模板生成原则

每个 preview 应该展示：

1. **该风格的标志性视觉**——衬线大字（A/E）/ 数字 KPI（B）/ 树根节点（C）/ 羊皮纸封面（D）/ 装饰几何（E）/ atmos 球（F）
2. **真实主题文案**——用用户给的关键词，不要占位符
3. **入场动效**——至少能看到 stagger reveal 一次
4. **完整字体加载**——CDN 字体必须加载完成才让用户看

**避免**：

- ❌ 不要展示空模板（只有 `{{...}}`）—— 用户看不出区别
- ❌ 不要拷贝完整模板（6 个 slide）—— 用户被信息淹没
- ❌ 不要混用风格的元素 —— 一个 preview 一个纯净风格
- ❌ 不要在 preview 里加 "Style A / B / C" 字样 —— 让视觉本身做沟通

## 跳过 Discovery 的捷径

熟练用户可能直接说："直接给我看 6 个风格预览，我自己挑"。这时跳过感觉问答，直接生成 6 个 mini preview（A/B/C/D/E/F 各一张），并行打开。

每个 preview 50-100 行，6 个总共 600 行 HTML，几秒内生成完。

## 失败兜底

如果：
- 环境不支持 `open` 命令 → 列出文件路径让用户手动打开
- 用户在终端里看不到浏览器 → 把每个 preview 的核心特征用文字描述 + 列出对应 SKILL.md 的位置让用户读
- 字体 CDN 加载失败 → 文档里强调"预览需要联网；离线场景请直接根据 README 风格表选"
