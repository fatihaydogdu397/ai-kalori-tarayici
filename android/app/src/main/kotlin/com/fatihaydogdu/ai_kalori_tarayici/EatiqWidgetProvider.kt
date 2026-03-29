package com.fatihaydogdu.ai_kalori_tarayici

import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.SharedPreferences
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetProvider

class EatiqWidgetProvider : HomeWidgetProvider() {
    override fun onUpdate(context: Context, appWidgetManager: AppWidgetManager, appWidgetIds: IntArray, widgetData: SharedPreferences) {
        appWidgetIds.forEach { widgetId ->
            val views = RemoteViews(context.packageName, R.layout.widget_layout).apply {
                val calories = widgetData.getInt("calories", 0)
                
                // Float/Double parsing safely
                var water = 0.0f
                try {
                    water = widgetData.getFloat("water", 0f)
                } catch (e: Exception) {
                    try {
                       val doubleBits = widgetData.getLong("water", 0L)
                       water = java.lang.Double.longBitsToDouble(doubleBits).toFloat()
                    } catch (e2: Exception) { }
                }
                
                val streak = widgetData.getInt("streak", 0)
                
                setTextViewText(R.id.widget_calories, calories.toString())
                setTextViewText(R.id.widget_water, String.format("%.1fL", water).replace(",", "."))
                setTextViewText(R.id.widget_streak, streak.toString())
            }
            appWidgetManager.updateAppWidget(widgetId, views)
        }
    }
}
