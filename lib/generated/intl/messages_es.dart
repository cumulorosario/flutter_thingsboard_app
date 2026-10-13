// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a es locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'es';

  static String m0(appTitle) =>
      "¡Felicitaciones!\nTu cuenta de ${appTitle} fue activada.\nYa podés iniciar sesión en ${appTitle}.";

  static String m1(count) =>
      "${Intl.plural(count, one: 'Alarma', other: 'Alarmas')}";

  static String m2(deviceName) =>
      "No se pudo conectar con el dispositivo ${deviceName}. Volvé a intentar";

  static String m3(link) =>
      "No se puede abrir el enlace: ${link}";

  static String m4(wifiName) =>
      "Conectate a un Wi-Fi parecido a ${wifiName}";

  static String m5(name) =>
      "Falló la conexión a la red Wi-Fi ${name}.\nAsegurate de que el teléfono esté conectado a la red Wi-Fi del dispositivo y de que esta app tenga habilitado el acceso a la red local en la configuración del teléfono.";

  static String m6(count) =>
      "${Intl.plural(count, one: 'Panel', other: 'Paneles')}";

  static String m7(count) =>
      "${Intl.plural(count, one: 'Dispositivo', other: 'Dispositivos')}";

  static String m8(contact) =>
      "Se envió un código de seguridad a tu email ${contact}.";

  static String m9(count) =>
      "${Intl.plural(count, one: 'Notificación', other: 'Notificaciones')}";

  static String m10(permissions) =>
      "No tenés permisos suficientes para \"${permissions}\". Abrí la configuración de la app, otorgá los permisos y tocá \"Reintentar\".";

  static String m11(permissions) =>
      "No tenés permisos suficientes para \"${permissions}\". Otorgá los permisos necesarios y tocá \"Reintentar\".";

  static String m12(deviceName) =>
      "Ingresá el PIN de ${deviceName} para confirmar que lo tenés";

  static String m13(time) =>
      "Reenviar código en ${Intl.plural(time, one: '1 segundo', other: '${time} segundos')}";

  static String m14(name) =>
      "Ruta no definida: ${name}";

  static String m15(count) =>
      "${Intl.plural(count, one: 'Buscar usuario', other: 'Buscar usuarios')}";

  static String m16(contact) =>
      "Se envió un código de seguridad a tu teléfono ${contact}.";

  static String m17(name) =>
      "No se pudo conectar al Wi-Fi porque el dispositivo ${name} no encontró redes";

  static String m18(version) =>
      "Actualizar a ${version}";

  static String m19(deviceName) =>
      "Para seguir configurando el dispositivo ${deviceName}, ingresá los datos de tu red.";

  static String m20(network) =>
      "Ingresá la contraseña de ${network}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "accept": MessageLookupByLibrary.simpleMessage("Aceptar"),
    "acceptPrivacyPolicyMessage": MessageLookupByLibrary.simpleMessage("Tenés que aceptar la Política de privacidad"),
    "acceptTermsOfUseMessage": MessageLookupByLibrary.simpleMessage("Tenés que aceptar los Términos de uso"),
    "accountActivated": MessageLookupByLibrary.simpleMessage("¡Cuenta activada correctamente!"),
    "accountActivatedText": m0,
    "acknowledge": MessageLookupByLibrary.simpleMessage("Reconocer"),
    "acknowledged": MessageLookupByLibrary.simpleMessage("Reconocida"),
    "actionData": MessageLookupByLibrary.simpleMessage("Datos de la acción"),
    "actionStatusFailure": MessageLookupByLibrary.simpleMessage("Error"),
    "actionStatusSuccess": MessageLookupByLibrary.simpleMessage("Correcto"),
    "actionTypeActivated": MessageLookupByLibrary.simpleMessage("Activado"),
    "actionTypeAdded": MessageLookupByLibrary.simpleMessage("Agregado"),
    "actionTypeAddedComment": MessageLookupByLibrary.simpleMessage("Comentario agregado"),
    "actionTypeAlarmAck": MessageLookupByLibrary.simpleMessage("Reconocida"),
    "actionTypeAlarmAssigned": MessageLookupByLibrary.simpleMessage("Alarma asignada"),
    "actionTypeAlarmClear": MessageLookupByLibrary.simpleMessage("Resuelta"),
    "actionTypeAlarmDelete": MessageLookupByLibrary.simpleMessage("Alarma eliminada"),
    "actionTypeAlarmUnassigned": MessageLookupByLibrary.simpleMessage("Alarma desasignada"),
    "actionTypeAssignedFromTenant": MessageLookupByLibrary.simpleMessage("Asignado desde la empresa"),
    "actionTypeAssignedToCustomer": MessageLookupByLibrary.simpleMessage("Asignado al cliente"),
    "actionTypeAssignedToEdge": MessageLookupByLibrary.simpleMessage("Asignado a Edge"),
    "actionTypeAssignedToTenant": MessageLookupByLibrary.simpleMessage("Asignado a la empresa"),
    "actionTypeAttributesDeleted": MessageLookupByLibrary.simpleMessage("Atributos eliminados"),
    "actionTypeAttributesRead": MessageLookupByLibrary.simpleMessage("Atributos leídos"),
    "actionTypeAttributesUpdated": MessageLookupByLibrary.simpleMessage("Atributos actualizados"),
    "actionTypeCredentialsRead": MessageLookupByLibrary.simpleMessage("Credenciales leídas"),
    "actionTypeCredentialsUpdated": MessageLookupByLibrary.simpleMessage("Credenciales actualizadas"),
    "actionTypeDeleted": MessageLookupByLibrary.simpleMessage("Eliminado"),
    "actionTypeDeletedComment": MessageLookupByLibrary.simpleMessage("Comentario eliminado"),
    "actionTypeLockout": MessageLookupByLibrary.simpleMessage("Bloqueo"),
    "actionTypeLogin": MessageLookupByLibrary.simpleMessage("Inicio de sesión"),
    "actionTypeLogout": MessageLookupByLibrary.simpleMessage("Cierre de sesión"),
    "actionTypeProvisionFailure": MessageLookupByLibrary.simpleMessage("Falló la configuración del dispositivo"),
    "actionTypeProvisionSuccess": MessageLookupByLibrary.simpleMessage("Dispositivo configurado"),
    "actionTypeRelationAddOrUpdate": MessageLookupByLibrary.simpleMessage("Relación actualizada"),
    "actionTypeRelationDeleted": MessageLookupByLibrary.simpleMessage("Relación eliminada"),
    "actionTypeRelationsDeleted": MessageLookupByLibrary.simpleMessage("Todas las relaciones eliminadas"),
    "actionTypeRpcCall": MessageLookupByLibrary.simpleMessage("Llamada RPC"),
    "actionTypeSmsSent": MessageLookupByLibrary.simpleMessage("SMS enviado"),
    "actionTypeSuspended": MessageLookupByLibrary.simpleMessage("Suspendido"),
    "actionTypeTimeseriesDeleted": MessageLookupByLibrary.simpleMessage("Telemetría eliminada"),
    "actionTypeTimeseriesUpdated": MessageLookupByLibrary.simpleMessage("Telemetría actualizada"),
    "actionTypeUnassignedFromCustomer": MessageLookupByLibrary.simpleMessage("Desasignado del cliente"),
    "actionTypeUnassignedFromEdge": MessageLookupByLibrary.simpleMessage("Desasignado de Edge"),
    "actionTypeUpdated": MessageLookupByLibrary.simpleMessage("Actualizado"),
    "actionTypeUpdatedComment": MessageLookupByLibrary.simpleMessage("Comentario actualizado"),
    "activatingAccount": MessageLookupByLibrary.simpleMessage("Activando la cuenta..."),
    "activatingAccountText": MessageLookupByLibrary.simpleMessage("Tu cuenta se está activando.\nEsperá un momento..."),
    "active": MessageLookupByLibrary.simpleMessage("Activo"),
    "activity": MessageLookupByLibrary.simpleMessage("Actividad"),
    "addCommentMessage": MessageLookupByLibrary.simpleMessage("Agregá un comentario..."),
    "address": MessageLookupByLibrary.simpleMessage("Dirección"),
    "address2": MessageLookupByLibrary.simpleMessage("Dirección 2"),
    "alarmAcknowledgeText": MessageLookupByLibrary.simpleMessage("¿Seguro que querés reconocer la alarma?"),
    "alarmAcknowledgeTitle": MessageLookupByLibrary.simpleMessage("Reconocer alarma"),
    "alarmClearText": MessageLookupByLibrary.simpleMessage("¿Seguro que querés resolver la alarma?"),
    "alarmClearTitle": MessageLookupByLibrary.simpleMessage("Resolver alarma"),
    "alarmSeverityList": MessageLookupByLibrary.simpleMessage("Severidades de alarma"),
    "alarmStatusList": MessageLookupByLibrary.simpleMessage("Estados de alarma"),
    "alarmTypeList": MessageLookupByLibrary.simpleMessage("Tipos de alarma"),
    "alarmTypes": MessageLookupByLibrary.simpleMessage("Tipos de alarma"),
    "alarms": m1,
    "all": MessageLookupByLibrary.simpleMessage("Todas"),
    "allDevices": MessageLookupByLibrary.simpleMessage("Todos los dispositivos"),
    "allowAccess": MessageLookupByLibrary.simpleMessage("Permitir acceso"),
    "alreadyHaveAnAccount": MessageLookupByLibrary.simpleMessage("¿Ya tenés una cuenta?"),
    "anEmptyRequestDataReceived": MessageLookupByLibrary.simpleMessage("Se recibió una solicitud sin datos."),
    "anyType": MessageLookupByLibrary.simpleMessage("Cualquier tipo"),
    "apiUsageState": MessageLookupByLibrary.simpleMessage("Uso de la API"),
    "appTitle": MessageLookupByLibrary.simpleMessage("Cúmulo Monitoreo"),
    "areYouSure": MessageLookupByLibrary.simpleMessage("¿Estás seguro?"),
    "asset": MessageLookupByLibrary.simpleMessage("Activo"),
    "assetName": MessageLookupByLibrary.simpleMessage("Nombre del activo"),
    "assetProfile": MessageLookupByLibrary.simpleMessage("Perfil de activo"),
    "assets": MessageLookupByLibrary.simpleMessage("Activos"),
    "assignedToCustomer": MessageLookupByLibrary.simpleMessage("Asignado al cliente"),
    "assignedToMe": MessageLookupByLibrary.simpleMessage("Asignadas a mí"),
    "assignee": MessageLookupByLibrary.simpleMessage("Responsable"),
    "auditLogDetails": MessageLookupByLibrary.simpleMessage("Detalle del registro de auditoría"),
    "auditLogs": MessageLookupByLibrary.simpleMessage("Registros de auditoría"),
    "backupCodeAuthDescription": MessageLookupByLibrary.simpleMessage("Ingresá uno de tus códigos de respaldo."),
    "backupCodeAuthPlaceholder": MessageLookupByLibrary.simpleMessage("Código de respaldo"),
    "bleHelpMessage": MessageLookupByLibrary.simpleMessage("Para configurar tu nuevo dispositivo, asegurate de que el Bluetooth del teléfono esté activado y de estar cerca del dispositivo"),
    "cancel": MessageLookupByLibrary.simpleMessage("Cancelar"),
    "cannotEstablishSession": m2,
    "cantLaunchUrlLink": m3,
    "changePassword": MessageLookupByLibrary.simpleMessage("Cambiar contraseña"),
    "chooseRegion": MessageLookupByLibrary.simpleMessage("Elegir región"),
    "city": MessageLookupByLibrary.simpleMessage("Ciudad"),
    "claimingDevice": MessageLookupByLibrary.simpleMessage("Vinculando dispositivo"),
    "claimingDeviceDone": MessageLookupByLibrary.simpleMessage("Dispositivo vinculado"),
    "claimingMessageSuccess": MessageLookupByLibrary.simpleMessage("El dispositivo se\nvinculó correctamente"),
    "clear": MessageLookupByLibrary.simpleMessage("Resolver"),
    "cleared": MessageLookupByLibrary.simpleMessage("Resuelta"),
    "close": MessageLookupByLibrary.simpleMessage("Cerrar"),
    "codeVerificationFailed": MessageLookupByLibrary.simpleMessage("¡Falló la verificación del código!"),
    "confirmNotRobotMessage": MessageLookupByLibrary.simpleMessage("Tenés que confirmar que no sos un robot"),
    "confirmation": MessageLookupByLibrary.simpleMessage("Confirmación"),
    "confirmingWifiConnection": MessageLookupByLibrary.simpleMessage("Confirmando la conexión Wi-Fi"),
    "connectToDevice": MessageLookupByLibrary.simpleMessage("Conectar con el dispositivo"),
    "connectToTheWifiYouUsuallyUse": MessageLookupByLibrary.simpleMessage("Conectate al Wi-Fi que usás normalmente"),
    "connectToWifiSimilarToWifiname": m4,
    "connectingToDevice": MessageLookupByLibrary.simpleMessage("Conectando con el dispositivo"),
    "connectionError": MessageLookupByLibrary.simpleMessage("Error de conexión"),
    "connectionToTheWifiNetworkFailednpleaseEnsureThatYour": m5,
    "continueText": MessageLookupByLibrary.simpleMessage("Continuar"),
    "country": MessageLookupByLibrary.simpleMessage("País"),
    "createAccount": MessageLookupByLibrary.simpleMessage("Crear cuenta"),
    "createPassword": MessageLookupByLibrary.simpleMessage("Creá una contraseña"),
    "critical": MessageLookupByLibrary.simpleMessage("Crítica"),
    "currentPassword": MessageLookupByLibrary.simpleMessage("Contraseña actual"),
    "currentPasswordRequireText": MessageLookupByLibrary.simpleMessage("La contraseña actual es obligatoria."),
    "customer": MessageLookupByLibrary.simpleMessage("Cliente"),
    "customers": MessageLookupByLibrary.simpleMessage("Clientes"),
    "dashboards": m6,
    "days": MessageLookupByLibrary.simpleMessage("días"),
    "delete": MessageLookupByLibrary.simpleMessage("Eliminar"),
    "deleteComment": MessageLookupByLibrary.simpleMessage("Eliminar comentario"),
    "details": MessageLookupByLibrary.simpleMessage("Detalles"),
    "deviceList": MessageLookupByLibrary.simpleMessage("Lista de dispositivos"),
    "deviceNotAbleToFindWifiNearby": MessageLookupByLibrary.simpleMessage("El dispositivo no encuentra redes Wi-Fi cercanas"),
    "deviceNotFoundMessage": MessageLookupByLibrary.simpleMessage("No se encontraron dispositivos. Asegurate de que el Bluetooth del teléfono esté activado y de estar cerca del dispositivo."),
    "deviceProfile": MessageLookupByLibrary.simpleMessage("Perfil de dispositivo"),
    "deviceProvisioning": MessageLookupByLibrary.simpleMessage("Configuración del dispositivo"),
    "devices": m7,
    "duration": MessageLookupByLibrary.simpleMessage("Duración"),
    "edge": MessageLookupByLibrary.simpleMessage("Edge"),
    "edit": MessageLookupByLibrary.simpleMessage("Editar"),
    "edited": MessageLookupByLibrary.simpleMessage("Editado"),
    "email": MessageLookupByLibrary.simpleMessage("Email"),
    "emailAuthDescription": m8,
    "emailAuthPlaceholder": MessageLookupByLibrary.simpleMessage("Código de email"),
    "emailInvalidText": MessageLookupByLibrary.simpleMessage("Formato de email inválido."),
    "emailRequireText": MessageLookupByLibrary.simpleMessage("El email es obligatorio."),
    "emailVerification": MessageLookupByLibrary.simpleMessage("Verificación de email"),
    "emailVerificationInstructionsText": MessageLookupByLibrary.simpleMessage("Seguí las instrucciones del email para completar el registro. Nota: si no ves el email después de un rato, revisá la carpeta de spam o tocá 'Reenviar' para que te lo enviemos de nuevo."),
    "emailVerificationSentText": MessageLookupByLibrary.simpleMessage("Se envió un email con los datos de verificación a la dirección indicada "),
    "emailVerified": MessageLookupByLibrary.simpleMessage("Email verificado"),
    "entityType": MessageLookupByLibrary.simpleMessage("Tipo de entidad"),
    "entityView": MessageLookupByLibrary.simpleMessage("Vista de entidad"),
    "europe": MessageLookupByLibrary.simpleMessage("Europa"),
    "europeRegionShort": MessageLookupByLibrary.simpleMessage("Fráncfort"),
    "exitDeviceProvisioning": MessageLookupByLibrary.simpleMessage("Salir de la configuración del dispositivo"),
    "failedToConnectToServer": MessageLookupByLibrary.simpleMessage("No se pudo conectar con el servidor"),
    "failedToLoadAlarmDetails": MessageLookupByLibrary.simpleMessage("No se pudo cargar el detalle de la alarma"),
    "failedToLoadTheList": MessageLookupByLibrary.simpleMessage("No se pudo cargar la lista"),
    "failureDetails": MessageLookupByLibrary.simpleMessage("Detalle del error"),
    "fatalApplicationErrorOccurred": MessageLookupByLibrary.simpleMessage("Ocurrió un error grave en la aplicación:"),
    "fatalError": MessageLookupByLibrary.simpleMessage("Error grave"),
    "filters": MessageLookupByLibrary.simpleMessage("Filtros"),
    "firebaseIsNotConfiguredPleaseReferToTheOfficialFirebase": MessageLookupByLibrary.simpleMessage("Firebase no está configurado.\nConsultá la documentación oficial de Firebase\npara saber cómo hacerlo."),
    "firstName": MessageLookupByLibrary.simpleMessage("Nombre"),
    "firstNameRequireText": MessageLookupByLibrary.simpleMessage("El nombre es obligatorio."),
    "firstNameUpper": MessageLookupByLibrary.simpleMessage("Nombre"),
    "home": MessageLookupByLibrary.simpleMessage("Inicio"),
    "hours": MessageLookupByLibrary.simpleMessage("horas"),
    "imNotARobot": MessageLookupByLibrary.simpleMessage("No soy un robot"),
    "inactive": MessageLookupByLibrary.simpleMessage("Inactivo"),
    "inactiveUserAlreadyExists": MessageLookupByLibrary.simpleMessage("Ya existe un usuario inactivo"),
    "inactiveUserAlreadyExistsMessage": MessageLookupByLibrary.simpleMessage("Ya hay un usuario registrado con un email sin verificar.\nTocá 'Reenviar' si querés recibir de nuevo el email de verificación."),
    "indeterminate": MessageLookupByLibrary.simpleMessage("Indeterminada"),
    "invalidPasswordLengthMessage": MessageLookupByLibrary.simpleMessage("La contraseña debe tener al menos 6 caracteres"),
    "isRequiredText": MessageLookupByLibrary.simpleMessage("es obligatorio."),
    "label": MessageLookupByLibrary.simpleMessage("Etiqueta"),
    "lastName": MessageLookupByLibrary.simpleMessage("Apellido"),
    "lastNameRequireText": MessageLookupByLibrary.simpleMessage("El apellido es obligatorio."),
    "lastNameUpper": MessageLookupByLibrary.simpleMessage("Apellido"),
    "listIsEmptyText": MessageLookupByLibrary.simpleMessage("La lista está vacía."),
    "login": MessageLookupByLibrary.simpleMessage("Iniciar sesión"),
    "loginNotification": MessageLookupByLibrary.simpleMessage("Ingresá a tu cuenta"),
    "loginWith": MessageLookupByLibrary.simpleMessage("Iniciar sesión con"),
    "logoDefaultValue": MessageLookupByLibrary.simpleMessage("Logo Cúmulo Ingeniería"),
    "logout": MessageLookupByLibrary.simpleMessage("Cerrar sesión"),
    "major": MessageLookupByLibrary.simpleMessage("Mayor"),
    "markAllAsRead": MessageLookupByLibrary.simpleMessage("Marcar todas como leídas"),
    "markAsRead": MessageLookupByLibrary.simpleMessage("Marcar como leída"),
    "mfaProviderBackupCode": MessageLookupByLibrary.simpleMessage("Código de respaldo"),
    "mfaProviderEmail": MessageLookupByLibrary.simpleMessage("Email"),
    "mfaProviderSms": MessageLookupByLibrary.simpleMessage("SMS"),
    "mfaProviderTopt": MessageLookupByLibrary.simpleMessage("App de autenticación"),
    "minor": MessageLookupByLibrary.simpleMessage("Menor"),
    "minutes": MessageLookupByLibrary.simpleMessage("minutos"),
    "mobileDashboardShouldBeConfiguredInDeviceProfile": MessageLookupByLibrary.simpleMessage("¡Hay que configurar el panel móvil en el perfil del dispositivo!"),
    "more": MessageLookupByLibrary.simpleMessage("Más"),
    "newPassword": MessageLookupByLibrary.simpleMessage("Nueva contraseña"),
    "newPassword2": MessageLookupByLibrary.simpleMessage("Confirmar nueva contraseña"),
    "newPassword2RequireText": MessageLookupByLibrary.simpleMessage("Repetir la nueva contraseña es obligatorio."),
    "newPasswordRequireText": MessageLookupByLibrary.simpleMessage("La nueva contraseña es obligatoria."),
    "newUserText": MessageLookupByLibrary.simpleMessage("¿Usuario nuevo?"),
    "next": MessageLookupByLibrary.simpleMessage("Siguiente"),
    "no": MessageLookupByLibrary.simpleMessage("No"),
    "noAlarmsFound": MessageLookupByLibrary.simpleMessage("No hay alarmas"),
    "noDashboardsFound": MessageLookupByLibrary.simpleMessage("No hay paneles"),
    "noNotificationsFound": MessageLookupByLibrary.simpleMessage("No hay notificaciones"),
    "noResultsFound": MessageLookupByLibrary.simpleMessage("No se encontraron resultados"),
    "northAmerica": MessageLookupByLibrary.simpleMessage("América del Norte"),
    "northAmericaRegionShort": MessageLookupByLibrary.simpleMessage("N. Virginia"),
    "notFound": MessageLookupByLibrary.simpleMessage("No encontrado"),
    "notImplemented": MessageLookupByLibrary.simpleMessage("¡No implementado!"),
    "notificationRequest": MessageLookupByLibrary.simpleMessage("Solicitud de notificación"),
    "notificationRule": MessageLookupByLibrary.simpleMessage("Regla de notificación"),
    "notificationTarget": MessageLookupByLibrary.simpleMessage("Destinatario de notificación"),
    "notificationTemplate": MessageLookupByLibrary.simpleMessage("Plantilla de notificación"),
    "notifications": m9,
    "openAppSettings": MessageLookupByLibrary.simpleMessage("Abrir configuración de la app"),
    "openAppSettingsToGrantPermissionMessage": m10,
    "openSettingsAndGrantAccessToCameraToContinue": MessageLookupByLibrary.simpleMessage("Abrí la configuración y permití el acceso a la cámara para continuar"),
    "openWifiSettings": MessageLookupByLibrary.simpleMessage("Abrir configuración de Wi-Fi"),
    "or": MessageLookupByLibrary.simpleMessage("O"),
    "originator": MessageLookupByLibrary.simpleMessage("Origen"),
    "otaPackage": MessageLookupByLibrary.simpleMessage("Paquete OTA"),
    "password": MessageLookupByLibrary.simpleMessage("Contraseña"),
    "passwordErrorNotification": MessageLookupByLibrary.simpleMessage("¡Las contraseñas ingresadas deben coincidir!"),
    "passwordForgotText": MessageLookupByLibrary.simpleMessage("¿Olvidaste tu contraseña?"),
    "passwordRequireText": MessageLookupByLibrary.simpleMessage("La contraseña es obligatoria."),
    "passwordReset": MessageLookupByLibrary.simpleMessage("Restablecer contraseña"),
    "passwordResetLinkSuccessfullySentNotification": MessageLookupByLibrary.simpleMessage("¡El enlace para restablecer la contraseña se envió correctamente!"),
    "passwordResetText": MessageLookupByLibrary.simpleMessage("Ingresá el email asociado a tu cuenta y te enviaremos un enlace para restablecer la contraseña"),
    "passwordSuccessNotification": MessageLookupByLibrary.simpleMessage("Contraseña cambiada correctamente"),
    "permissions": MessageLookupByLibrary.simpleMessage("Permisos"),
    "permissionsNotEnoughMessage": m11,
    "phone": MessageLookupByLibrary.simpleMessage("Teléfono"),
    "pleaseFollowTheNextStepsToConnectYourPhoneTo": MessageLookupByLibrary.simpleMessage("Seguí estos pasos para conectar tu teléfono al dispositivo"),
    "pleaseFollowTheNextStepsToReconnectnyourPhoneToYour": MessageLookupByLibrary.simpleMessage("Seguí estos pasos para volver a conectar\ntu teléfono a tu Wi-Fi habitual"),
    "pleaseScanQrCodeOnYourDevice": MessageLookupByLibrary.simpleMessage("Escaneá el código QR de tu dispositivo"),
    "plusAlarmType": MessageLookupByLibrary.simpleMessage("+ Tipo de alarma"),
    "popTitle": m12,
    "postalCode": MessageLookupByLibrary.simpleMessage("Código postal"),
    "privacyPolicy": MessageLookupByLibrary.simpleMessage("Política de privacidad"),
    "profile": MessageLookupByLibrary.simpleMessage("Perfil"),
    "profileSuccessNotification": MessageLookupByLibrary.simpleMessage("Perfil actualizado correctamente"),
    "provisionedSuccessfully": MessageLookupByLibrary.simpleMessage("El dispositivo se configuró correctamente"),
    "pushNotificationsAreNotConfiguredpleaseContactYourSystemAdministrator": MessageLookupByLibrary.simpleMessage("Las notificaciones push no están configuradas.\nContactá al administrador del sistema."),
    "queue": MessageLookupByLibrary.simpleMessage("Cola"),
    "ready": MessageLookupByLibrary.simpleMessage("Listo"),
    "refresh": MessageLookupByLibrary.simpleMessage("Actualizar"),
    "repeatPassword": MessageLookupByLibrary.simpleMessage("Repetí la contraseña"),
    "requestPasswordReset": MessageLookupByLibrary.simpleMessage("Solicitar restablecimiento"),
    "requestedEntityDoesNotExists": MessageLookupByLibrary.simpleMessage("El elemento solicitado no existe."),
    "resend": MessageLookupByLibrary.simpleMessage("Reenviar"),
    "resendCode": MessageLookupByLibrary.simpleMessage("Reenviar código"),
    "resendCodeWait": m13,
    "reset": MessageLookupByLibrary.simpleMessage("Restablecer"),
    "retry": MessageLookupByLibrary.simpleMessage("Reintentar"),
    "returnToDashboard": MessageLookupByLibrary.simpleMessage("Volver al panel"),
    "returnToTheAppAndTapReadyButton": MessageLookupByLibrary.simpleMessage("Volvé a la app y tocá Listo"),
    "routeNotDefined": m14,
    "rpc": MessageLookupByLibrary.simpleMessage("RPC"),
    "ruleChain": MessageLookupByLibrary.simpleMessage("Cadena de reglas"),
    "ruleNode": MessageLookupByLibrary.simpleMessage("Nodo de regla"),
    "scanACode": MessageLookupByLibrary.simpleMessage("Escanear un código"),
    "scanQrCode": MessageLookupByLibrary.simpleMessage("Escanear código QR"),
    "search": MessageLookupByLibrary.simpleMessage("Buscar"),
    "searchResults": MessageLookupByLibrary.simpleMessage("Resultados de búsqueda"),
    "searchUsers": m15,
    "seconds": MessageLookupByLibrary.simpleMessage("segundos"),
    "selectRegion": MessageLookupByLibrary.simpleMessage("Seleccionar región"),
    "selectUser": MessageLookupByLibrary.simpleMessage("Seleccionar usuarios"),
    "selectWayToVerify": MessageLookupByLibrary.simpleMessage("Elegí cómo verificar"),
    "selectWifiNetwork": MessageLookupByLibrary.simpleMessage("Elegí una red Wi-Fi"),
    "sendingWifiCredentials": MessageLookupByLibrary.simpleMessage("Enviando los datos del Wi-Fi"),
    "severity": MessageLookupByLibrary.simpleMessage("Severidad"),
    "signIn": MessageLookupByLibrary.simpleMessage("Iniciar sesión"),
    "signUp": MessageLookupByLibrary.simpleMessage("Registrarse"),
    "smsAuthDescription": m16,
    "smsAuthPlaceholder": MessageLookupByLibrary.simpleMessage("Código SMS"),
    "somethingWentWrong": MessageLookupByLibrary.simpleMessage("Algo salió mal"),
    "somethingWentWrongRollback": MessageLookupByLibrary.simpleMessage("Algo salió mal... Se revirtieron los cambios"),
    "startTime": MessageLookupByLibrary.simpleMessage("Inicio"),
    "stateOrProvince": MessageLookupByLibrary.simpleMessage("Provincia"),
    "status": MessageLookupByLibrary.simpleMessage("Estado"),
    "systemAdministrator": MessageLookupByLibrary.simpleMessage("Administrador del sistema"),
    "tbResource": MessageLookupByLibrary.simpleMessage("Recurso"),
    "tenant": MessageLookupByLibrary.simpleMessage("Empresa"),
    "tenantAdministrator": MessageLookupByLibrary.simpleMessage("Administrador"),
    "tenantProfile": MessageLookupByLibrary.simpleMessage("Perfil de empresa"),
    "termsOfUse": MessageLookupByLibrary.simpleMessage("Términos de uso"),
    "title": MessageLookupByLibrary.simpleMessage("Título"),
    "toggleCamera": MessageLookupByLibrary.simpleMessage("Cambiar cámara"),
    "toggleFlash": MessageLookupByLibrary.simpleMessage("Encender/apagar flash"),
    "toptAuthPlaceholder": MessageLookupByLibrary.simpleMessage("Código"),
    "totpAuthDescription": MessageLookupByLibrary.simpleMessage("Ingresá el código de seguridad de tu app de autenticación."),
    "tryAgain": MessageLookupByLibrary.simpleMessage("Reintentar"),
    "tryAnotherWay": MessageLookupByLibrary.simpleMessage("Probar de otra forma"),
    "tryRefiningYourQuery": MessageLookupByLibrary.simpleMessage("Probá con otra búsqueda"),
    "tryRefreshing": MessageLookupByLibrary.simpleMessage("Probá actualizar"),
    "type": MessageLookupByLibrary.simpleMessage("Tipo"),
    "unableConnectToDevice": MessageLookupByLibrary.simpleMessage("No se pudo conectar con el dispositivo"),
    "unableConnectToWifiBecauseNetworksWasntFoundByDevice": m17,
    "unableToUseCamera": MessageLookupByLibrary.simpleMessage("No se puede usar la cámara"),
    "unacknowledged": MessageLookupByLibrary.simpleMessage("Sin reconocer"),
    "unassigned": MessageLookupByLibrary.simpleMessage("Sin asignar"),
    "unknownError": MessageLookupByLibrary.simpleMessage("Error desconocido."),
    "unread": MessageLookupByLibrary.simpleMessage("No leídas"),
    "update": MessageLookupByLibrary.simpleMessage("Aplicar"),
    "updateRequired": MessageLookupByLibrary.simpleMessage("Actualización necesaria"),
    "updateTo": m18,
    "url": MessageLookupByLibrary.simpleMessage("URL"),
    "user": MessageLookupByLibrary.simpleMessage("Usuario"),
    "username": MessageLookupByLibrary.simpleMessage("usuario"),
    "users": MessageLookupByLibrary.simpleMessage("Usuarios"),
    "verificationCodeIncorrect": MessageLookupByLibrary.simpleMessage("El código de verificación es incorrecto"),
    "verificationCodeInvalid": MessageLookupByLibrary.simpleMessage("Formato de código de verificación inválido"),
    "verificationCodeManyRequest": MessageLookupByLibrary.simpleMessage("Demasiados intentos de verificación del código"),
    "verifyYourIdentity": MessageLookupByLibrary.simpleMessage("Verificá tu identidad"),
    "viewAll": MessageLookupByLibrary.simpleMessage("Ver todo"),
    "viewDashboard": MessageLookupByLibrary.simpleMessage("Ver panel"),
    "warning": MessageLookupByLibrary.simpleMessage("Advertencia"),
    "widgetType": MessageLookupByLibrary.simpleMessage("Tipo de widget"),
    "widgetsBundle": MessageLookupByLibrary.simpleMessage("Paquete de widgets"),
    "wifiHelpMessage": m19,
    "wifiPassword": MessageLookupByLibrary.simpleMessage("Contraseña del Wi-Fi"),
    "wifiPasswordMessage": m20,
    "yes": MessageLookupByLibrary.simpleMessage("Sí"),
  };
}
