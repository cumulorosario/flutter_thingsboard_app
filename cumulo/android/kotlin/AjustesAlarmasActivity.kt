package org.thingsboard.app.cumulo

import android.app.Activity
import android.app.NotificationManager
import android.content.Intent
import android.graphics.Color
import android.graphics.Typeface
import android.graphics.drawable.GradientDrawable
import android.net.Uri
import android.os.Build
import android.os.Bundle
import android.os.PowerManager
import android.provider.Settings
import android.util.TypedValue
import android.view.Gravity
import android.view.ViewGroup
import android.widget.Button
import android.widget.LinearLayout
import android.widget.ScrollView
import android.widget.TextView

/**
 * "Alarmas y notificaciones": estado de los permisos que necesita la alarma
 * crítica (con acceso directo a cada ajuste de Android), prueba de la alarma
 * y lista de alarmas silenciadas en este teléfono.
 */
class AjustesAlarmasActivity : Activity() {

    private lateinit var contenido: LinearLayout

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        window.statusBarColor = AZUL_OSCURO
        contenido = LinearLayout(this).apply {
            orientation = LinearLayout.VERTICAL
            setPadding(dp(20), dp(24), dp(20), dp(32))
        }
        setContentView(ScrollView(this).apply {
            setBackgroundColor(FONDO)
            addView(contenido)
        })
    }

    override fun onResume() {
        super.onResume()
        dibujar() // al volver de los ajustes de Android, el estado se actualiza
    }

    private fun dp(v: Int) = TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP, v.toFloat(), resources.displayMetrics).toInt()

    private fun texto(t: String, sp: Float, color: Int = AZUL_OSCURO, negrita: Boolean = false) = TextView(this).apply {
        text = t
        setTextSize(TypedValue.COMPLEX_UNIT_SP, sp)
        setTextColor(color)
        if (negrita) typeface = Typeface.DEFAULT_BOLD
    }

    private fun tarjeta() = LinearLayout(this).apply {
        orientation = LinearLayout.VERTICAL
        setPadding(dp(16), dp(14), dp(16), dp(14))
        background = GradientDrawable().apply { cornerRadius = dp(12).toFloat(); setColor(Color.WHITE) }
        layoutParams = LinearLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT)
            .apply { topMargin = dp(10) }
    }

    private fun boton(t: String, principal: Boolean = true, accion: () -> Unit) = Button(this).apply {
        text = t
        isAllCaps = false
        setTextColor(if (principal) Color.WHITE else AZUL)
        typeface = Typeface.DEFAULT_BOLD
        background = GradientDrawable().apply {
            cornerRadius = dp(10).toFloat()
            setColor(if (principal) AZUL else Color.TRANSPARENT)
            if (!principal) setStroke(dp(1), AZUL)
        }
        layoutParams = LinearLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, dp(46)).apply { topMargin = dp(10) }
        setOnClickListener { accion() }
    }

    private fun titulo(t: String) = texto(t, 13f, Color.parseColor("#5B6B80"), true).apply {
        setPadding(0, dp(22), 0, 0)
        letterSpacing = 0.08f
    }

    private fun abrirAjuste(intent: Intent) {
        try {
            startActivity(intent)
        } catch (e: Exception) {
            startActivity(Intent(Settings.ACTION_APPLICATION_DETAILS_SETTINGS, Uri.parse("package:$packageName")))
        }
    }

    private fun filaPermiso(nombre: String, detalle: String, ok: Boolean, intent: Intent) {
        val t = tarjeta()
        val fila = LinearLayout(this).apply { orientation = LinearLayout.HORIZONTAL; gravity = Gravity.CENTER_VERTICAL }
        fila.addView(texto(nombre, 16f, negrita = true), LinearLayout.LayoutParams(0, ViewGroup.LayoutParams.WRAP_CONTENT, 1f))
        fila.addView(texto(if (ok) "✓ Activado" else "✗ Desactivado", 14f, if (ok) VERDE else ROJO, true))
        t.addView(fila)
        t.addView(texto(detalle, 13f, Color.parseColor("#5B6B80")).apply { setPadding(0, dp(4), 0, 0) })
        if (!ok) t.addView(boton("Activar") { abrirAjuste(intent) })
        else t.addView(boton("Ver ajuste", principal = false) { abrirAjuste(intent) })
        contenido.addView(t)
    }

    private fun dibujar() {
        contenido.removeAllViews()
        contenido.addView(texto("Alarmas y notificaciones", 24f, negrita = true))
        contenido.addView(texto("Lo que necesita el teléfono para avisarte de una alarma crítica aunque esté bloqueado.",
            14f, Color.parseColor("#5B6B80")).apply { setPadding(0, dp(6), 0, 0) })

        AlarmaCritica.crearCanal(this)
        val nm = getSystemService(NotificationManager::class.java)
        val pm = getSystemService(PowerManager::class.java)

        contenido.addView(titulo("PERMISOS"))
        filaPermiso("Notificaciones", "Permite que la app muestre avisos.",
            nm.areNotificationsEnabled(),
            Intent(Settings.ACTION_APP_NOTIFICATION_SETTINGS).putExtra(Settings.EXTRA_APP_PACKAGE, packageName))

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val canal = nm.getNotificationChannel(AlarmaCritica.CANAL)
            filaPermiso("Canal \"Alarmas críticas\"", "Sonido de alarma, vibración y aviso en la pantalla de bloqueo.",
                canal != null && canal.importance >= NotificationManager.IMPORTANCE_HIGH,
                Intent(Settings.ACTION_CHANNEL_NOTIFICATION_SETTINGS)
                    .putExtra(Settings.EXTRA_APP_PACKAGE, packageName)
                    .putExtra(Settings.EXTRA_CHANNEL_ID, AlarmaCritica.CANAL))
        }

        if (Build.VERSION.SDK_INT >= 34) {
            filaPermiso("Pantalla completa", "Enciende la pantalla y muestra la alarma sobre el bloqueo.",
                nm.canUseFullScreenIntent(),
                Intent("android.settings.MANAGE_APP_USE_FULL_SCREEN_INTENT", Uri.parse("package:$packageName")))
        }

        filaPermiso("Batería sin restricciones", "Evita que el ahorro de batería demore las alarmas.",
            pm.isIgnoringBatteryOptimizations(packageName),
            Intent(Settings.ACTION_REQUEST_IGNORE_BATTERY_OPTIMIZATIONS, Uri.parse("package:$packageName")))

        contenido.addView(titulo("PRUEBA"))
        val prueba = tarjeta()
        prueba.addView(texto("Muestra una alarma crítica de prueba en este teléfono, sin pasar por el servidor. " +
            "Bloqueá el teléfono antes de 10 segundos para ver cómo se enciende.", 13f, Color.parseColor("#5B6B80")))
        prueba.addView(boton("Probar alarma crítica en 10 segundos") {
            contenido.postDelayed({
                AlarmaCritica.mostrar(applicationContext, Bundle().apply {
                    putString(AlarmaCritica.K_ID, "prueba-local-${System.currentTimeMillis()}")
                    putString(AlarmaCritica.K_DISPOSITIVO, "Equipo de prueba")
                    putString(AlarmaCritica.K_TIPO, "Prueba local de alarma crítica")
                    putString(AlarmaCritica.K_SEVERIDAD, "CRITICAL")
                })
            }, 10_000L)
        })
        contenido.addView(prueba)

        contenido.addView(titulo("ALARMAS SILENCIADAS EN ESTE TELÉFONO"))
        val silenciadas = AlarmasSilenciadas.listar(this)
        if (silenciadas.isEmpty()) {
            contenido.addView(tarjeta().apply {
                addView(texto("No hay alarmas silenciadas. Para silenciar una, abrila en la app o usá el botón " +
                    "\"Silenciar este tipo\" en la pantalla de alarma.", 13f, Color.parseColor("#5B6B80")))
            })
        } else {
            silenciadas.forEach { f ->
                contenido.addView(tarjeta().apply {
                    addView(texto(f.tipo, 16f, negrita = true))
                    addView(texto("Equipo: ${f.dispositivo}", 13f, Color.parseColor("#5B6B80")))
                    addView(boton("Reactivar", principal = false) {
                        AlarmasSilenciadas.reactivar(this@AjustesAlarmasActivity, f)
                        dibujar()
                    })
                })
            }
        }
    }

    companion object {
        private val AZUL = Color.parseColor("#3F6EA6")
        private val AZUL_OSCURO = Color.parseColor("#1E3552")
        private val FONDO = Color.parseColor("#F5F7FA")
        private val VERDE = Color.parseColor("#2E7D32")
        private val ROJO = Color.parseColor("#C62828")
    }
}
