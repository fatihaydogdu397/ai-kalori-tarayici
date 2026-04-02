import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz_data;
import '../generated/app_localizations.dart';

class NotificationService {
  static final _plugin = FlutterLocalNotificationsPlugin();
  static bool _initialized = false;

  static Future<void> init() async {
    if (_initialized) return;
    tz_data.initializeTimeZones();

    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    await _plugin.initialize(const InitializationSettings(android: android, iOS: ios));
    _initialized = true;
  }

  static Future<bool> requestPermission() async {
    final ios = _plugin.resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>();
    final result = await ios?.requestPermissions(alert: true, badge: true, sound: true);
    return result ?? false;
  }

  static Future<void> scheduleDaily(int id, TimeOfDay time, String title, String body) async {
    await _plugin.zonedSchedule(
      id,
      title,
      body,
      _nextInstanceOf(time),
      NotificationDetails(
        android: const AndroidNotificationDetails('eatiq_reminders', 'Eatiq Hatırlatıcılar', importance: Importance.high, priority: Priority.high),
        iOS: const DarwinNotificationDetails(sound: 'default'),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  static Future<void> updateDailySummary(AppLocalizations l, {required double calories, required double goal, required double water}) async {
    final prefs = await SharedPreferences.getInstance();
    final isEnabled = prefs.getBool(kPrefNotifSummaryEnabled) ?? true;
    if (!isEnabled) return;

    final title = l.dailySummaryTitle;
    final body = l.dailySummaryBody(
      calories.toStringAsFixed(0),
      goal.toStringAsFixed(0),
      (water / 1000).toStringAsFixed(1),
    );

    await scheduleDaily(kNotifSummary, const TimeOfDay(hour: 20, minute: 0), title, body);
  }

  static Future<void> cancel(int id) => _plugin.cancel(id);

  static Future<void> cancelAll() => _plugin.cancelAll();

  static tz.TZDateTime _nextInstanceOf(TimeOfDay time) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduled = tz.TZDateTime(tz.local, now.year, now.month, now.day, time.hour, time.minute);
    if (scheduled.isBefore(now)) scheduled = scheduled.add(const Duration(days: 1));
    return scheduled;
  }
}

// Notification IDs
const kNotifBreakfast = 1;
const kNotifLunch = 2;
const kNotifDinner = 3;
const kNotifSummary = 4;

// SharedPrefs keys
const kPrefNotifEnabled = 'notif_enabled';
const kPrefNotifBreakfastEnabled = 'notif_breakfast_enabled';
const kPrefNotifLunchEnabled = 'notif_lunch_enabled';
const kPrefNotifDinnerEnabled = 'notif_dinner_enabled';
const kPrefNotifBreakfastHour = 'notif_breakfast_hour';
const kPrefNotifBreakfastMin = 'notif_breakfast_min';
const kPrefNotifLunchHour = 'notif_lunch_hour';
const kPrefNotifLunchMin = 'notif_lunch_min';
const kPrefNotifSummaryEnabled = 'notif_summary_enabled';
const kPrefNotifDinnerHour = 'notif_dinner_hour';
const kPrefNotifDinnerMin = 'notif_dinner_min';

class NotificationSettings {
  final bool enabled;
  final bool breakfastEnabled;
  final bool lunchEnabled;
  final bool dinnerEnabled;
  final TimeOfDay breakfastTime;
  final TimeOfDay lunchTime;
  final TimeOfDay dinnerTime;

  final bool summaryEnabled;

  const NotificationSettings({
    this.enabled = true,
    this.breakfastEnabled = true,
    this.lunchEnabled = true,
    this.dinnerEnabled = true,
    this.summaryEnabled = true,
    this.breakfastTime = const TimeOfDay(hour: 8, minute: 0),
    this.lunchTime = const TimeOfDay(hour: 12, minute: 30),
    this.dinnerTime = const TimeOfDay(hour: 19, minute: 0),
  });

  static Future<NotificationSettings> load() async {
    final prefs = await SharedPreferences.getInstance();
    return NotificationSettings(
      enabled: prefs.getBool(kPrefNotifEnabled) ?? true,
      breakfastEnabled: prefs.getBool(kPrefNotifBreakfastEnabled) ?? true,
      lunchEnabled: prefs.getBool(kPrefNotifLunchEnabled) ?? true,
      dinnerEnabled: prefs.getBool(kPrefNotifDinnerEnabled) ?? true,
      summaryEnabled: prefs.getBool(kPrefNotifSummaryEnabled) ?? true,
      breakfastTime: TimeOfDay(hour: prefs.getInt(kPrefNotifBreakfastHour) ?? 8, minute: prefs.getInt(kPrefNotifBreakfastMin) ?? 0),
      lunchTime: TimeOfDay(hour: prefs.getInt(kPrefNotifLunchHour) ?? 12, minute: prefs.getInt(kPrefNotifLunchMin) ?? 30),
      dinnerTime: TimeOfDay(hour: prefs.getInt(kPrefNotifDinnerHour) ?? 19, minute: prefs.getInt(kPrefNotifDinnerMin) ?? 0),
    );
  }

  Future<void> save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(kPrefNotifEnabled, enabled);
    await prefs.setBool(kPrefNotifBreakfastEnabled, breakfastEnabled);
    await prefs.setBool(kPrefNotifLunchEnabled, lunchEnabled);
    await prefs.setBool(kPrefNotifDinnerEnabled, dinnerEnabled);
    await prefs.setBool(kPrefNotifSummaryEnabled, summaryEnabled);
    await prefs.setInt(kPrefNotifBreakfastHour, breakfastTime.hour);
    await prefs.setInt(kPrefNotifBreakfastMin, breakfastTime.minute);
    await prefs.setInt(kPrefNotifLunchHour, lunchTime.hour);
    await prefs.setInt(kPrefNotifLunchMin, lunchTime.minute);
    await prefs.setInt(kPrefNotifDinnerHour, dinnerTime.hour);
    await prefs.setInt(kPrefNotifDinnerMin, dinnerTime.minute);
  }

  Future<void> apply() async {
    if (!enabled) {
      await NotificationService.cancelAll();
      return;
    }
    if (breakfastEnabled) {
      await NotificationService.scheduleDaily(kNotifBreakfast, breakfastTime, 'Kahvaltı zamanı! 🌅', 'Kahvaltını Eatiq\'e kaydetmeyi unutma.');
    } else {
      await NotificationService.cancel(kNotifBreakfast);
    }
    if (lunchEnabled) {
      await NotificationService.scheduleDaily(kNotifLunch, lunchTime, 'Öğle yemeği! ☀️', 'Ne yedin? Eatiq\'e kaydet.');
    } else {
      await NotificationService.cancel(kNotifLunch);
    }
    if (dinnerEnabled) {
      await NotificationService.scheduleDaily(kNotifDinner, dinnerTime, 'Akşam yemeği! 🌙', 'Günü tamamlamak için akşam yemeğini kaydet.');
    } else {
      await NotificationService.cancel(kNotifDinner);
    }
    if (!summaryEnabled) {
      await NotificationService.cancel(kNotifSummary);
    }
  }

  NotificationSettings copyWith({
    bool? enabled, bool? breakfastEnabled, bool? lunchEnabled, bool? dinnerEnabled, bool? summaryEnabled,
    TimeOfDay? breakfastTime, TimeOfDay? lunchTime, TimeOfDay? dinnerTime,
  }) => NotificationSettings(
    enabled: enabled ?? this.enabled,
    breakfastEnabled: breakfastEnabled ?? this.breakfastEnabled,
    lunchEnabled: lunchEnabled ?? this.lunchEnabled,
    dinnerEnabled: dinnerEnabled ?? this.dinnerEnabled,
    summaryEnabled: summaryEnabled ?? this.summaryEnabled,
    breakfastTime: breakfastTime ?? this.breakfastTime,
    lunchTime: lunchTime ?? this.lunchTime,
    dinnerTime: dinnerTime ?? this.dinnerTime,
  );
}
