# 多幕动画演示 · Multi-Scene Animation Pattern

这是一种**表达方式**，跨风格通用——不属于风格 A/B/C 任何一种。任何风格都可以套用这个 pattern 做"边讲边演"的动态演示。

## 何时用

- 解释一个**有时序的多步骤系统**（一次请求经过多少层、一个状态从 A 翻到 B 的全过程）
- 静态图说不清——需要看见**事情发生**才直观
- 但视频又太重——希望单文件 HTML、随时暂停、可点跳转
- 比如：技术 pipeline、数据流、决策树、协议握手、UI 状态机

不适合：单一截图说清的内容、纯叙述类（没有时序）、需要异步阅读的（你不会盯着读者播放）。

## 核心结构

```
┌───────────────────────────────────────────────────────────┐
│              [01 INPUT] → [02 ...] → [03 ...] →  ← 进度点  │
├──────────────────────┬───────────────────────────────────┤
│                      │                                    │
│   左卡片             │     右舞台（SVG / canvas）         │
│   ─────              │     ───────────────────            │
│   场景标题            │                                    │
│   一段说明 + 代码     │     动画在这里发生                  │
│   file:line 引用     │                                    │
│                      │                                    │
├──────────────────────┴───────────────────────────────────┤
│   ◀ PREV   ▶ PLAY   NEXT ▶   ⟲ RESET   1×   场景 1/5 · 0.0s │
└───────────────────────────────────────────────────────────┘
```

**三个区**：
- **顶部进度点条** — N 个可点击的"幕"，当前幕高亮、已完成的标 done
- **主区 split** — 左 38% 解说卡片（同一时刻只一张激活）+ 右 62% 舞台（同一时刻只一个 SVG 激活）
- **底部控件** — 上一幕 / 播放暂停 / 下一幕 / 重置 / 速度切换 / 时间显示

**两套切换**：
- **同步切换**：进度点 / 卡片 / 舞台是 1:1:1 对应的。点进度点跳幕 = 卡片淡入淡出 + 舞台滑入滑出。
- **场内播放**：每幕自己内部有时序——按 `t = elapsed / duration`（0 到 1）跑 init/animate 函数，元素逐步出现 / 移动 / 变色。

## 引擎（约 80 行 JS）

```js
const SCENES = [
  {
    id: 1, key:'input',  label:'INPUT',  duration: 4800,
    init() {
      // 把这一幕涉及的元素全部复位到 t=0 状态
      $('s1-cap').setAttribute('opacity', '0');
      $('s1-arrow').setAttribute('opacity', '0');
      $('s1-cmd').textContent = '';
    },
    animate(t) {
      // t 是 0..1，这一幕的归一化进度
      // 在这里把每个时间点该出现 / 该到哪里的东西写出来
      const typeT = clamp(t / 0.45, 0, 1);
      const cmd = '/goal "rewrite all tests"';
      $('s1-cmd').textContent = cmd.slice(0, Math.floor(typeT * cmd.length));
      $('s1-arrow').setAttribute('opacity', String(clamp((t-0.6)/0.12, 0, 1)));
      const capT = clamp((t-0.7)/0.18, 0, 1);
      $('s1-cap').setAttribute('opacity', String(capT));
    },
  },
  // ... 更多幕
];

const TOTAL = SCENES.reduce((s, sc) => s + sc.duration, 0);
let current = 0, elapsedInScene = 0, playing = false, speed = 1, lastFrame = 0;

function setActiveScene(idx) {
  const prev = current;
  current = idx;
  // 切进度点
  document.querySelectorAll('.prog .dot').forEach((d, i) => {
    d.classList.toggle('active', i === idx);
    d.classList.toggle('done',   i < idx);
  });
  // 切卡片
  document.querySelectorAll('.card').forEach((c, i) => c.classList.toggle('active', i === idx));
  // 切舞台
  document.querySelectorAll('.stage').forEach((s, i) => s.classList.toggle('active', i === idx));
  // 复位新幕
  SCENES[idx].init();
  elapsedInScene = 0;
}

function tick(now) {
  if (!playing) return;
  if (!lastFrame) lastFrame = now;
  const dt = (now - lastFrame) * speed;
  lastFrame = now;
  elapsedInScene += dt;
  const sc = SCENES[current];
  const t = elapsedInScene / sc.duration;
  if (t >= 1) {
    sc.animate(1);
    if (current < SCENES.length - 1) {
      setActiveScene(current + 1);
    } else {
      playing = false;
      return;
    }
  } else {
    sc.animate(t);
  }
  requestAnimationFrame(tick);
}

// 控件绑定（play/prev/next/reset/speed/键盘 / 略）
```

完整可工作版本见 `template-sketchnote.html` 中的 `<script>` 段落（或上层 demo 仓库里的 canonical 实现）。

## 切换效果（不要做错）

**舞台切换**：用 CSS transition 做 fade + 横向位移（暗示"前进"方向）。

```css
.stage{
  position: absolute; inset: 0;
  opacity: 0; transform: translateX(28px) scale(.985);
  transition: opacity .45s ease, transform .45s ease;
  pointer-events: none;
}
.stage.active{
  opacity: 1; transform: translateX(0) scale(1);
  pointer-events: auto;
}
```

**卡片切换**：用 fade + 微小向上位移。

```css
.card{
  position: absolute; inset: 0;
  opacity: 0; transform: translateY(14px);
  transition: opacity .42s ease, transform .42s ease;
  pointer-events: none;
}
.card.active{opacity: 1; transform: translateY(0); pointer-events: auto}
```

**不要做的事**：
- 不要用 carousel 横向滑动整页（容易晕、感觉重）
- 不要用 dissolve / 拼图 / 旋转切换 → 干扰内容
- 不要把切换时间设到 1s 以上 → 等不及；也别小于 .25s → 闪烁

## 每幕动画内的常见动作

| 动作 | t 范围（这一幕内） | 怎么写 |
|---|---|---|
| 元素淡入 | 0.0-0.15 | `opacity = clamp(t/0.15, 0, 1)` |
| 元素滑入 | 0.0-0.2 | `translate(${lerp(start, end, easeInOut(t/0.2))}, y)` |
| 文字逐字敲 | 0.0-0.45 | `text = full.slice(0, Math.floor(t/0.45 * full.length))` |
| 路径绘制 | 0.2-0.4 | `stroke-dashoffset` 从 totalLength 到 0 |
| 闸门 / 列表逐项亮起 | 0.2-0.6 | 每项分配 `(t - start - i*step) / step > 0` 触发 |
| 元素沿 path 走 | 0.5-0.85 | `path.getPointAtLength(L * easeInOut(t))` 取点 |
| 状态翻转 / LED 切色 | 0.85-1.0 | 直接 toggle class 一次性切换 |
| 收尾 stamp | 0.9-1.0 | 最后一个元素 opacity 0→1，提示"这一幕结束" |

## 时序设计的几个原则

- **一幕 3-6 秒**。短于 3 秒不够看清，长于 6 秒注意力流失。
- **第一幕 + 最后一幕可以稍长**（4-6s）——开场要建立角色，收场要让结论留印象。中间幕短一些（3-5s）。
- **总时长别超过 30 秒**。多了用户不会等完整循环，请增加 NEXT 按键的存在感而不是延长每幕。
- **每幕只讲一件事**。不要在一幕里塞"输入 + 处理 + 输出"三步——拆成三幕。
- **缓动函数永远用 easeInOut**。`t < .5 ? 2*t*t : 1 - Math.pow(-2*t+2, 2)/2`。线性运动不自然。

## 卡片内容（左 38% 的设计）

每张卡片标配六个 slot：

```
┌───────────────────────────┐
│ SCENE 02 · STATION 2/4    │ ← sc-num（mono，红色，tracked，uppercase）
│                           │
│ 场景大标题                  │ ← h2（Display font，700，30-40px）
│ 子标题 / 上下文            │ ← sc-sub（hand font 400, 15px）
│                           │
│ 一段说明 70-120 字          │ ← sc-body（hand font 400, 17-19px）
│ 里头可以套 <code>          │   highlighter 标记重点用 <b><u><em>
│ 标识符或 <em>关键词</em>。  │
│                           │
│ ┌─ pre code block ─────┐  │ ← <pre>（mono, 12-13px, max-height 300px）
│ │ create_goal_table()  │  │   可以折叠成 max-height + scroll
│ │   thread_id TEXT     │  │
│ └───────────────────────┘  │
│                           │
│ ⤷ file/path:line · 引用    │ ← sc-foot（mono, 11-12px, 灰色）
└───────────────────────────┘
```

- 字号比静态 PPT 大一档——单屏只有一张卡，可以放开
- 代码块不要超过 12 行——超了就跳到 sticky note 旁注，别把代码塞进卡里
- `file:line` 引用必须给——这是技术演示的可信度锚

## 舞台内容（右 62% 的设计）

每个舞台是一个**独立的 SVG**（`viewBox="0 0 800 600"`，比例 4:3，跟 16:9 的右侧栏宽高比相对契合）。

**舞台 = 一张漫画分镜**。把这一幕要演的东西摆进去：

- 左边：上一幕传过来的"角色"（如果有连续性）
- 中间：本幕的主舞台（机器、表、闸门、工具）
- 右边：传给下一幕的入口提示

每个 SVG 元素都给一个 ID 或 class hook，让 `animate(t)` 函数能 `getElementById` 找到并调整 attr。

**不要**：
- 不要把整个动画塞进一个超大 SVG，多个场景共享同一个 SVG → 切场景时只能 toggle 元素可见性，过渡不自然
- 不要在 init() 里重建 DOM → 性能不好，且过渡丢失

**要**：
- 每幕一个独立 SVG，CSS opacity / transform 做整体淡入淡出
- 幕内元素只调 attr 不 add/remove

## 控件 + 键盘

```html
<button id="prev">◀ PREV</button>
<button class="play" id="play">▶ PLAY</button>
<button id="next">NEXT ▶</button>
<button id="reset">⟲ RESET</button>
<button id="speed">1×</button>
<span class="time" id="time">scene 1/5 · 0.0s</span>
```

```js
window.addEventListener('keydown', e => {
  if (e.key === ' ') { e.preventDefault(); playBtn.click(); }
  else if (e.key === 'ArrowLeft')  prevBtn.click();
  else if (e.key === 'ArrowRight') nextBtn.click();
  else if (e.key === 'r' || e.key === 'R') resetBtn.click();
});
```

速度按钮循环 `[1, 1.5, 2, 0.5]`——`0.5` 给逐帧研究、`2` 给已经看过想快速回顾。

## 响应式

> **小屏上整页同时显示所有幕 = 字小到看不清。**

那个错误的反面教训是 demo 的原始版本：把 5 幕全塞在一张 1600 宽的大画布里，手机上字小成米粒。

正确做法（这个 pattern 已经做到了）：
- 大屏（>920px）：左右 split
- 小屏（≤920px）：堆叠成上下——卡片在上、舞台在下、controls 在底；其它幕的卡片 `display:none`（不要 absolute 叠加）

```css
@media (max-width: 920px){
  .layout{grid-template-columns: 1fr; gap: 14px}
  .card-pane, .stage-pane{min-height: auto; position: relative}
  .scene-card{position: relative; inset: auto; height: auto}
  .scene-card:not(.active){display: none}
  .stage-pane{height: 55vh}
}
```

## 集成到风格里

这个 pattern 可以套在任何风格上。只要：

- **背景 + 字体走风格的设计语言**（风格 J 走 sketchnote，风格 B 走瑞士，等）
- **卡片样式走风格的卡片**（J 是 sticky note 黄底，B 是白底窄边）
- **过渡效果保持** —— fade + 微小位移
- **舞台 SVG 元素的视觉走风格**（J 用 wobble filter 抖动方块，B 用精确网格线条）

最推荐的组合：
- **风格 J + 多幕动画** = 边讲边画的解说视频替代品（本仓库 sketchnote 模板就是这个组合）
- **风格 B + 多幕动画** = 学术 / 工程报告的可视化系统图解
- **风格 I + 多幕动画** = 终端 hacker 风的协议握手 / debug timeline 演示

## 自检清单

发出去前：

- [ ] 每一幕 `init()` 都把这一幕用到的元素**完全复位**到 t=0 状态（不要假设上一幕没改它）
- [ ] 每个 `animate(t)` 在 t=0 和 t=1 时都到达"该有的状态"（不要漏边界）
- [ ] 切幕动画时间 ≤ 0.5s（不要慢）
- [ ] 每幕 duration 在 3-6s 之间
- [ ] 总时长 ≤ 30s
- [ ] 键盘三个按键（空格 / ←→ / R）都接好
- [ ] 速度按钮循环 `[1, 1.5, 2, 0.5]`
- [ ] 进度点可点击跳转
- [ ] 小屏（开发者工具切 iPhone）上每幕能独立看清，没有把所有幕堆在一起
- [ ] 字号在小屏上 ≥ 14px
- [ ] 没有把动画引擎里 `getPointAtLength` / `getTotalLength` 在每一帧都调用——缓存到一次性的 `const L = path.getTotalLength()`
- [ ] 暂停 / 重置 / 切幕的状态机正确（没有"播完了点 play 不动"这种 bug）
