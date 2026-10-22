// Habit Tracker: riceve gli avvisi degli impegni e li mostra come notifica.
// Non salva pagine né dati: l'app continua a caricarsi sempre dal sito.
self.addEventListener("install", () => self.skipWaiting());
self.addEventListener("activate", (event) => event.waitUntil(self.clients.claim()));
self.addEventListener("push", (event) => {
  let data = {};
  try { data = event.data ? event.data.json() : {}; } catch (_) { data = { body: event.data ? event.data.text() : "" }; }
  event.waitUntil(self.registration.showNotification(data.title || "Habit Tracker", {
    body: data.body || "", tag: data.tag, icon: "icon-180.png", badge: "icon-180.png", data: { url: data.url || "./" }
  }));
});
self.addEventListener("notificationclick", (event) => {
  event.notification.close();
  const url = new URL((event.notification.data && event.notification.data.url) || "./", self.registration.scope).href;
  event.waitUntil(self.clients.matchAll({ type: "window", includeUncontrolled: true }).then((list) => {
    // App già aperta: la porto davanti e le dico quale pagina mostrare (per le medicine «#medicine»).
    const route = new URL(url).hash.slice(1);
    for (const client of list) if ("focus" in client) { if (route) client.postMessage({ route }); return client.focus(); }
    return self.clients.openWindow(url);
  }));
});
