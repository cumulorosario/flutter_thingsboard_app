package org.thingsboard.app.cumulo

import android.app.Activity
import android.content.Intent
import android.graphics.Color
import android.graphics.Typeface
import android.graphics.drawable.GradientDrawable
import android.os.Build
import android.os.Bundle
import android.util.TypedValue
import android.view.Gravity
import android.view.View
import android.view.WindowManager
import android.view.animation.AlphaAnimation
import android.view.animation.Animation
import android.widget.Button
import android.widget.LinearLayout
import android.widget.TextView
import android.widget.Toast

/**
 * Pantalla completa de alarma crítica. Se muestra sobre la pantalla de
 * bloqueo y la enciende. Hecha con vistas de Android (sin Flutter) para que
 * abra al instante aunque la app esté cerrada.
 */
class AlarmaCriticaActivity : Activity() {

    private var datos: Bundle? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        mostrarSobreBloqueo()
        cargar(intent)
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        setIntent(intent)
        cargar(intent)
    }

    private fun mostrarSobreBloqueo() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O_MR1) {
            setShowWhenLocked(true)
            setTurnScreenOn(true)
        } else {
            @Suppress("DEPRECATION")
            window.addFlags(
                WindowManager.LayoutParams.FLAG_SHOW_WHEN_LOCKED or
                    WindowManager.LayoutParams.FLAG_TURN_SCREEN_ON
            )
        }
        window.addFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON)
        window.statusBarColor = ROJO_OSCURO
    }

    private fun dp(v: Int) = TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP, v.toFloat(), resources.displayMetrics).toInt()

    private fun texto(t: String, sp: Float, color: Int, negrita: Boolean = false) = TextView(this).apply {
        text = t
        setTextSize(TypedValue.COMPLEX_UNIT_SP, sp)
        setTextColor(color)
        gravity = Gravity.CENTER
        if (negrita) typeface = Typeface.DEFAULT_BOLD
    }

    private fun boton(t: String, fondo: Int, colorTexto: Int, borde: Int? = null) = Button(this).apply {
        text = t
        isAllCaps = false
        setTextSize(TypedValue.COMPLEX_UNIT_SP, 17f)
        setTextColor(colorTexto)
        typeface = Typeface.DEFAULT_BOLD
        background = GradientDrawable().apply {
            cornerRadius = dp(14).toFloat()
            setColor(fondo)
            if (borde != null) setStroke(dp(2), borde)
        }
        layoutParams = LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT, dp(60)).apply {
            topMargin = dp(12)
        }
    }

    private fun cargar(intent: Intent) {
        val d = intent.extras ?: run { finish(); return }
        datos = d
        val alarmId = d.getString(AlarmaCritica.K_ID) ?: run { finish(); return }
        val severidad = AlarmaCritica.traducirSeveridad(d.getString(AlarmaCritica.K_SEVERIDAD) ?: "CRITICAL")
        val dispositivo = d.getString(AlarmaCritica.K_DISPOSITIVO) ?: "Dispositivo"
        val tipo = d.getString(AlarmaCritica.K_TIPO) ?: "Alarma"

        val raiz = LinearLayout(this).apply {
            orientation = LinearLayout.VERTICAL
            gravity = Gravity.CENTER_HORIZONTAL
            setPadding(dp(24), dp(48), dp(24), dp(32))
            setBackgroundColor(ROJO_OSCURO)
        }

        val icono = texto("⚠", 72f, Color.WHITE)
        icono.startAnimation(AlphaAnimation(1f, 0.25f).apply {
            duration = 700
            repeatMode = Animation.REVERSE
            repeatCount = Animation.INFINITE
        })
        raiz.addView(icono)
        raiz.addView(texto("ALARMA $severidad", 16f, Color.parseColor("#FFCDD2"), true).apply { letterSpacing = 0.2f })
        raiz.addView(texto(dispositivo, 30f, Color.WHITE, true).apply { setPadding(0, dp(16), 0, dp(8)) })
        raiz.addView(texto(tipo, 20f, Color.WHITE))

        raiz.addView(View(this), LinearLayout.LayoutParams(0, 0, 1f))

        val estado = texto("", 14f, Color.parseColor("#FFCDD2")).apply { setPadding(0, 0, 0, dp(4)) }
        raiz.addView(estado)

        val reconocer = boton("RECONOCER Y SILENCIAR", Color.WHITE, ROJO_OSCURO)
        val resolver = boton("Resolver alarma", Color.TRANSPARENT, Color.WHITE, Color.WHITE)
        val silenciar = boton("Solo silenciar", Color.TRANSPARENT, Color.parseColor("#FFCDD2"))
        raiz.addView(reconocer)
        raiz.addView(resolver)
        raiz.addView(silenciar)
        setContentView(raiz)

        fun ejecutar(accion: String) {
            AlarmaCritica.silenciar(this, alarmId)
            reconocer.isEnabled = false
            resolver.isEnabled = false
            estado.text = "Enviando…"
            Thread {
                val error = AlarmaCritica.enviarAccion(d, accion)
                runOnUiThread {
                    if (error == null) {
                        Toast.makeText(this,
                            if (accion == AlarmaCritica.ACCION_ACK) "Alarma reconocida" else "Alarma resuelta",
                            Toast.LENGTH_LONG).show()
                        finish()
                    } else {
                        estado.text = "No se pudo enviar: $error.\nPodés hacerlo desde la app."
                        reconocer.isEnabled = true
                        resolver.isEnabled = true
                    }
                }
            }.start()
        }

        reconocer.setOnClickListener { ejecutar(AlarmaCritica.ACCION_ACK) }
        resolver.setOnClickListener { ejecutar(AlarmaCritica.ACCION_CLEAR) }
        silenciar.setOnClickListener {
            AlarmaCritica.silenciar(this, alarmId)
            finish()
        }
    }

    companion object {
        private val ROJO_OSCURO = Color.parseColor("#B71C1C")
    }
}
