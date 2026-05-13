#!/usr/bin/env node
// add-editing.mjs — Inject inline editing UI into a generated deck
//
// Usage:
//   node scripts/add-editing.mjs <path/to/index.html>
//
// Idempotent: if the editing block is already present, the script reports
// and exits 0 without re-injecting.

import { readFileSync, writeFileSync } from 'node:fs';
import { resolve } from 'node:path';

const MARKER = '/* dairui-ppt:inline-editing */';

const CSS = `
${MARKER}
.edit-hotzone { position: fixed; top: 0; left: 0; width: 80px; height: 80px; z-index: 10000; cursor: pointer; }
.edit-toggle {
  position: fixed; top: 18px; left: 18px; z-index: 10001;
  width: 38px; height: 38px; border-radius: 50%; border: none;
  background: rgba(0,0,0,0.78); color: #fff; font-size: 16px; cursor: pointer;
  opacity: 0; pointer-events: none;
  transition: opacity 0.3s ease, transform 0.2s ease;
  display: grid; place-items: center;
}
.edit-toggle.show, .edit-toggle.active { opacity: 1; pointer-events: auto; }
.edit-toggle:hover { transform: scale(1.08); }
.edit-toggle.active { background: #2e7d32; }
.edit-banner {
  position: fixed; top: 14px; left: 70px; z-index: 10001;
  padding: 6px 14px; background: rgba(0,0,0,0.78); color: #fff;
  font-family: ui-monospace, "JetBrains Mono", monospace;
  font-size: 11px; letter-spacing: 0.1em; text-transform: uppercase;
  border-radius: 4px; opacity: 0; pointer-events: none;
  transition: opacity 0.3s ease;
}
.edit-banner.active { opacity: 1; }
body.edit-active [contenteditable="true"] {
  outline: 1px dashed rgba(160, 80, 0, 0.55);
  outline-offset: 4px; cursor: text; border-radius: 2px;
}
body.edit-active [contenteditable="true"]:focus {
  outline: 2px solid rgba(216, 137, 79, 0.85);
  outline-offset: 4px;
}
`;

const HTML = `
<!-- ${MARKER} -->
<div class="edit-hotzone" id="editHotzone" title="进入编辑模式"></div>
<button class="edit-toggle" id="editToggle" title="编辑 (E)" aria-label="切换编辑模式">✏️</button>
<div class="edit-banner" id="editBanner">编辑模式 · Ctrl/⌘+S 导出</div>
`;

const JS = `
<script>
// ${MARKER}
(function () {
  const EDITABLE = [
    'h1','h2','h3','h4','p','span','li','a','em','strong',
    '.h-hero','.h-display','.h-section','.h-sub','.h-xl','.h-md',
    '.eyebrow','.lead','.body-text','.kicker','.chrome > *','.foot > *',
    '.stat-number','.stat-label','.stat-note','.spec-name','.spec-value','.spec-note',
    '.pullquote','.signature','.timeline-year','.timeline-text',
    '.mt','.ml','.ms','.mb','.mi','.mc','.co',
    '.cta-box','.cta-link','.nav-hint',
  ];
  const STORAGE_KEY = 'dairui-ppt-edits:' + location.pathname;
  const SAVE_DEBOUNCE = 800;
  const hotzone = document.getElementById('editHotzone');
  const toggle = document.getElementById('editToggle');
  const banner = document.getElementById('editBanner');
  let saveTimer = null, hideTimer = null, isActive = false;
  function getEditableEls() {
    const set = new Set();
    EDITABLE.forEach((sel) => {
      try {
        document.querySelectorAll(sel).forEach((el) => {
          if (el.closest('.edit-toggle, .edit-banner, .edit-hotzone, .nav-hint, .progress, #controlsToggle')) return;
          if (!el.textContent.trim()) return;
          set.add(el);
        });
      } catch (_) {}
    });
    return Array.from(set);
  }
  function pathOf(el) {
    const parts = []; let node = el;
    while (node && node !== document.body) {
      const parent = node.parentNode; if (!parent) break;
      const sib = Array.from(parent.children).filter((c) => c.tagName === node.tagName);
      const idx = sib.indexOf(node);
      parts.unshift(node.tagName.toLowerCase() + (sib.length > 1 ? ':' + idx : ''));
      node = parent;
    }
    return parts.join('>');
  }
  function scheduleSave() { clearTimeout(saveTimer); saveTimer = setTimeout(saveToStorage, SAVE_DEBOUNCE); }
  function saveToStorage() {
    const data = {};
    getEditableEls().forEach((el) => { data[pathOf(el)] = el.innerHTML; });
    try { localStorage.setItem(STORAGE_KEY, JSON.stringify(data)); } catch (_) {}
  }
  function restoreFromStorage() {
    let data; try { data = JSON.parse(localStorage.getItem(STORAGE_KEY) || '{}'); } catch (_) { return; }
    getEditableEls().forEach((el) => {
      const stored = data[pathOf(el)];
      if (stored != null && stored !== el.innerHTML) el.innerHTML = stored;
    });
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
  function toggleMode() { isActive ? exitEdit() : enterEdit(); }
  function exportFile() {
    const wasActive = isActive;
    if (wasActive) {
      document.body.classList.remove('edit-active');
      toggle.classList.remove('active', 'show');
      toggle.textContent = '✏️';
      banner.classList.remove('active');
    }
    document.querySelectorAll('[contenteditable="true"]').forEach((el) => el.removeAttribute('contenteditable'));
    const html = '<!DOCTYPE html>\\n' + document.documentElement.outerHTML;
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
    const baseName = (document.title || 'presentation').replace(/[^\\w一-龥-]+/g, '-').slice(0, 60) || 'presentation';
    a.download = baseName + '.html';
    a.click();
    URL.revokeObjectURL(a.href);
  }
  toggle.addEventListener('click', toggleMode);
  hotzone.addEventListener('mouseenter', () => { clearTimeout(hideTimer); toggle.classList.add('show'); });
  hotzone.addEventListener('mouseleave', () => { hideTimer = setTimeout(() => { if (!isActive) toggle.classList.remove('show'); }, 400); });
  toggle.addEventListener('mouseenter', () => clearTimeout(hideTimer));
  toggle.addEventListener('mouseleave', () => { hideTimer = setTimeout(() => { if (!isActive) toggle.classList.remove('show'); }, 400); });
  hotzone.addEventListener('click', toggleMode);
  window.addEventListener('keydown', (e) => {
    const isText = e.target.getAttribute && e.target.getAttribute('contenteditable') === 'true';
    if ((e.key === 'e' || e.key === 'E') && !isText && !e.ctrlKey && !e.metaKey) {
      e.preventDefault(); toggleMode();
    } else if ((e.key === 's' || e.key === 'S') && (e.ctrlKey || e.metaKey)) {
      e.preventDefault(); exportFile();
    }
  });
  restoreFromStorage();
})();
</script>
`;

function main() {
  const target = process.argv[2];
  if (!target) {
    console.error('Usage: node add-editing.mjs <path/to/index.html>');
    process.exit(1);
  }
  const path = resolve(target);
  let html = readFileSync(path, 'utf8');

  if (html.includes(MARKER)) {
    console.log(`✓ ${target} 已含 inline editing 注入，跳过`);
    return;
  }

  const styleEnd = html.lastIndexOf('</style>');
  const bodyEnd = html.lastIndexOf('</body>');

  if (styleEnd === -1 || bodyEnd === -1) {
    console.error(`✗ ${target}: 没有找到 </style> 或 </body>，文件结构异常`);
    process.exit(2);
  }

  // 1. CSS 在最后一个 </style> 前
  html = html.slice(0, styleEnd) + CSS + html.slice(styleEnd);

  // 重新算位置（CSS 插入后偏移了）
  const newBodyEnd = html.lastIndexOf('</body>');

  // 2. HTML UI + 3. JS 在 </body> 前
  html = html.slice(0, newBodyEnd) + HTML + JS + html.slice(newBodyEnd);

  writeFileSync(path, html, 'utf8');
  console.log(`✓ 已注入 inline editing 到 ${target}`);
  console.log('  · 移到左上角或按 E 进入编辑模式');
  console.log('  · Ctrl/⌘+S 导出干净的 HTML');
}

main();
