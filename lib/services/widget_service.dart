import 'package:flutter/foundation.dart';
import 'package:home_widget/home_widget.dart';

class WidgetService {
  static const String appGroupId = 'group.com.ai.eatiq';
  static const String iOSWidgetName = 'EatiqWidget';

  static Future<void> updateData({
    required double calories,
    required double water,
    required int streak,
  }) async {
    try {
      await HomeWidget.setAppGroupId(appGroupId);
      await HomeWidget.saveWidgetData<int>('calories', calories.toInt());
      await HomeWidget.saveWidgetData<double>('water', water);
      await HomeWidget.saveWidgetData<int>('streak', streak);
      await HomeWidget.updateWidget(iOSName: iOSWidgetName);
    } catch (e) {
      // Widget service may throw error on unsupported platforms or missing setup
      debugPrint("Widget update failed: $e");
    }
  }
}
