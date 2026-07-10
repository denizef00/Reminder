import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationServices {
  static final NotificationServices _instance =
      NotificationServices._internal();
  factory NotificationServices() => _instance;
  NotificationServices._internal();

  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initNotification() async {
    tz.initializeTimeZones();

    tz.setLocalLocation(tz.getLocation('Europe/Istanbul'));

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
        );
    const InitializationSettings initializationSettings =
        InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: initializationSettingsIOS,
        );
    await _notificationsPlugin.initialize(settings: initializationSettings);
  }

  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required String dateStr,
    required String timeStr,
  }) async {
    try {
      final dateParts = dateStr.split("/");
      final timeParts = timeStr.split(":");

      final int day = int.parse(dateParts[0]);
      final int month = int.parse(dateParts[1]);
      final int year = int.parse(dateParts[2]);
      final int hour = int.parse(timeParts[0]);
      final int minute = int.parse(timeParts[1]);

      final DateTime eventDateTime = DateTime(year, month, day, hour, minute);

      //final DateTime notificationTime = eventDateTime.subtract(const Duration(minutes: 1),);
      final DateTime notificationTime = eventDateTime.subtract(
        const Duration(seconds: 20),
      );

      if (notificationTime.isBefore(DateTime.now())) return;

      final tz.TZDateTime tzNotificationTime = tz.TZDateTime.from(
        notificationTime,
        tz.local,
      );
      const AndroidNotificationDetails androidDetails =
          AndroidNotificationDetails(
            'reminder_channel_id',
            'Reminder Notifications',
            channelDescription: 'Channel for event reminder notifications',
            importance: Importance.max,
            priority: Priority.high,
            playSound: true,
          );

      const NotificationDetails platformDetails = NotificationDetails(
        android: androidDetails,
        iOS: DarwinNotificationDetails(),
      );

      await _notificationsPlugin.zonedSchedule(
        id: id,
        title: title,
        body: body,
        scheduledDate: tzNotificationTime,
        notificationDetails: platformDetails,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      );
    } catch (e) {
      print("BILIRIM HATASI: $e");
    }
  }

  Future<void> cancelNotification(int id) async {
    await _notificationsPlugin.cancel(id: id);
  }

  Future<void> requestPermissions() async {
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();
  }
}
