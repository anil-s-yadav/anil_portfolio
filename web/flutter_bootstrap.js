{{flutter_js}}
{{flutter_build_config}}

_flutter.loader.load({
  config: {
    canvasKitBaseUrl: "canvaskit/"
  },
  onEntrypointLoaded: async function(engineInitializer) {
    try {
      const appRunner = await engineInitializer.initializeEngine();
      await appRunner.runApp();
    } catch (e) {
      console.error("Failed to initialize Flutter app:", e);
    } finally {
      const bar = document.getElementById('loading-bar');
      if (bar) {
        bar.style.transition = 'opacity 0.25s ease';
        bar.style.opacity = '0';
        setTimeout(function() {
          if (bar && bar.parentNode) {
            bar.parentNode.removeChild(bar);
          }
        }, 250);
      }
    }
  }
}).catch(function(err) {
  console.error("Flutter loader load error:", err);
});
