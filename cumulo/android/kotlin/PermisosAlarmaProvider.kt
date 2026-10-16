package org.thingsboard.app.cumulo

import android.app.Activity
import android.app.AlertDialog
import android.app.Application
import android.app.NotificationManager
import android.content.ContentProvider
import android.content.ContentValues
import android.content.Context
import android.content.Intent
import android.database.Cursor
import android.net.Uri
import android.os.Build
import android.os.Bundle
import android.os.PowerManager
import android.provider.Settings

/**
 * Se inicia solo al abrir la app (Android crea los ContentProvider antes que
 * cualquier pantalla), así no hay que tocar el código original.
 *
 * Crea el canal de alarmas críticas y, la primera vez que se abre la app,
 * pide los dos permisos que necesita la alarma crítica:
 *   - Notificaciones de pantalla completa (Android 14 o superior)
 *   - Que el ahorro de batería no frene la app
 */
class PermisosAlarmaProvider : ContentProvider() {

    override fun onCreate(): Boolean {
        val app = context?.applicationContext as? Application ?: return true
        AlarmaCritica.crearCanal(app)
        app.registerActivityLifecycleCallbacks(object : Application.ActivityLifecycleCallbacks {
            override fun onActivityResumed(activity: Activity) {
                if (activity is AlarmaCriticaActivity) return
                revisarPermisos(activity)
            }
            override fun onActivityCreated(a: Activity, b: Bundle?) {}
            override fun onActivityStarted(a: Activity) {}
            override fun onActivityPaused(a: Activity) {}
            override fun onActivityStopped(a: Activity) {}
            override fun onActivitySaveInstanceState(a: Activity, b: Bundle) {}
            override fun onActivityDestroyed(a: Activity) {}
        })
        return true
    }

    private var dialogoAbierto = false

    private fun revisarPermisos(activity: Activity) {
        if (dialogoAbierto) return
        val prefs = activity.getSharedPreferences("cumulo_alarmas", Context.MODE_PRIVATE)

        // 1. Pantalla completa (Android 14+ la restringe por defecto)
        if (Build.VERSION.SDK_INT >= 34 && !prefs.getBoolean("pidio_pantalla_completa", false)) {
            val nm = activity.getSystemService(NotificationManager::class.java)
            if (!nm.canUseFullScreenIntent()) {
                prefs.edit().putBoolean("pidio_pantalla_completa", true).apply()
                dialogo(activity,
                    "Alarmas críticas",
                    "Para que las alarmas críticas se muestren en pantalla completa aunque el teléfono esté bloqueado, activá el permiso en la próxima pantalla.",
                    Intent("android.settings.MANAGE_APP_USE_FULL_SCREEN_INTENT",
                        Uri.parse("package:${activity.packageName}")))
                return
            }
        }

        // 2. Ahorro de batería
        if (!prefs.getBoolean("pidio_bateria", false)) {
            val pm = activity.getSystemService(PowerManager::class.java)
            if (!pm.isIgnoringBatteryOptimizations(activity.packageName)) {
                prefs.edit().putBoolean("pidio_bateria", true).apply()
                dialogo(activity,
                    "Alarmas críticas",
                    "Para que las alarmas lleguen al instante aunque no uses la app, permití que funcione sin restricciones de batería.",
                    Intent(Settings.ACTION_REQUEST_IGNORE_BATTERY_OPTIMIZATIONS,
                        Uri.parse("package:${activity.packageName}")))
            }
        }
    }

    private fun dialogo(activity: Activity, titulo: String, mensaje: String, intent: Intent) {
        dialogoAbierto = true
        AlertDialog.Builder(activity)
            .setTitle(titulo)
            .setMessage(mensaje)
            .setPositiveButton("Configurar") { _, _ ->
                try {
                    activity.startActivity(intent)
                } catch (e: Exception) {
                    activity.startActivity(Intent(Settings.ACTION_APPLICATION_DETAILS_SETTINGS,
                        Uri.parse("package:${activity.packageName}")))
                }
            }
            .setNegativeButton("Ahora no", null)
            .setOnDismissListener { dialogoAbierto = false }
            .show()
    }

    override fun query(uri: Uri, p: Array<out String>?, s: String?, a: Array<out String>?, o: String?): Cursor? = null
    override fun getType(uri: Uri): String? = null
    override fun insert(uri: Uri, values: ContentValues?): Uri? = null
    override fun delete(uri: Uri, s: String?, a: Array<out String>?): Int = 0
    override fun update(uri: Uri, v: ContentValues?, s: String?, a: Array<out String>?): Int = 0
}
