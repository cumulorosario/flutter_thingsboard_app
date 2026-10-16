package org.thingsboard.app.cumulo

import android.app.Activity
import android.content.Intent
import android.os.Bundle
import android.widget.Toast

/**
 * Puente entre la parte Flutter de la app y el código nativo de Cúmulo.
 * Flutter abre direcciones del tipo cumulo-alarmas://... (con url_launcher,
 * que ya trae el proyecto) y esta pantalla invisible hace la acción:
 *
 *   cumulo-alarmas://ajustes                         -> ajustes de alarmas
 *   cumulo-alarmas://compartir?dispositivo=&tipo=&severidad=&estado=&fecha=
 *   cumulo-alarmas://silenciar?dispositivo=&tipo=
 */
class PuenteCumuloActivity : Activity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        val uri = intent?.data
        try {
            when (uri?.host) {
                "ajustes" -> startActivity(Intent(this, AjustesAlarmasActivity::class.java))
                "compartir" -> {
                    val dispositivo = uri.getQueryParameter("dispositivo") ?: "Equipo"
                    val tipo = uri.getQueryParameter("tipo") ?: "Alarma"
                    val severidad = uri.getQueryParameter("severidad") ?: ""
                    val texto = Compartir.textoAlarma(dispositivo, tipo, severidad,
                        uri.getQueryParameter("estado"), uri.getQueryParameter("fecha")?.toLongOrNull())
                    Compartir.abrir(this, "Alarma: $dispositivo — $tipo", texto)
                }
                "silenciar" -> {
                    val dispositivo = uri.getQueryParameter("dispositivo")
                    val tipo = uri.getQueryParameter("tipo")
                    if (!dispositivo.isNullOrBlank() && !tipo.isNullOrBlank()) {
                        AlarmasSilenciadas.silenciar(this, dispositivo, tipo)
                        Toast.makeText(this,
                            "Silenciada: \"$tipo\" de $dispositivo. Podés reactivarla en Alarmas y notificaciones.",
                            Toast.LENGTH_LONG).show()
                    }
                }
            }
        } finally {
            finish()
        }
    }
}
