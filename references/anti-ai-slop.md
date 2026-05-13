# 反 AI Slop · 通用守则

> 适用于全部风格（A/B/C/D/E/F）。在写第一行 HTML 之前先过一遍。

LLM 在生成前端时会**收敛到分布中心**——也就是用户口中的"AI slop 美学"：紫色渐变、Inter 字体、永远居中的 hero、千篇一律的卡片网格。本文件列出明确的"不要做"，把生成结果推离平均值。

## 第一原则

1. **克制优于炫技**——少而准、不要堆装饰
2. **结构优于颜色**——字号 / 字重 / 网格 / 留白搞定 80%；颜色只是表面
3. **每份 deck 一个明确的视觉决定**——选一个主字、一个主色调、一种动效语言，贯穿全程
4. **不要默认居中**——非对称、左对齐、网格感比"居中堆 hero"更有性格
5. **图片是第一公民**——内容承载图片，不是图片装饰内容

## 字体黑名单

下面这些字体在 PPT/演讲 deck 里出现 = AI slop 的最强信号：

| 不要用 | 原因 | 改用 |
|---|---|---|
| `Inter` | 过度使用，已成"AI 默认" | 各风格 SKILL 里指定的字体（A 衬线 / B Helvetica / C 苹方 / D TsangerJinKai02 / E Fraunces / F Cormorant） |
| `Roboto` | 同上，Google 默认 | 同上 |
| `Arial` / `Helvetica`（除风格 B 外）/ `system-ui` | 没有美学判断 | 同上 |
| `SF Pro` 作为 display | 苹果 marketing slop | 衬线或更有性格的无衬线 |
| `Space Grotesk` 作为正文 | 被滥用为"看起来 designer" | 仅在需要技术感时用作小标 |

风格特定字体（**必须用**）：

- 风格 A · 杂志：`Noto Serif SC` / `Playfair Display`（衬线标题）+ 系统无衬线（正文）+ `JetBrains Mono`（元数据）
- 风格 B · 瑞士：`Inter` / `Helvetica` / `Noto Sans SC`（这里 Inter 是合理的，因为 Swiss 国际主义风的灵魂就是 Helvetica 谱系）
- 风格 C · 思维导图：`Inter` + 系统中文（模板内置，不要换）
- 风格 D · 纸：`TsangerJinKai02` + `Charter` + `JetBrains Mono`
- 风格 E · 编辑：`Fraunces`（700/900）+ `Work Sans`（400/500）
- 风格 F · 暗夜植物：`Cormorant`（400/600）+ `IBM Plex Sans`（300/400）

## 配色黑名单

| 不要用 | 原因 |
|---|---|
| `#6366f1`（generic indigo） | Tailwind default purple-blue，AI 永远第一选项 |
| 紫色 → 粉色渐变 on 白底 | "AI app 营销页"默认 |
| 任何 `linear-gradient(135deg, #...)` 当主背景 | 已被滥用成视觉信号 |
| 玻璃拟态（backdrop-filter blur + 半透明白） | 装饰性 ≠ 内容支持 |
| 多个高饱和强调色同时出现 | 失去焦点；瑞士风规则的反面教材 |

每份 deck 严格遵守"一个主色调 + 一个 accent + 中性色三档（深 / 中 / 浅）"的色彩预算。

## 布局黑名单

| 不要做 | 替代 |
|---|---|
| 所有内容居中堆叠 | 左对齐 + 大留白 + 偶尔右对齐做对照 |
| 通用 hero section（大标题 + 副标 + CTA 按钮） | 用风格特有的 hero（A 的 frame / B 的 cover-split / C 的 root 节点 / D 的封面三段） |
| 均匀的 3 列 / 4 列卡片网格 | 不对等网格（如 2-7-5、2-9-3、grid-12 +span-N） |
| 圆角卡片 + drop-shadow（除非该风格明确允许） | 直角 + hairline 边线 |
| Material Design / iOS 风格组件 | 各风格自定义组件 |

## 装饰黑名单

- ❌ 写实插画 / 3D 渲染 / 卡通 IP（除非用户明确提供素材）
- ❌ 玻璃拟态卡片
- ❌ 无目的的 drop-shadow（任何 `box-shadow` 必须有 functional 理由）
- ❌ 霓虹光辉（除风格 F 外）
- ❌ 大量 emoji（演讲 deck 用 Lucide / Heroicons / 排印替代；emoji 在大屏上像 PowerPoint 模板）
- ❌ "blob"形状的彩色斑点（除风格 C 已内置外）
- ❌ Gratuitous gradient borders / animated rainbow text / sparkle effects

## 收敛检测（生成完后自检）

每生成一份 deck，在 Read 自己输出的 HTML 后回答：

1. **同一台机器跑 10 次，会有 8 次长得相似吗？** 如果是，主动换字体 / 改主色 / 换布局密度
2. **如果把所有色变量改成黑白灰，整份 deck 还能撑住吗？** 如果不行，说明视觉过度依赖颜色而非结构
3. **3 个最显眼的元素能不能用一句话描述？** 如果"大紫色标题、紫色渐变背景、紫色 CTA"三个都是同一颜色，立刻打散
4. **有没有任何元素是"看起来 designer 但没有信息功能"？** 删
5. **能想象这份 deck 来自某个具体的设计师 / 杂志 / 工作室吗？**（参考各风格的"美学锚点"）如果想象不出，再调一轮

## 反模式速查（一行版）

```
不要 Inter 做标题
不要紫色渐变白底
不要居中堆 hero
不要 4 列卡片网格
不要玻璃拟态
不要 emoji 当装饰
不要 drop-shadow 撑场面
不要混用多个 accent 色
不要 markdown 复制粘贴感（行高一致、字号一致 = 没有层级）
不要把 LLM 的默认配色直接交付
```

## 当 Agent 不确定该做什么

回头读对应风格的 `references/layouts-*.md` 末尾的"美学锚点"段落。把每个具体设计选择都校准到那个锚点上：

- 风格 A → *Monocle* 杂志会怎么排这页？
- 风格 B → Massimo Vignelli 看到这张会皱眉吗？
- 风格 C → 这棵树能不能让听众沿着脉络往下走？
- 风格 D → 这页打印出来放在董事会桌上看起来够正式吗？
- 风格 E → *The New Yorker* 编辑会不会觉得这版子太装？
- 风格 F → 像不像精品酒店的 lookbook？

具体锚点 > 抽象原则。
