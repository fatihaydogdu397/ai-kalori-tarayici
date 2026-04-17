import 'api_client.dart';

/// Backend `appSettings` + `updateAppSettings` (EAT-105).
/// Tema, bildirim toggle'ları ve öğün hatırlatma saatleri.
class SettingsService {
  SettingsService._();
  static final SettingsService instance = SettingsService._();

  final ApiClient _api = ApiClient.instance;

  static const String _fields = '''
    theme
    notificationsEnabled
    reminderBreakfastEnabled reminderBreakfastTime
    reminderLunchEnabled reminderLunchTime
    reminderDinnerEnabled reminderDinnerTime
    dailySummaryEnabled
  ''';

  Future<Map<String, dynamic>> getAppSettings() async {
    final data = await _api.query(
      '''query AppSettings { appSettings { $_fields } }''',
    );
    return Map<String, dynamic>.from(data['appSettings'] as Map);
  }

  /// Null olmayan alanlar gönderilir. Enum theme "DARK" | "LIGHT" | "SYSTEM".
  /// Time alanları "HH:MM" formatında (örn. "08:00").
  Future<Map<String, dynamic>> updateAppSettings({
    String? theme,
    bool? notificationsEnabled,
    bool? reminderBreakfastEnabled,
    String? reminderBreakfastTime,
    bool? reminderLunchEnabled,
    String? reminderLunchTime,
    bool? reminderDinnerEnabled,
    String? reminderDinnerTime,
    bool? dailySummaryEnabled,
  }) async {
    final input = <String, dynamic>{};
    if (theme != null) input['theme'] = theme.toUpperCase();
    if (notificationsEnabled != null) {
      input['notificationsEnabled'] = notificationsEnabled;
    }
    if (reminderBreakfastEnabled != null) {
      input['reminderBreakfastEnabled'] = reminderBreakfastEnabled;
    }
    if (reminderBreakfastTime != null) {
      input['reminderBreakfastTime'] = reminderBreakfastTime;
    }
    if (reminderLunchEnabled != null) {
      input['reminderLunchEnabled'] = reminderLunchEnabled;
    }
    if (reminderLunchTime != null) {
      input['reminderLunchTime'] = reminderLunchTime;
    }
    if (reminderDinnerEnabled != null) {
      input['reminderDinnerEnabled'] = reminderDinnerEnabled;
    }
    if (reminderDinnerTime != null) {
      input['reminderDinnerTime'] = reminderDinnerTime;
    }
    if (dailySummaryEnabled != null) {
      input['dailySummaryEnabled'] = dailySummaryEnabled;
    }

    final data = await _api.mutate(
      '''
      mutation UpdateAppSettings(\$input: UpdateAppSettingsInput!) {
        updateAppSettings(input: \$input) { $_fields }
      }
      ''',
      variables: {'input': input},
    );
    return Map<String, dynamic>.from(data['updateAppSettings'] as Map);
  }
}
