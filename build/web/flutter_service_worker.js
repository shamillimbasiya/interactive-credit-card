'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"version.json": "eda54c39bafb537c56099b220045b240",
"index.html": "7e6c3fe1140d5eceaded0df29ee4f49a",
"/": "7e6c3fe1140d5eceaded0df29ee4f49a",
"main.dart.js": "59c79987791d5c5def0eafb384287261",
"flutter.js": "6fef97aeca90b426343ba6c5c9dc5d4a",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"manifest.json": "ab1450a74276f35f3d1b9772fa456771",
"assets/AssetManifest.json": "9efa3a759ff2257527610cde1c58db7a",
"assets/NOTICES": "dc1e1411b8a2abacd0c0cce1f9d0074e",
"assets/FontManifest.json": "7b2a36307916a9721811788013e65289",
"assets/shaders/ink_sparkle.frag": "f8b80e740d33eb157090be4e995febdf",
"assets/AssetManifest.bin": "f3e5d1b7591c2b2e4e8020ff91ebe73f",
"assets/fonts/MaterialIcons-Regular.otf": "32fce58e2acb9c420eab0fe7b828b761",
"assets/assets/images/10.jpeg": "a0c83af51972c056ede59a1e488fe57e",
"assets/assets/images/discover.png": "62706277b8600fc43afcdf69be858c07",
"assets/assets/images/1.jpeg": "dd976805e1c1573ba2e6b6faf9f56541",
"assets/assets/images/troy.png": "70cc58fabc21a364ab48a7308d489279",
"assets/assets/images/11.jpeg": "7347d17081beba503b57c80d92d988ab",
"assets/assets/images/20.jpeg": "d7d8f6e6c9bf8c929ed071ac06a32b28",
"assets/assets/images/16.jpeg": "eef3dd17ec5bb4f0fe9989450bc37825",
"assets/assets/images/chip.png": "2c37b1d33b45b2158112bb8172af579b",
"assets/assets/images/6.jpeg": "c55f380c57b10c038b0c7f7182089371",
"assets/assets/images/visa.png": "2bc1a543f98a84cc4afda7dbff7e976d",
"assets/assets/images/7.jpeg": "87daa240b240d76d2adbe5d3f5ad7fa1",
"assets/assets/images/17.jpeg": "625d9dfd8b297e5637d6f14e0fc84fa0",
"assets/assets/images/21.jpeg": "cd0636da63f755981c343ca26a769f17",
"assets/assets/images/8.jpeg": "1389dd96a7d8da683e087d747905da86",
"assets/assets/images/22.jpeg": "1a26d6c3f53d1bd77a48162b58c9e280",
"assets/assets/images/18.jpeg": "9801848a65becfb59a1ebc7f204f1e1b",
"assets/assets/images/4.jpeg": "ed09586227a4f01b9548a4a478b95ce8",
"assets/assets/images/14.jpeg": "17c283b139cd1066de6641c1cd42ded2",
"assets/assets/images/15.jpeg": "9e17b96b7a70fc8ac9160be2bcd67f94",
"assets/assets/images/5.jpeg": "c5d4f6f5bb10b6843507854a5b281531",
"assets/assets/images/19.jpeg": "db8a2b71d19d9e2ece2b47896bf01575",
"assets/assets/images/23.jpeg": "4916215a09960d60f9dbe9a444df4eca",
"assets/assets/images/9.jpeg": "2cc830577fe4c062aea5d48c00cead49",
"assets/assets/images/jcb.png": "87087e5e777b4dc7859e35dcfd8d77aa",
"assets/assets/images/dinersclub.png": "c46530f74b5be25f5957c0139c42718d",
"assets/assets/images/2.jpeg": "0a55c9d5e440cf2256a0efa58f98621c",
"assets/assets/images/12.jpeg": "83d3b0df446ff19a5ca726715b0498b1",
"assets/assets/images/amex.png": "d06ee9b4a3b054e4a1bc8c294144c6d7",
"assets/assets/images/24.jpeg": "2555dbb51f045590442c6f841fb2c58c",
"assets/assets/images/mastercard.png": "cdaba15c87239cfe3126dda858c2078f",
"assets/assets/images/unionpay.png": "40ead9adb1960b406a610a268acf0ebc",
"assets/assets/images/25.jpeg": "5b2a3e2910e186151a6557042383fbe5",
"assets/assets/images/13.jpeg": "d8d7c0e50ce711f0834220b771cc03bd",
"assets/assets/images/3.jpeg": "96fa375f4277e32d7ef62005d76fe2c7",
"canvaskit/skwasm.js": "95f16c6690f955a45b2317496983dbe9",
"canvaskit/skwasm.wasm": "1a074e8452fe5e0d02b112e22cdcf455",
"canvaskit/chromium/canvaskit.js": "96ae916cd2d1b7320fff853ee22aebb0",
"canvaskit/chromium/canvaskit.wasm": "be0e3b33510f5b7b0cc76cc4d3e50048",
"canvaskit/canvaskit.js": "bbf39143dfd758d8d847453b120c8ebb",
"canvaskit/canvaskit.wasm": "42df12e09ecc0d5a4a34a69d7ee44314",
"canvaskit/skwasm.worker.js": "51253d3321b11ddb8d73fa8aa87d3b15"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"assets/AssetManifest.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
