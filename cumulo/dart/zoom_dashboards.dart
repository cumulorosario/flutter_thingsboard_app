// Cúmulo: zoom con dos dedos y paneo en los dashboards.
//
// La web de ThingsBoard bloquea el zoom con su etiqueta <meta name="viewport">.
// Este script la reemplaza por una que lo permite (hasta 5x) y la vuelve a
// corregir si la web la regenera al navegar entre dashboards.
import 'dart:collection';

import 'package:flutter_inappwebview/flutter_inappwebview.dart';

const _viewportConZoom =
    'width=device-width, initial-scale=1, minimum-scale=1, maximum-scale=5, user-scalable=yes';

final cumuloScriptsZoom = UnmodifiableListView<UserScript>([
  UserScript(
    injectionTime: UserScriptInjectionTime.AT_DOCUMENT_END,
    source: '''
(function () {
  var deseado = '$_viewportConZoom';
  function corregir() {
    var m = document.querySelector('meta[name="viewport"]');
    if (!m) {
      m = document.createElement('meta');
      m.name = 'viewport';
      document.head.appendChild(m);
    }
    if (m.getAttribute('content') !== deseado) m.setAttribute('content', deseado);
  }
  corregir();
  new MutationObserver(corregir).observe(document.head, {
    childList: true, subtree: true, attributes: true, attributeFilter: ['content']
  });
})();
''',
  ),
]);
