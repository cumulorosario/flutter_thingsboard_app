package org.thingsboard.app.cumulo

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.graphics.Color
import android.media.AudioAttributes
import android.media.RingtoneManager
import android.os.Build
import android.os.Bundle
import android.os.PowerManager
import android.util.Log
import org.json.JSONObject
import java.net.HttpURLConnection
import java.net.URL

/**
 * Alarma crítica de Cúmulo: notificación con sonido de alarma que se repite
 * hasta que alguien la atiende, y pantalla completa sobre el bloqueo.
 *
 * Los mensajes llegan de Firebase como "solo datos" (los manda el servicio
 * cumulo_alertas del servidor) con la clave cumulo_critical = "1".
 */
object AlarmaCritica {
    private const val TAG = "CumuloCritica"
    const val CANAL = "cumulo_alarma_critica"

    // Datos que viajan en el mensaje de Firebase
    const val K_ID = "alarmId"
    const val K_TIPO = "alarmType"
    const val K_SEVERIDAD = "severity"
    const val K_DISPOSITIVO = "deviceName"
    const val K_URL_ACCION = "actionUrl"
    const val K_VENCE = "exp"
    const val K_FIRMA_ACK = "sigAck"
    const val K_FIRMA_CLEAR = "sigClear"

    const val ACCION_ACK = "ack"
    const val ACCION_CLEAR = "clear"

    fun esCritica(datos: Bundle?): Boolean = datos?.getString("cumulo_critical") == "1"

    fun crearCanal(ctx: Context) {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.O) return
        val nm = ctx.getSystemService(NotificationManager::class.java)
        if (nm.getNotificationChannel(CANAL) != null) return
        val sonido = RingtoneManager.getDefaultUri(RingtoneManager.TYPE_ALARM)
            ?: RingtoneManager.getDefaultUri(RingtoneManager.TYPE_RINGTONE)
        val canal = NotificationChannel(CANAL, "Alarmas críticas", NotificationManager.IMPORTANCE_HIGH).apply {
            description = "Alarmas que requieren atención inmediata. Suenan hasta que se reconocen."
            enableVibration(true)
            vibrationPattern = longArrayOf(0, 800, 400, 800, 400, 800)
            enableLights(true)
            lightColor = Color.RED
            lockscreenVisibility = Notification.VISIBILITY_PUBLIC
            setSound(
                sonido,
                AudioAttributes.Builder()
                    .setUsage(AudioAttributes.USAGE_ALARM)
                    .setContentType(AudioAttributes.CONTENT_TYPE_SONIFICATION)
                    .build()
            )
        }
        nm.createNotificationChannel(canal)
    }

    fun idNotificacion(alarmId: String): Int = 7000 + (alarmId.hashCode() and 0x7FFFFFFF) % 1000

    fun mostrar(ctx: Context, datos: Bundle) {
        val alarmId = datos.getString(K_ID) ?: return
        val dispositivo = datos.getString(K_DISPOSITIVO) ?: "Dispositivo"
        val tipo = datos.getString(K_TIPO) ?: "Alarma"
        val severidad = datos.getString(K_SEVERIDAD) ?: "CRITICAL"
        Log.i(TAG, "Alarma crítica $alarmId $severidad $dispositivo")

        crearCanal(ctx)
        despertarPantalla(ctx)

        val idNotif = idNotificacion(alarmId)
        val flags = PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE

        val pantalla = Intent(ctx, AlarmaCriticaActivity::class.java).apply {
            addFlags(Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP or Intent.FLAG_ACTIVITY_SINGLE_TOP)
            putExtras(datos)
        }
        val piPantalla = PendingIntent.getActivity(ctx, idNotif, pantalla, flags)

        fun piAccion(accion: String, n: Int): PendingIntent {
            val i = Intent(ctx, AccionAlarmaReceiver::class.java).apply {
                action = "org.thingsboard.app.cumulo.$accion"
                putExtra("accion", accion)
                putExtras(datos)
            }
            return PendingIntent.getBroadcast(ctx, idNotif * 10 + n, i, flags)
        }

        // API de Android directa (sin androidx) para no depender de librerías extra
        val constructor = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O)
            Notification.Builder(ctx, CANAL)
        else
            @Suppress("DEPRECATION") Notification.Builder(ctx)
                .setPriority(Notification.PRIORITY_MAX)
                .setSound(RingtoneManager.getDefaultUri(RingtoneManager.TYPE_ALARM))
                .setVibrate(longArrayOf(0, 800, 400, 800, 400, 800))
        val notif = constructor
            .setSmallIcon(ctx.applicationInfo.icon)
            .setContentTitle("⚠ ALARMA ${traducirSeveridad(severidad)}: $dispositivo")
            .setContentText(tipo)
            .setStyle(Notification.BigTextStyle().bigText("$tipo\nDispositivo: $dispositivo"))
            .setCategory(Notification.CATEGORY_ALARM)
            .setVisibility(Notification.VISIBILITY_PUBLIC)
            .setColor(Color.parseColor("#C62828"))
            .setOngoing(true)
            .setAutoCancel(false)
            .setFullScreenIntent(piPantalla, true)
            .setContentIntent(piPantalla)
            .addAction(Notification.Action.Builder(null, "Reconocer", piAccion(ACCION_ACK, 1)).build())
            .addAction(Notification.Action.Builder(null, "Resolver", piAccion(ACCION_CLEAR, 2)).build())
            .build()
        // Repite el sonido hasta que la notificación se cancela (reconocer o resolver)
        notif.flags = notif.flags or Notification.FLAG_INSISTENT

        ctx.getSystemService(NotificationManager::class.java).notify(idNotif, notif)
    }

    fun silenciar(ctx: Context, alarmId: String) {
        ctx.getSystemService(NotificationManager::class.java).cancel(idNotificacion(alarmId))
    }

    /**
     * Reconoce o resuelve la alarma en ThingsBoard a través del servidor de
     * Cúmulo, usando la firma que vino en el mensaje (no hace falta sesión).
     * Se llama desde un hilo secundario. Devuelve null si salió bien, o el error.
     */
    fun enviarAccion(datos: Bundle, accion: String): String? {
        val url = datos.getString(K_URL_ACCION) ?: return "Falta la dirección del servidor"
        val firma = datos.getString(if (accion == ACCION_ACK) K_FIRMA_ACK else K_FIRMA_CLEAR)
            ?: return "Falta la firma de la acción"
        val cuerpo = JSONObject()
            .put("alarmId", datos.getString(K_ID))
            .put("accion", accion)
            .put("exp", datos.getString(K_VENCE))
            .put("sig", firma)
            .toString()
        return try {
            val con = URL(url).openConnection() as HttpURLConnection
            con.requestMethod = "POST"
            con.connectTimeout = 10_000
            con.readTimeout = 15_000
            con.doOutput = true
            con.setRequestProperty("Content-Type", "application/json")
            con.outputStream.use { it.write(cuerpo.toByteArray(Charsets.UTF_8)) }
            val codigo = con.responseCode
            con.disconnect()
            if (codigo in 200..299) null else "El servidor respondió $codigo"
        } catch (e: Exception) {
            Log.e(TAG, "Error enviando $accion: ${e.message}")
            "Sin conexión con el servidor"
        }
    }

    fun traducirSeveridad(s: String): String = when (s.uppercase()) {
        "CRITICAL" -> "CRÍTICA"
        "MAJOR" -> "MAYOR"
        "MINOR" -> "MENOR"
        "WARNING" -> "ADVERTENCIA"
        else -> s.uppercase()
    }

    private fun despertarPantalla(ctx: Context) {
        try {
            val pm = ctx.getSystemService(PowerManager::class.java)
            @Suppress("DEPRECATION")
            pm.newWakeLock(
                PowerManager.SCREEN_BRIGHT_WAKE_LOCK or PowerManager.ACQUIRE_CAUSES_WAKEUP,
                "Cumulo:AlarmaCritica"
            ).acquire(10_000L)
        } catch (e: Exception) {
            Log.w(TAG, "No se pudo encender la pantalla: ${e.message}")
        }
    }
}
