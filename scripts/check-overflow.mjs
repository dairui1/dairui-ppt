#!/usr/bin/env node
// check-overflow.mjs — Probe each <section class="slide"> for viewport overflow
// at three standard projector sizes.
//
// Usage:
//   node scripts/check-overflow.mjs path/to/deck.html
//
// Requires Puppeteer:
//   npm install -g puppeteer    (or)    npm install puppeteer  in this repo

import { existsSync } from 'node:fs';
import { resolve } from 'node:path';
import { pathToFileURL } from 'node:url';

const VIEWPORTS = [
  { name: '1920×1080', width: 1920, height: 1080 },
  { name: '1280×720',  width: 1280, height: 720  },
  { name: '1024×640',  width: 1024, height: 640  },
];

async function main() {
  const target = process.argv[2];
  if (!target) {
    console.error('Usage: node check-overflow.mjs <path/to/deck.html>');
    process.exit(1);
  }
  const absPath = resolve(target);
  if (!existsSync(absPath)) {
    console.error(`✗ 找不到文件: ${absPath}`);
    process.exit(2);
  }
  const fileURL = pathToFileURL(absPath).href;

  let puppeteer;
  try {
    puppeteer = (await import('puppeteer')).default;
  } catch (_) {
    console.error('✗ 没装 puppeteer。先跑:');
    console.error('  npm install puppeteer');
    console.error('  或全局: npm install -g puppeteer');
    process.exit(3);
  }

  const browser = await puppeteer.launch({ headless: 'new' });
  let totalFail = 0;
  let totalCheck = 0;

  for (const vp of VIEWPORTS) {
    const page = await browser.newPage();
    await page.setViewport({ width: vp.width, height: vp.height, deviceScaleFactor: 1 });
    await page.goto(fileURL, { waitUntil: 'networkidle0', timeout: 30000 });
    // 给字体 / 动效一点稳定时间
    await new Promise((r) => setTimeout(r, 1200));

    const results = await page.evaluate(() => {
      const slides = document.querySelectorAll('.slide');
      return Array.from(slides).map((slide, i) => {
        // 让该 slide 可见（横向 deck 有 transform: translateX，先临时取消）
        const parent = slide.parentElement;
        const savedTransform = parent?.style.transform;
        if (parent) parent.style.transform = `translateX(-${i * 100}vw)`;

        const slideRect = slide.getBoundingClientRect();
        // 检查 slide 自己是否大于 viewport
        const slideOverflowH = slide.scrollWidth - slide.clientWidth;
        const slideOverflowV = slide.scrollHeight - slide.clientHeight;

        // 也检查所有子元素是否溢出 slide
        let maxChildBottom = 0;
        let maxChildRight = 0;
        slide.querySelectorAll('*').forEach((el) => {
          if (el.offsetParent === null) return;
          const r = el.getBoundingClientRect();
          // 相对于 slide
          const relBottom = r.bottom - slideRect.top;
          const relRight = r.right - slideRect.left;
          if (relBottom > maxChildBottom) maxChildBottom = relBottom;
          if (relRight > maxChildRight) maxChildRight = relRight;
        });

        if (parent && savedTransform != null) parent.style.transform = savedTransform;

        return {
          index: i + 1,
          slideOverflowH,
          slideOverflowV,
          childOverflowV: Math.max(0, Math.round(maxChildBottom - slideRect.height)),
          childOverflowH: Math.max(0, Math.round(maxChildRight - slideRect.width)),
        };
      });
    });

    console.log(`\n[${vp.name}]`);
    for (const r of results) {
      totalCheck++;
      const issues = [];
      if (r.slideOverflowV > 1) issues.push(`slide V+${r.slideOverflowV}px`);
      if (r.slideOverflowH > 1) issues.push(`slide H+${r.slideOverflowH}px`);
      if (r.childOverflowV > 4) issues.push(`child V+${r.childOverflowV}px`);
      if (r.childOverflowH > 4) issues.push(`child H+${r.childOverflowH}px`);
      if (issues.length === 0) {
        console.log(`  slide ${r.index}: ✓ fits`);
      } else {
        totalFail++;
        console.log(`  slide ${r.index}: ✗ ${issues.join(', ')}`);
      }
    }
    await page.close();
  }

  await browser.close();
  console.log('');
  if (totalFail === 0) {
    console.log(`✓ 全部通过 (${totalCheck} 检查)`);
    process.exit(0);
  } else {
    console.log(`✗ ${totalFail} / ${totalCheck} 项不通过`);
    console.log('  修复建议: 拆页 / 压缩内容 / 调 clamp 上下限，不要加 overflow:auto');
    process.exit(4);
  }
}

main().catch((e) => {
  console.error('check-overflow 崩了:', e?.message || e);
  process.exit(99);
});
