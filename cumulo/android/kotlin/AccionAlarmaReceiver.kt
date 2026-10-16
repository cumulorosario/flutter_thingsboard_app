package org.thingsboard.app.cumulo

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.widget.Toast
import android.os.Handler
import android.os.Looper

/** Botones "Reconocer" y "Resolver" de la notificación. */
class AccionAlarmaReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        val datos = intent.extras ?: return
        val alarmId = datos.getString(AlarmaCritica.K_ID) ?: return
        val accion = datos.getString("accion") ?: return
        val ctx = context.applicationContext

        // Silenciar en el acto; la llamada al servidor sigue en segundo plano
        AlarmaCritica.silenciar(ctx, alarmId)

        val pendiente = goAsync()
        Thread {
            val error = AlarmaCritica.enviarAccion(datos, accion)
            val texto = when {
                error != null -> "No se pudo ${if (accion == AlarmaCritica.ACCION_ACK) "reconocer" else "resolver"}: $error"
                accion == AlarmaCritica.ACCION_ACK -> "Alarma reconocida"
                else -> "Alarma resuelta"
            }
            Handler(Looper.getMainLooper()).post {
                Toast.makeText(ctx, texto, Toast.LENGTH_LONG).show()
            }
            pendiente.finish()
        }.start()
    }
}
