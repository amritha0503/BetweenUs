import 'package:flutter/material.dart';
import 'voice_of_her_service.dart';
import 'voice_story_model.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class VoiceOfHerProvider extends ChangeNotifier {
  final VoiceOfHerService _service = VoiceOfHerService();
  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  List<VoiceStory> _stories = [];
  VoiceStory? _todayStory;

  bool _isLoading = false;
  String? _errorMessage;

  /// ✅ Public Getters
  List<VoiceStory> get stories => _stories;
  VoiceStory? get todayStory => _todayStory;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  VoiceOfHerProvider() {
    _initializeNotifications();
  }

  /// ✅ Init notifications
  Future<void> _initializeNotifications() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    const initSettings = InitializationSettings(android: android, iOS: ios);

    await _notificationsPlugin.initialize(initSettings);

    // Permission note: For Android 13+, use permission_handler if needed
    final androidPlugin =
        _notificationsPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    bool granted = androidPlugin != null;
    print('🔔 Notification permission granted: $granted');
  }

  /// ✅ Load all stories + today's story
  Future<void> loadStories() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _stories = await _service.fetchStories();
      _todayStory = await _service.fetchTodayStory();

      if (_todayStory != null) {
        await _scheduleDailyNotification(_todayStory!);
      } else {
        print("⚠️ No voice story for today’s date");
      }
    } catch (e) {
      _errorMessage = 'Failed to load stories: $e';
      _stories = [];
      _todayStory = null;
    }

    _isLoading = false;
    notifyListeners();
  }

  /// 🔄 Refresh stories (manual)
  Future<void> refreshStories() async {
    await loadStories();
  }

  /// 🔔 Schedule daily voice notification
  Future<void> _scheduleDailyNotification(VoiceStory story) async {
    const androidDetails = AndroidNotificationDetails(
      'voice_of_her_channel_id',
      'Voice of Her',
      channelDescription: 'Daily empathy story by a woman',
      importance: Importance.max,
      priority: Priority.high,
    );
    const iosDetails = DarwinNotificationDetails();

    final details =
        NotificationDetails(android: androidDetails, iOS: iosDetails);

    await _notificationsPlugin.zonedSchedule(
      0,
      'Voice of Her ✨',
      'Today’s story: ${story.title}',
      _nextDailyTime(),
      details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  /// ⏰ Schedule time: 9:00 AM daily
  tz.TZDateTime _nextDailyTime() {
    final now = tz.TZDateTime.now(tz.local);
    final scheduled = tz.TZDateTime(tz.local, now.year, now.month, now.day, 9);
    return scheduled.isBefore(now)
        ? scheduled.add(const Duration(days: 1))
        : scheduled;
  }
}
