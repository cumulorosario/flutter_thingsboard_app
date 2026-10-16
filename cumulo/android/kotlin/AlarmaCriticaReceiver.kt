package org.thingsboard.app.cumulo

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent

/**
 * Recibe los mensajes de Firebase en paralelo con el plugin de Flutter
 * (los dos escuchan com.google.android.c2dm.intent.RECEIVE). Solo actúa si
 * el mensaje es una alarma crítica de Cúmulo; el resto lo maneja la app
 * normalmente.
 *
 * Funciona con la app cerrada: Android despierta este receptor para cada
 * mensaje de alta prioridad, sin depender de que Flutter esté corriendo.
 */
class AlarmaCriticaReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        val datos = intent.extras ?: return
        if (!AlarmaCritica.esCritica(datos)) return
        val dispositivo = datos.getString(AlarmaCritica.K_DISPOSITIVO) ?: ""
        val tipo = datos.getString(AlarmaCritica.K_TIPO) ?: ""
        if (AlarmasSilenciadas.estaSilenciada(context, dispositivo, tipo)) {
            android.util.Log.i("CumuloCritica", "Silenciada en este teléfono: $tipo de $dispositivo")
            return
        }
        AlarmaCritica.mostrar(context.applicationContext, datos)
    }
}
