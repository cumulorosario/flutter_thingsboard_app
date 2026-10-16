package org.thingsboard.app.cumulo

import android.content.Context
import android.content.Intent
import java.text.SimpleDateFormat
import java.util.Date
import java.util.Locale

/** Arma el texto de una alarma y abre el menú de Android para compartirla (WhatsApp, correo, etc.). */
object Compartir {
    fun textoAlarma(dispositivo: String, tipo: String, severidad: String, estado: String?, fechaMs: Long?): String {
        val fecha = SimpleDateFormat("dd/MM/yyyy HH:mm", Locale("es", "AR"))
            .format(Date(fechaMs ?: System.currentTimeMillis()))
        return buildString {
            appendLine("⚠ ALARMA ${AlarmaCritica.traducirSeveridad(severidad)}")
            appendLine("━━━━━━━━━━━━━━━━━━")
            appendLine("Equipo: $dispositivo")
            appendLine("Tipo: $tipo")
            if (!estado.isNullOrBlank()) appendLine("Estado: $estado")
            appendLine("Fecha: $fecha")
            appendLine("━━━━━━━━━━━━━━━━━━")
            appendLine("Cúmulo Monitoreo — Cúmulo Ingeniería")
            append("https://monitoreo.cumuloingenieria.com.ar")
        }
    }

    fun abrir(ctx: Context, asunto: String, texto: String) {
        val envio = Intent(Intent.ACTION_SEND).apply {
            type = "text/plain"
            putExtra(Intent.EXTRA_SUBJECT, asunto)
            putExtra(Intent.EXTRA_TEXT, texto)
        }
        val selector = Intent.createChooser(envio, "Compartir alarma").addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
        ctx.startActivity(selector)
    }
}
