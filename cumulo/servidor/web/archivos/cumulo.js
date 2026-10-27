// Cúmulo: reemplaza "ThingsBoard" por "Cúmulo Monitoreo" en el título de la
// pestaña del navegador. ThingsBoard lo cambia en cada página, así que se
// vigila el elemento <title>.
(function () {
  var NOMBRE = 'Cúmulo Monitoreo';
  function arreglar() {
    if (document.title.indexOf('ThingsBoard') >= 0) {
      document.title = document.title.replace(/ThingsBoard/g, NOMBRE);
    }
  }
  function vigilar() {
    var titulo = document.querySelector('title');
    if (!titulo) { titulo = document.createElement('title'); document.head.appendChild(titulo); }
    new MutationObserver(arreglar).observe(titulo, { childList: true, characterData: true, subtree: true });
    arreglar();
  }
  if (document.head) { vigilar(); } else { document.addEventListener('DOMContentLoaded', vigilar); }
})();
