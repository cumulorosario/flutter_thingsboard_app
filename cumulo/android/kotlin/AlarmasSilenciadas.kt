package org.thingsboard.app.cumulo

import android.content.Context
import org.json.JSONArray
import org.json.JSONObject

/**
 * Alarmas silenciadas en este teléfono: combinación equipo + tipo de alarma.
 * Una alarma crítica silenciada no suena ni abre la pantalla completa.
 */
object AlarmasSilenciadas {
    private const val PREFS = "cumulo_alarmas"
    private const val CLAVE = "silenciadas"

    data class Filtro(val dispositivo: String, val tipo: String) {
        val clave get() = "${dispositivo.trim().lowercase()}::${tipo.trim().lowercase()}"
    }

    fun listar(ctx: Context): List<Filtro> {
        val json = ctx.getSharedPreferences(PREFS, Context.MODE_PRIVATE).getString(CLAVE, "[]") ?: "[]"
        return try {
            val arr = JSONArray(json)
            (0 until arr.length()).map {
                val o = arr.getJSONObject(it)
                Filtro(o.optString("dispositivo"), o.optString("tipo"))
            }
        } catch (e: Exception) {
            emptyList()
        }
    }

    private fun guardar(ctx: Context, filtros: List<Filtro>) {
        val arr = JSONArray()
        filtros.forEach { arr.put(JSONObject().put("dispositivo", it.dispositivo).put("tipo", it.tipo)) }
        ctx.getSharedPreferences(PREFS, Context.MODE_PRIVATE).edit().putString(CLAVE, arr.toString()).apply()
    }

    fun estaSilenciada(ctx: Context, dispositivo: String, tipo: String): Boolean {
        val clave = Filtro(dispositivo, tipo).clave
        return listar(ctx).any { it.clave == clave }
    }

    fun silenciar(ctx: Context, dispositivo: String, tipo: String) {
        val nuevo = Filtro(dispositivo, tipo)
        guardar(ctx, listar(ctx).filter { it.clave != nuevo.clave } + nuevo)
    }

    fun reactivar(ctx: Context, filtro: Filtro) {
        guardar(ctx, listar(ctx).filter { it.clave != filtro.clave })
    }
}
