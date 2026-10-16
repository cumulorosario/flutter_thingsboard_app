// Cúmulo: accesos desde la app Flutter a las funciones nativas de alarmas
// (ajustes y permisos, compartir una alarma, silenciarla en este teléfono).
// La parte nativa está en cumulo/android/kotlin/PuenteCumuloActivity.kt.
import 'package:flutter/material.dart';
import 'package:thingsboard_app/modules/main/main_navigation_item.dart';
import 'package:thingsboard_app/modules/more/more_menu_item_widget.dart';
import 'package:thingsboard_app/thingsboard_client.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> _abrir(String accion, [Map<String, String>? datos]) async {
  final uri = Uri(scheme: 'cumulo-alarmas', host: accion, queryParameters: datos);
  try {
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  } catch (_) {}
}

/// Ítem "Alarmas y notificaciones" en la pantalla "Más".
Widget cumuloMenuAlarmas(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.only(top: 16),
    child: MoreMenuItemWidget(
      const TbMainNavigationItem(
        title: 'Alarmas y notificaciones',
        icon: Icons.notifications_active_outlined,
        page: SizedBox.shrink(),
        path: '',
      ),
      onTap: () => _abrir('ajustes'),
    ),
  );
}

/// Botones "Compartir" y "Silenciar en este teléfono" en el detalle de una alarma.
List<Widget> cumuloAccionesAlarma(BuildContext context, AlarmInfo alarma) {
  final equipo = alarma.originatorName ?? 'Equipo';
  final tipo = alarma.type;
  return [
    IconButton(
      tooltip: 'Compartir alarma',
      icon: const Icon(Icons.share_outlined),
      onPressed: () => _abrir('compartir', {
        'dispositivo': equipo,
        'tipo': tipo,
        'severidad': alarma.severity.name,
        'estado': _estado(alarma),
        'fecha': '${alarma.startTs ?? alarma.createdTime ?? ''}',
      }),
    ),
    IconButton(
      tooltip: 'Silenciar en este teléfono',
      icon: const Icon(Icons.notifications_off_outlined),
      onPressed: () async {
        final confirmar = await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Silenciar en este teléfono'),
            content: Text(
              'No vas a recibir más alarmas críticas "$tipo" de $equipo en este teléfono.\n\n'
              'Podés reactivarla desde Más → Alarmas y notificaciones.',
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancelar')),
              TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Silenciar')),
            ],
          ),
        );
        if (confirmar == true) {
          await _abrir('silenciar', {'dispositivo': equipo, 'tipo': tipo});
        }
      },
    ),
  ];
}

String _estado(AlarmInfo alarma) {
  switch (alarma.status?.name) {
    case 'ACTIVE_UNACK':
      return 'Activa, sin reconocer';
    case 'ACTIVE_ACK':
      return 'Activa, reconocida';
    case 'CLEARED_UNACK':
      return 'Resuelta, sin reconocer';
    case 'CLEARED_ACK':
      return 'Resuelta y reconocida';
    default:
      return '';
  }
}
