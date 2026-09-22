"use strict";
const slides = Array.from(document.querySelectorAll('.slide'));
const deck = document.getElementById('deck');
let page = 0;
let videoUrl = '';
slides.forEach((slide, index) => { slide.dataset.page = String(index + 1).padStart(2, '0'); });
function resizeDeck() {
  const overview = document.body.classList.contains('overview');
  const scale = Math.max(.15, Math.min(1, (innerWidth - 32) / 1280, overview ? 1 : (innerHeight - 164) / 720));
  slides.forEach(slide => { slide.style.zoom = scale; });
}
function showPage(index, updateHash = true) {
  page = Math.max(0, Math.min(slides.length - 1, index));
  slides.forEach((slide, i) => { slide.classList.toggle('active', i === page); });
  document.getElementById('page-label').textContent = `${String(page + 1).padStart(2, '0')} / ${slides.length}`;
  document.getElementById('slide-title').textContent = slides[page].dataset.title;
  document.getElementById('progress-fill').style.width = `${(page + 1) / slides.length * 100}%`;
  document.getElementById('previous').disabled = page === 0;
  document.getElementById('next').disabled = page === slides.length - 1;
  if (updateHash) history.replaceState(null, '', `#${page + 1}`);
  const video = document.getElementById('demo-video');
  if (video && !slides[page].contains(video)) video.pause();
  const youtube = document.getElementById('youtube-demo');
  if (youtube && !slides[page].contains(youtube) && youtube.dataset.playable === 'true') {
    youtube.src = youtube.src;
    youtube.dataset.playable = 'false';
  }
  if (youtube && slides[page].contains(youtube)) youtube.dataset.playable = 'true';
}
function overviewToggle() {
  const enabled = document.body.classList.toggle('overview');
  document.getElementById('overview').textContent = enabled ? '発表モード' : '一覧表示';
  resizeDeck();
  if (enabled) slides[page].scrollIntoView({block:'center'});
}
function toggleNotes() { document.body.classList.toggle('show-notes'); }
async function fullscreen() {
  try { if(document.fullscreenElement) await document.exitFullscreen(); else await document.documentElement.requestFullscreen(); }
  catch { document.getElementById('fullscreen').textContent = 'F11 全画面'; }
}
document.getElementById('previous').addEventListener('click', () => showPage(page - 1));
document.getElementById('next').addEventListener('click', () => showPage(page + 1));
document.getElementById('overview').addEventListener('click', overviewToggle);
document.getElementById('notes-toggle').addEventListener('click', toggleNotes);
document.getElementById('fullscreen').addEventListener('click', fullscreen);
document.getElementById('print').addEventListener('click', () => window.print());
document.addEventListener('keydown', event => {
  if(event.target.closest('input,video,button,[contenteditable]') || event.ctrlKey || event.metaKey || event.altKey) return;
  if(['ArrowRight','PageDown',' '].includes(event.key)) { event.preventDefault(); showPage(page + 1); }
  if(['ArrowLeft','PageUp'].includes(event.key)) { event.preventDefault(); showPage(page - 1); }
  if(event.key === 'Home') { event.preventDefault(); showPage(0); }
  if(event.key === 'End') { event.preventDefault(); showPage(slides.length - 1); }
  if(event.key.toLowerCase() === 'o') overviewToggle();
  if(event.key.toLowerCase() === 'n') toggleNotes();
  if(event.key.toLowerCase() === 'f') fullscreen();
});
slides.forEach((slide,index) => slide.addEventListener('click', event => {
  if(document.body.classList.contains('overview') && !event.target.closest('button,input,label,video,[contenteditable]')) { showPage(index); overviewToggle(); window.scrollTo(0,0); }
}));
document.querySelectorAll('[data-save]').forEach(field => {
  const key = `kumanomae-presentation-${field.dataset.save}`;
  try { const saved = localStorage.getItem(key); if(saved) field.textContent = saved; } catch {}
  field.addEventListener('input', () => { try { localStorage.setItem(key, field.textContent); } catch {} });
  field.addEventListener('paste', event => { event.preventDefault(); const text = event.clipboardData.getData('text/plain'); field.textContent = text.slice(0,120); field.dispatchEvent(new Event('input')); });
});
document.getElementById('video-file')?.addEventListener('change', event => {
  const file = event.target.files[0]; if(!file) return;
  const video = document.getElementById('demo-video');
  video.pause(); if(videoUrl) URL.revokeObjectURL(videoUrl);
  videoUrl = URL.createObjectURL(file); video.src = videoUrl;
  video.closest('.video-box').classList.add('has-video');
  document.getElementById('video-status').textContent = file.name;
});
document.getElementById('demo-video')?.addEventListener('error', () => { document.getElementById('video-status').textContent = '再生できない形式です。MP4動画を選択してください。'; });
window.addEventListener('resize', resizeDeck);
window.addEventListener('hashchange', () => showPage((Number(location.hash.slice(1)) || 1) - 1, false));
showPage((Number(location.hash.slice(1)) || 1) - 1, false);
resizeDeck();
