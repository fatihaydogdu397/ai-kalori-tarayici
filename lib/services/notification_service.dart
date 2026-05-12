import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz_data;

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
// Water reminders use a contiguous range so apply() can cancel the whole batch
// before re-scheduling. 100..115 covers up to 16 daily slots.
const kNotifWaterBase = 100;
const kNotifWaterMaxSlots = 16;

// SharedPrefs keys
const kPrefNotifEnabled = 'notif_enabled';
const kPrefNotifBreakfastEnabled = 'notif_breakfast_enabled';
const kPrefNotifLunchEnabled = 'notif_lunch_enabled';
const kPrefNotifDinnerEnabled = 'notif_dinner_enabled';
const kPrefNotifBreakfastHour = 'notif_breakfast_hour';
const kPrefNotifBreakfastMin = 'notif_breakfast_min';
const kPrefNotifLunchHour = 'notif_lunch_hour';
const kPrefNotifLunchMin = 'notif_lunch_min';
const kPrefNotifDinnerHour = 'notif_dinner_hour';
const kPrefNotifDinnerMin = 'notif_dinner_min';
const kPrefNotifWaterEnabled = 'notif_water_enabled';
const kPrefNotifWaterIntervalH = 'notif_water_interval_h';
const kPrefNotifWaterAmountMl = 'notif_water_amount_ml';
const kPrefNotifWaterStartH = 'notif_water_start_h';
const kPrefNotifWaterEndH = 'notif_water_end_h';

class NotificationSettings {
  final bool enabled;
  final bool breakfastEnabled;
  final bool lunchEnabled;
  final bool dinnerEnabled;
  final TimeOfDay breakfastTime;
  final TimeOfDay lunchTime;
  final TimeOfDay dinnerTime;
  // Water reminders — kullanıcı kaç saatte bir / kaç ml içtiğini seçer.
  final bool waterEnabled;
  final int waterIntervalHours; // 1..6
  final int waterAmountMl;      // mesajda gösterilecek miktar
  final int waterStartHour;     // 0..23
  final int waterEndHour;       // start..23

  const NotificationSettings({
    this.enabled = true,
    this.breakfastEnabled = true,
    this.lunchEnabled = true,
    this.dinnerEnabled = true,
    this.breakfastTime = const TimeOfDay(hour: 8, minute: 0),
    this.lunchTime = const TimeOfDay(hour: 12, minute: 30),
    this.dinnerTime = const TimeOfDay(hour: 19, minute: 0),
    this.waterEnabled = false,
    this.waterIntervalHours = 2,
    this.waterAmountMl = 250,
    this.waterStartHour = 8,
    this.waterEndHour = 22,
  });

  static Future<NotificationSettings> load() async {
    final prefs = await SharedPreferences.getInstance();
    return NotificationSettings(
      enabled: prefs.getBool(kPrefNotifEnabled) ?? true,
      breakfastEnabled: prefs.getBool(kPrefNotifBreakfastEnabled) ?? true,
      lunchEnabled: prefs.getBool(kPrefNotifLunchEnabled) ?? true,
      dinnerEnabled: prefs.getBool(kPrefNotifDinnerEnabled) ?? true,
      breakfastTime: TimeOfDay(hour: prefs.getInt(kPrefNotifBreakfastHour) ?? 8, minute: prefs.getInt(kPrefNotifBreakfastMin) ?? 0),
      lunchTime: TimeOfDay(hour: prefs.getInt(kPrefNotifLunchHour) ?? 12, minute: prefs.getInt(kPrefNotifLunchMin) ?? 30),
      dinnerTime: TimeOfDay(hour: prefs.getInt(kPrefNotifDinnerHour) ?? 19, minute: prefs.getInt(kPrefNotifDinnerMin) ?? 0),
      waterEnabled: prefs.getBool(kPrefNotifWaterEnabled) ?? false,
      waterIntervalHours: prefs.getInt(kPrefNotifWaterIntervalH) ?? 2,
      waterAmountMl: prefs.getInt(kPrefNotifWaterAmountMl) ?? 250,
      waterStartHour: prefs.getInt(kPrefNotifWaterStartH) ?? 8,
      waterEndHour: prefs.getInt(kPrefNotifWaterEndH) ?? 22,
    );
  }

  Future<void> save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(kPrefNotifEnabled, enabled);
    await prefs.setBool(kPrefNotifBreakfastEnabled, breakfastEnabled);
    await prefs.setBool(kPrefNotifLunchEnabled, lunchEnabled);
    await prefs.setBool(kPrefNotifDinnerEnabled, dinnerEnabled);
    await prefs.setInt(kPrefNotifBreakfastHour, breakfastTime.hour);
    await prefs.setInt(kPrefNotifBreakfastMin, breakfastTime.minute);
    await prefs.setInt(kPrefNotifLunchHour, lunchTime.hour);
    await prefs.setInt(kPrefNotifLunchMin, lunchTime.minute);
    await prefs.setInt(kPrefNotifDinnerHour, dinnerTime.hour);
    await prefs.setInt(kPrefNotifDinnerMin, dinnerTime.minute);
    await prefs.setBool(kPrefNotifWaterEnabled, waterEnabled);
    await prefs.setInt(kPrefNotifWaterIntervalH, waterIntervalHours);
    await prefs.setInt(kPrefNotifWaterAmountMl, waterAmountMl);
    await prefs.setInt(kPrefNotifWaterStartH, waterStartHour);
    await prefs.setInt(kPrefNotifWaterEndH, waterEndHour);
  }

  /// Active hours içinde her [waterIntervalHours] saatte bir tetiklenecek
  /// günlük slot listesi. Örn. 8→22 / 2 saat = [8,10,12,14,16,18,20,22].
  List<TimeOfDay> get waterSlots {
    if (!waterEnabled) return const [];
    final int step = waterIntervalHours.clamp(1, 6);
    final int start = waterStartHour.clamp(0, 23);
    final int end = waterEndHour.clamp(start, 23);
    final slots = <TimeOfDay>[];
    for (int h = start; h <= end && slots.length < kNotifWaterMaxSlots; h += step) {
      slots.add(TimeOfDay(hour: h, minute: 0));
    }
    return slots;
  }

  Future<void> apply({
    String? waterTitle,
    String Function(int amountMl)? waterBody,
  }) async {
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

    // Water reminders — önce eski slot'ları topluca iptal et, sonra yeniden kur.
    for (int i = 0; i < kNotifWaterMaxSlots; i++) {
      await NotificationService.cancel(kNotifWaterBase + i);
    }
    if (waterEnabled) {
      final slots = waterSlots;
      final title = waterTitle ?? 'Su zamanı! 💧';
      final body = waterBody?.call(waterAmountMl) ?? '$waterAmountMl ml su içmeyi unutma.';
      for (int i = 0; i < slots.length; i++) {
        await NotificationService.scheduleDaily(kNotifWaterBase + i, slots[i], title, body);
      }
    }
  }

  NotificationSettings copyWith({
    bool? enabled, bool? breakfastEnabled, bool? lunchEnabled, bool? dinnerEnabled,
    TimeOfDay? breakfastTime, TimeOfDay? lunchTime, TimeOfDay? dinnerTime,
    bool? waterEnabled, int? waterIntervalHours, int? waterAmountMl,
    int? waterStartHour, int? waterEndHour,
  }) => NotificationSettings(
    enabled: enabled ?? this.enabled,
    breakfastEnabled: breakfastEnabled ?? this.breakfastEnabled,
    lunchEnabled: lunchEnabled ?? this.lunchEnabled,
    dinnerEnabled: dinnerEnabled ?? this.dinnerEnabled,
    breakfastTime: breakfastTime ?? this.breakfastTime,
    lunchTime: lunchTime ?? this.lunchTime,
    dinnerTime: dinnerTime ?? this.dinnerTime,
    waterEnabled: waterEnabled ?? this.waterEnabled,
    waterIntervalHours: waterIntervalHours ?? this.waterIntervalHours,
    waterAmountMl: waterAmountMl ?? this.waterAmountMl,
    waterStartHour: waterStartHour ?? this.waterStartHour,
    waterEndHour: waterEndHour ?? this.waterEndHour,
  );
}
