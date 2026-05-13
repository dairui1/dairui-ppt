# Inline Editing 模式 · 浏览器内可编辑

> 让用户在浏览器里直接点文字改文案，自动存 localStorage，Ctrl+S 导出干净的 HTML 文件。**默认不启用**，用户在 Step 1 选了"需要浏览器内编辑"时再加。

适用风格：**A / B / E / F / G / H / I**（横向翻页系）。不适用：C 思维导图（树结构内容来自 markdown）、D 纸（打印优先）。

## 用户使用方式

1. 浏览器打开 deck
2. **进入编辑模式**：鼠标移到左上角触发热区 → 浮出 ✏️ 按钮 → 点击；或者直接按 `E` 键
3. 任意文字变成可编辑（虚线轮廓提示），点击即可改
4. **保存当前修改**：自动每 800ms debounce 存到 `localStorage`
5. **导出文件**：`Ctrl+S` / `⌘S` → 浏览器下载 `presentation.html`，下次打开是干净版本
6. **关闭编辑**：再按 `E` 或点 ✏️ 按钮（变 ✓）

## 集成方式（拷贝粘贴）

把下面**三段**贴到模板的对应位置：

### 1. `<style>` 块末尾追加

```css
/* === Inline editing (opt-in) === */
.edit-hotzone {
  position: fixed;
  top: 0;
  left: 0;
  width: 80px;
  height: 80px;
  z-index: 10000;
  cursor: pointer;
}
.edit-toggle {
  position: fixed;
  top: 18px;
  left: 18px;
  z-index: 10001;
  width: 38px;
  height: 38px;
  border-radius: 50%;
  border: none;
  background: rgba(0, 0, 0, 0.78);
  color: #fff;
  font-size: 16px;
  cursor: pointer;
  opacity: 0;
  pointer-events: none;
  transition: opacity 0.3s ease, transform 0.2s ease;
  display: grid;
  place-items: center;
}
.edit-toggle.show,
.edit-toggle.active {
  opacity: 1;
  pointer-events: auto;
}
.edit-toggle:hover { transform: scale(1.08); }
.edit-toggle.active { background: #2e7d32; }

.edit-banner {
  position: fixed;
  top: 14px;
  left: 70px;
  z-index: 10001;
  padding: 6px 14px;
  background: rgba(0, 0, 0, 0.78);
  color: #fff;
  font-family: ui-monospace, "JetBrains Mono", monospace;
  font-size: 11px;
  letter-spacing: 0.1em;
  text-transform: uppercase;
  border-radius: 4px;
  opacity: 0;
  pointer-events: none;
  transition: opacity 0.3s ease;
}
.edit-banner.active { opacity: 1; }

body.edit-active [contenteditable="true"] {
  outline: 1px dashed rgba(160, 80, 0, 0.55);
  outline-offset: 4px;
  cursor: text;
  border-radius: 2px;
}
body.edit-active [contenteditable="true"]:focus {
  outline: 2px solid rgba(216, 137, 79, 0.85);
  outline-offset: 4px;
}
```

### 2. `<body>` 末尾、`</body>` 前追加

```html
<!-- Inline editing UI -->
<div class="edit-hotzone" id="editHotzone" title="进入编辑模式"></div>
<button class="edit-toggle" id="editToggle" title="编辑 (E)" aria-label="切换编辑模式">✏️</button>
<div class="edit-banner" id="editBanner">编辑模式 · Ctrl/⌘+S 导出</div>
```

### 3. `</body>` 前追加 `<script>` 块

```html
<script>
(function () {
  // 哪些 selector 进入编辑模式时变 contenteditable
  // 各风格可按需扩展；这里覆盖了所有模板用到的文字 class
  const EDITABLE = [
    'h1', 'h2', 'h3', 'h4', 'p', 'span', 'li', 'a', 'em', 'strong',
    '.h-hero', '.h-display', '.h-section', '.h-sub', '.h-xl', '.h-md',
    '.eyebrow', '.lead', '.body-text', '.kicker', '.chrome > *', '.foot > *',
    '.stat-number', '.stat-label', '.stat-note', '.spec-name', '.spec-value', '.spec-note',
    '.pullquote', '.signature', '.timeline-year', '.timeline-text',
    '.mt', '.ml', '.ms', '.mb', '.mi', '.mc', '.co',
    '.cta-box', '.cta-link', '.nav-hint',
  ];

  const STORAGE_KEY = 'dairui-ppt-edits:' + location.pathname;
  const SAVE_DEBOUNCE = 800;

  const hotzone = document.getElementById('editHotzone');
  const toggle = document.getElementById('editToggle');
  const banner = document.getElementById('editBanner');
  let saveTimer = null;
  let hideTimer = null;
  let isActive = false;

  function getEditableEls() {
    const set = new Set();
    EDITABLE.forEach((sel) => {
      try {
        document.querySelectorAll(sel).forEach((el) => {
          // 跳过 UI 控件自身
          if (el.closest('.edit-toggle, .edit-banner, .edit-hotzone, .nav-hint, .progress, #controlsToggle')) return;
          // 至少含有文本子节点
          if (!el.textContent.trim()) return;
          set.add(el);
        });
      } catch (_) { /* invalid selector → 跳过 */ }
    });
    return Array.from(set);
  }

  function enterEdit() {
    isActive = true;
    document.body.classList.add('edit-active');
    toggle.classList.add('active', 'show');
    toggle.textContent = '✓';
    banner.classList.add('active');
    getEditableEls().forEach((el) => {
      el.setAttribute('contenteditable', 'true');
      el.addEventListener('input', scheduleSave);
    });
  }

  function exitEdit() {
    isActive = false;
    document.body.classList.remove('edit-active');
    toggle.classList.remove('active', 'show');
    toggle.textContent = '✏️';
    banner.classList.remove('active');
    document.querySelectorAll('[contenteditable="true"]').forEach((el) => {
      el.removeAttribute('contenteditable');
      el.removeEventListener('input', scheduleSave);
    });
  }

  function toggleMode() {
    if (isActive) exitEdit();
    else enterEdit();
  }

  function scheduleSave() {
    clearTimeout(saveTimer);
    saveTimer = setTimeout(saveToStorage, SAVE_DEBOUNCE);
  }

  function saveToStorage() {
    const data = {};
    getEditableEls().forEach((el, i) => {
      // 用 path 而非 index，避免新增/删除节点错乱
      data[pathOf(el)] = el.innerHTML;
    });
    try {
      localStorage.setItem(STORAGE_KEY, JSON.stringify(data));
    } catch (_) { /* quota / private mode → 静默 */ }
  }

  function restoreFromStorage() {
    let data;
    try { data = JSON.parse(localStorage.getItem(STORAGE_KEY) || '{}'); }
    catch (_) { return; }
    getEditableEls().forEach((el) => {
      const stored = data[pathOf(el)];
      if (stored != null && stored !== el.innerHTML) el.innerHTML = stored;
    });
  }

  function pathOf(el) {
    const parts = [];
    let node = el;
    while (node && node !== document.body) {
      const parent = node.parentNode;
      if (!parent) break;
      const siblings = Array.from(parent.children).filter((c) => c.tagName === node.tagName);
      const idx = siblings.indexOf(node);
      parts.unshift(node.tagName.toLowerCase() + (siblings.length > 1 ? `:${idx}` : ''));
      node = parent;
    }
    return parts.join('>');
  }

  function exportFile() {
    // 关键：导出前剥离 edit 状态，避免下次打开看到虚线和编辑横条
    const wasActive = isActive;
    if (wasActive) {
      document.body.classList.remove('edit-active');
      toggle.classList.remove('active', 'show');
      toggle.textContent = '✏️';
      banner.classList.remove('active');
    }
    document.querySelectorAll('[contenteditable="true"]').forEach((el) => {
      el.removeAttribute('contenteditable');
    });

    const html = '<!DOCTYPE html>\n' + document.documentElement.outerHTML;

    // 恢复 edit 状态
    if (wasActive) {
      document.body.classList.add('edit-active');
      toggle.classList.add('active', 'show');
      toggle.textContent = '✓';
      banner.classList.add('active');
      getEditableEls().forEach((el) => el.setAttribute('contenteditable', 'true'));
    }

    const blob = new Blob([html], { type: 'text/html' });
    const a = document.createElement('a');
    a.href = URL.createObjectURL(blob);
    const baseName = (document.title || 'presentation').replace(/[^\w一-龥-]+/g, '-').slice(0, 60) || 'presentation';
    a.download = baseName + '.html';
    a.click();
    URL.revokeObjectURL(a.href);
  }

  // 1. 点击 toggle 按钮
  toggle.addEventListener('click', toggleMode);

  // 2. 热区 hover + 400ms grace（防止鼠标移到按钮时按钮先消失）
  hotzone.addEventListener('mouseenter', () => {
    clearTimeout(hideTimer);
    toggle.classList.add('show');
  });
  hotzone.addEventListener('mouseleave', () => {
    hideTimer = setTimeout(() => {
      if (!isActive) toggle.classList.remove('show');
    }, 400);
  });
  toggle.addEventListener('mouseenter', () => clearTimeout(hideTimer));
  toggle.addEventListener('mouseleave', () => {
    hideTimer = setTimeout(() => {
      if (!isActive) toggle.classList.remove('show');
    }, 400);
  });

  // 3. 热区直接点击也触发
  hotzone.addEventListener('click', toggleMode);

  // 4. 键盘：E 切换、Ctrl/⌘+S 导出
  window.addEventListener('keydown', (e) => {
    const isText = e.target.getAttribute && e.target.getAttribute('contenteditable') === 'true';
    if ((e.key === 'e' || e.key === 'E') && !isText && !e.ctrlKey && !e.metaKey) {
      e.preventDefault();
      toggleMode();
    } else if ((e.key === 's' || e.key === 'S') && (e.ctrlKey || e.metaKey)) {
      e.preventDefault();
      exportFile();
    }
  });

  // 启动时从 localStorage 恢复
  restoreFromStorage();
})();
</script>
```

## 关键设计决策（不要乱改）

### 为什么用 JS 控制按钮 visibility，不用 CSS `~` sibling 选择器？

CSS-only 的 `hotzone:hover ~ .edit-toggle` 看起来漂亮，但 **会失败**：

1. 用户 hover 热区 → 按钮可见
2. 鼠标移向按钮 → 离开热区
3. CSS 链断 → 按钮立刻消失
4. 鼠标 hover 不到按钮上 → 永远点不到

必须用 JS + 400ms grace timeout：鼠标离开热区后等 400ms 再隐藏，给鼠标足够时间移到按钮上。

### 为什么 export 前要剥离 edit 状态？

`document.documentElement.outerHTML` 抓的是**当前活的 DOM**——包括 `body.edit-active` class、所有 `contenteditable="true"` 属性、toggle 按钮的 `.active` class。如果不剥离，下次有人打开导出的文件会看到：

- 整页虚线轮廓（contenteditable 触发）
- 永远点亮的 ✓ 按钮
- 顶部"编辑模式 · Ctrl+S 导出"横条挂着

剥离 → 抓 outerHTML → 恢复状态——三步必须完整。

### 为什么用 `path-based` key 而不是 `index`？

如果用户在编辑模式里**新增了节点**（例如在某段后面回车多输了一行），index-based 的 selector 会全部错位。`pathOf()` 用 DOM 路径作 key，对增删节点更鲁棒——不是完美方案（重排序时仍会乱），但比 index 强。

### localStorage 满了 / 隐私模式怎么办？

`try / catch` 静默吞掉。用户失去**自动暂存**功能，但当下编辑还能用，导出仍然工作。

### 这些 EDITABLE 选择器够全吗？

覆盖了 A/B/E/F/G/H/I 模板里所有承载文字的 class。如果新风格有自定义 class，**追加到 EDITABLE 数组**即可。不要省略小标签如 `span` / `a`——元数据条 / signature 都在里面。

## 集成到模板时的最小工作量

- 拷贝 3 段代码（CSS / HTML / JS）粘到对应位置
- 跑一次：进入编辑模式 → 改一段文字 → Ctrl+S → 打开导出文件确认干净

## 不该做的事

- ❌ 不要给整个 `<body>` 加 `contenteditable="true"`——会让 SVG、装饰元素也变可编辑，看着乱
- ❌ 不要把 localStorage 存的 HTML 写回原文件——它只是用户的本地暂存，唯一可信导出是 Ctrl+S 下载
- ❌ 不要在 export 后立刻刷新页面——用户可能还想继续编辑
- ❌ 不要把 edit toggle 的位置和翻页指示器（`.nav-hint`）冲突——前者左上，后者右下，已经分开了
