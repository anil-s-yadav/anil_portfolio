const CACHE_NAME = 'anil-portfolio-swr-v3';

// Core shell assets to precache immediately for 0ms instant startup
const PRECACHE_ASSETS = [
  './',
  'index.html',
  'flutter_bootstrap.js?v=2',
  'main.dart.wasm',
  'canvaskit/skwasm.wasm',
  'canvaskit/skwasm.js',
  'main.dart.mjs',
  'manifest.json',
  'favicon.ico'
];

self.addEventListener('install', (event) => {
  self.skipWaiting();
  event.waitUntil(
    caches.open(CACHE_NAME).then((cache) => {
      return Promise.allSettled(
        PRECACHE_ASSETS.map((url) =>
          cache.add(url).catch((err) => {
            console.debug('Precache skipped for', url, err);
          })
        )
      );
    })
  );
});

self.addEventListener('activate', (event) => {
  event.waitUntil(
    caches.keys().then((keys) => {
      return Promise.all(
        keys.filter((key) => key !== CACHE_NAME).map((key) => caches.delete(key))
      );
    }).then(() => self.clients.claim())
  );
});

self.addEventListener('fetch', (event) => {
  const req = event.request;
  if (req.method !== 'GET') return;

  const url = new URL(req.url);

  // Never cache Firestore or Google Firebase live backend API calls
  if (
    url.hostname.includes('firestore.googleapis.com') ||
    url.hostname.includes('firebase.googleapis.com') ||
    url.hostname.includes('identitytoolkit.googleapis.com')
  ) {
    return;
  }

  // Stale-While-Revalidate strategy for all portfolio web assets
  event.respondWith(
    caches.open(CACHE_NAME).then(async (cache) => {
      const cached = await cache.match(req);

      // Background revalidation
      const fetchPromise = fetch(req).then((networkResponse) => {
        if (networkResponse && (networkResponse.status === 200 || networkResponse.type === 'opaque')) {
          cache.put(req, networkResponse.clone());
        }
        return networkResponse;
      }).catch(() => {
        // Network unavailable / offline
        return cached;
      });

      // Serve from cache immediately if available (0ms), otherwise wait for network
      return cached || fetchPromise;
    })
  );
});
