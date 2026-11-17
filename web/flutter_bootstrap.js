{{flutter_js}}
{{flutter_build_config}}

_flutter.loader.load({
  config: {
    canvasKitBaseUrl: "canvaskit/"
  },
  onEntrypointLoaded: async function(engineInitializer) {
    const appRunner = await engineInitializer.initializeEngine();
    await appRunner.runApp();
    
    // Smoothly remove loader once Flutter has started
    const loader = document.getElementById('loader');
    if (loader) {
      loader.style.transition = 'opacity 0.2s ease';
      loader.style.opacity = '0';
      setTimeout(function() {
        if (loader && loader.parentNode) {
          loader.parentNode.removeChild(loader);
        }
      }, 200);
    }
  }
});
