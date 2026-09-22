/* Kitchen Book offline cache.
   The app shell is cached on install so the book opens with no signal.
   Google Fonts are cached the first time they are fetched. Calls to
   api.anthropic.com and the SDK on jsdelivr are never cached — those
   need a live connection anyway. */
const VERSION = "kitchen-book-v2";
const SHELL = ["./", "./index.html", "./manifest.webmanifest", "./icon-192.png"];

self.addEventListener("install", event => {
  event.waitUntil(
    caches.open(VERSION).then(c => c.addAll(SHELL)).then(() => self.skipWaiting())
  );
});

self.addEventListener("activate", event => {
  event.waitUntil(
    caches.keys()
      .then(keys => Promise.all(keys.filter(k => k !== VERSION).map(k => caches.delete(k))))
      .then(() => self.clients.claim())
  );
});

function isFont(url){
  return url.hostname === "fonts.googleapis.com" || url.hostname === "fonts.gstatic.com";
}

self.addEventListener("fetch", event => {
  const req = event.request;
  if(req.method !== "GET") return;
  const url = new URL(req.url);
  if(url.hostname === "api.anthropic.com" || url.hostname === "cdn.jsdelivr.net") return;

  /* Page loads: try the network, fall back to the cached shell. */
  if(req.mode === "navigate"){
    event.respondWith(
      fetch(req).catch(() => caches.match("./index.html").then(r => r || caches.match("./")))
    );
    return;
  }

  if(url.origin === self.location.origin || isFont(url)){
    event.respondWith(
      caches.match(req).then(hit => {
        if(hit) return hit;
        return fetch(req).then(res => {
          if(res && (res.ok || res.type === "opaque")){
            const copy = res.clone();
            caches.open(VERSION).then(c => c.put(req, copy)).catch(() => {});
          }
          return res;
        });
      })
    );
  }
});
