# 动效配方手册 · Animation Patterns

> 把"想要什么感觉"翻译成具体动效。适用于风格 A / B / C / E / F（D 是打印优先格式，**没有动效**）。

## 感觉 → 动效配方对照表

| 感觉 | 入场动效 | 缓动函数 | 时长 | 节奏 | 配合的视觉 |
|---|---|---|---|---|---|
| **戏剧 / 电影感** | 慢速 fade-in + 大幅度 scale（0.9→1）+ 视差滚动 | `cubic-bezier(0.16, 1, 0.3, 1)` | 1000-1500ms | 一次性大动作 | 暗背景、聚光灯效果、满版图片（风格 A、F） |
| **科技 / 未来感** | 霓虹辉光（box-shadow 脉动）+ 文字 glitch / scramble + 网格揭幕 | `linear` 或 `steps()` | 200-400ms | 短促精确 | 粒子背景（canvas）、单色 monospace、青色/品红/电蓝 |
| **轻快 / 友好** | 弹性入场（spring bounce）+ 漂浮 / bobbing | `cubic-bezier(0.34, 1.56, 0.64, 1)` | 400-600ms | 错位 stagger 150-200ms | 圆角、明亮色、手绘元素（风格 C） |
| **专业 / 企业** | 短促 subtle fade（200-300ms）| `ease-out` 或 `ease-in-out` | 200-300ms | 几乎同时 | navy / slate / charcoal、精确间距、数据可视化优先（风格 B） |
| **克制 / 极简** | 极慢的轻微移动、温和淡入 | `ease-out` 长尾 | 800-1200ms | 单一元素 | 大片留白、衬线字体、低饱和（风格 D 不动；E 微动） |
| **编辑 / 杂志感** | 文字 stagger reveal、图文交错揭幕 | `cubic-bezier(0.16, 1, 0.3, 1)` | 600-800ms | 错位 100-150ms | 强字号层级、pull quote、衬线 + 无衬线对话（风格 A、E） |

## 入场动效 CSS 配方

### 1. Fade + Slide Up（最通用，覆盖 80% 场景）

```css
.reveal {
    opacity: 0;
    transform: translateY(30px);
    transition:
        opacity 0.6s cubic-bezier(0.16, 1, 0.3, 1),
        transform 0.6s cubic-bezier(0.16, 1, 0.3, 1);
}
.visible .reveal { opacity: 1; transform: translateY(0); }
```

适用：风格 A、E、F 的所有普通内容。

### 2. Scale In（强调焦点 / hero 标题）

```css
.reveal-scale {
    opacity: 0;
    transform: scale(0.92);
    transition:
        opacity 0.6s,
        transform 0.6s cubic-bezier(0.16, 1, 0.3, 1);
}
```

适用：风格 A/F 的 hero 大标题、数据大字报。

### 3. Slide from Left（顺序揭幕 / 列表项）

```css
.reveal-left {
    opacity: 0;
    transform: translateX(-40px);
    transition:
        opacity 0.6s,
        transform 0.6s cubic-bezier(0.16, 1, 0.3, 1);
}
```

适用：风格 B 的 timeline、四个特性卡片依次进入。

### 4. Blur In（电影感）

```css
.reveal-blur {
    opacity: 0;
    filter: blur(10px);
    transition:
        opacity 0.8s,
        filter 0.8s cubic-bezier(0.16, 1, 0.3, 1);
}
```

适用：风格 F 的 hero、章节封面。**慎用**——长时间 `filter: blur` 在某些 GPU 上昂贵。

### 5. Stroke Draw（SVG 描线 / 框架揭幕）

```css
.reveal-stroke {
    stroke-dasharray: 1;
    stroke-dashoffset: 1;
    animation: stroke-draw 1.2s cubic-bezier(0.16, 1, 0.3, 1) forwards;
}
@keyframes stroke-draw {
    to { stroke-dashoffset: 0; }
}
```

适用：风格 B 的 system diagram、风格 C 的 link curve（已内置）。

### 6. Counter Tick（数字递增）

```javascript
function tickCounter(el, target, duration = 1500) {
    const start = performance.now();
    const from = 0;
    function frame(now) {
        const t = Math.min(1, (now - start) / duration);
        const eased = 1 - Math.pow(1 - t, 3);
        el.textContent = Math.round(from + (target - from) * eased).toLocaleString();
        if (t < 1) requestAnimationFrame(frame);
    }
    requestAnimationFrame(frame);
}
```

适用：风格 A 的 stat-card、风格 B 的 KPI Tower、所有"数据大字报"页。

## Stagger 节奏（错位揭幕）

让多个 `.reveal` 元素依次出现，而不是同时出现：

```css
.reveal:nth-child(1) { transition-delay: 0.1s; }
.reveal:nth-child(2) { transition-delay: 0.2s; }
.reveal:nth-child(3) { transition-delay: 0.3s; }
.reveal:nth-child(4) { transition-delay: 0.4s; }
.reveal:nth-child(5) { transition-delay: 0.5s; }
```

**节奏经验值**：

- 标题 → 副标题 → 正文 → 列表项：每级延迟 100-150ms
- 同级元素（4 个卡片）：每个延迟 80-120ms
- 数据可视化（4 个 KPI）：每个延迟 200-300ms，配合数字 tick
- 不要 ≤ 50ms（看起来像同时）也不要 ≥ 400ms（让人等到不耐烦）

## 背景效果 CSS 配方

### Gradient Mesh（多层径向渐变营造氛围）

```css
.gradient-bg {
    background:
        radial-gradient(ellipse at 20% 80%, rgba(120, 0, 255, 0.18) 0%, transparent 50%),
        radial-gradient(ellipse at 80% 20%, rgba(0, 255, 200, 0.12) 0%, transparent 50%),
        var(--bg-primary);
}
```

适用：风格 A hero 页、风格 F 全部。**透明度都要低**，0.1-0.2 之间，否则就是 AI slop 紫色。

### Noise Texture（细微颗粒，加纸质感）

```css
.noise-bg {
    position: relative;
}
.noise-bg::after {
    content: '';
    position: absolute;
    inset: 0;
    background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='100' height='100'%3E%3Cfilter id='n'%3E%3CfeTurbulence baseFrequency='0.85'/%3E%3CfeColorMatrix values='0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0.08 0'/%3E%3C/filter%3E%3Crect width='100%25' height='100%25' filter='url(%23n)'/%3E%3C/svg%3E");
    pointer-events: none;
    mix-blend-mode: multiply;
}
```

适用：风格 D 已自带纸质感；风格 E（暖纸底）可叠这层加质感。

### Grid Pattern（结构感细线）

```css
.grid-bg {
    background-image:
        linear-gradient(rgba(0,0,0,0.03) 1px, transparent 1px),
        linear-gradient(90deg, rgba(0,0,0,0.03) 1px, transparent 1px);
    background-size: 50px 50px;
}
```

适用：风格 B 已内置；风格 E 偶尔用做章节页底纹。

## 交互效果

### 3D Tilt on Hover（卡片轻微跟手倾斜）

```javascript
class TiltEffect {
    constructor(el, maxDeg = 8) {
        el.style.transformStyle = 'preserve-3d';
        el.style.perspective = '1000px';
        el.addEventListener('mousemove', (e) => {
            const r = el.getBoundingClientRect();
            const x = (e.clientX - r.left) / r.width - 0.5;
            const y = (e.clientY - r.top) / r.height - 0.5;
            el.style.transform = `rotateY(${x * maxDeg}deg) rotateX(${-y * maxDeg}deg)`;
        });
        el.addEventListener('mouseleave', () => {
            el.style.transform = 'rotateY(0) rotateX(0)';
        });
    }
}
```

适用：风格 A/E/F 的图片卡片。**风格 B 禁用**——瑞士风讨厌 fake 3D。

### Magnetic Button（按钮跟手吸引）

```javascript
function magnetic(btn, strength = 0.3) {
    btn.addEventListener('mousemove', (e) => {
        const r = btn.getBoundingClientRect();
        const x = e.clientX - r.left - r.width / 2;
        const y = e.clientY - r.top - r.height / 2;
        btn.style.transform = `translate(${x * strength}px, ${y * strength}px)`;
    });
    btn.addEventListener('mouseleave', () => {
        btn.style.transform = '';
    });
}
```

适用：风格 A/F 的 CTA / closing 按钮。

## 性能 / 兜底

- 优先 `transform` 和 `opacity`——其余属性触发 layout / paint，掉帧
- 不要在 hero 页之外用 `filter: blur`——昂贵
- `will-change` 只在动画进行时加，结束后立刻删
- 检测 `prefers-reduced-motion: reduce`，把所有动画时长压到 0.01ms（已在所有模板里内置）
- 移动端（< 768px）禁用 3D tilt、粒子、parallax

## 风格特定动效推荐

| 风格 | 推荐 | 禁用 |
|---|---|---|
| A · 杂志 | fade+slide / scale / stroke draw / counter tick；Motion One stagger | 弹性 spring bounce、glitch |
| B · 瑞士 | 短促 fade / stroke draw / counter tick；每页一个语义化 recipe | 3D tilt、blur、bouncy easing、float |
| C · 思维导图 | 节点 scale 入场（已内置）、link draw（已内置）、相机 pan | 不要叠任何自定义动效，模板已经平衡好 |
| D · 纸 | **无动效**——打印优先 | 全部 |
| E · 编辑 | fade+slide / 文字 stagger / blur in for hero | 弹性 spring、glitch、neon |
| F · 暗夜植物 | blur in / scale / 慢速 fade / 微浮动 | glitch、grid pattern bg |

## 自检

写完动效部分后回头检查：

1. 每个 `.reveal` 元素都有 functional 的揭幕意义吗？（不是装饰，是引导注意力）
2. 全 deck 有不超过 2 种动效语言吗？（混太多 = 廉价）
3. `prefers-reduced-motion` 测试能正常退化吗？（macOS 系统偏好里勾"减少动态效果"测）
4. 中速翻页时动效能跟上吗？（如果用户连按下一页 5 次，不要让动效卡住界面）
