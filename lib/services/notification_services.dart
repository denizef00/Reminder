import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart';
import 'package:timezone/timezone.dart';

class NotificationServices {
  final FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initNotification() async {
    initializeTimeZones();

    setLocalLocation(getLocation('Europe/Istanbul'));

    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    const iosSettings = DarwinInitializationSettings();

    const InitializationSettings initializationSettings =
        InitializationSettings(android: androidSettings, iOS: iosSettings);

    await notificationsPlugin.initialize(settings: initializationSettings);
  }

  Future<void> showInstantNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    await notificationsPlugin.show(
      id: id,
      title: title,
      body: body,
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          "instant_notification_channel_id",
          "Instant Notifications",
          channelDescription: "Instant Notification Channel",
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
    );
  }

  Future<void> scheduleReminder({
    required int id,
    required String title,
    required String body,
    required String dateStr,
    required String timeStr,
  }) async {
    final dateParts = dateStr.split("/");
    final timeParts = timeStr.split(":");

    if (dateParts.length != 3 && timeParts.length != 3) return;

    final day = int.parse(dateParts[0]);
    final month = int.parse(dateParts[1]);
    final year = int.parse(dateParts[2]);
    final hour = int.parse(timeParts[0]);
    final minute = int.parse(timeParts[1]);

    TZDateTime eventDate = TZDateTime(local, year, month, day, hour, minute);

    TZDateTime scheduledDate = eventDate.subtract(Duration(minutes: 1));

    print('==============Bildirim Kuruldu==============');
    print('Event Title: ${title}');
    print('Event Body: ${body}');
    print('Local: ${local}');
    print('Schedule Time: ${scheduledDate}');
    print('Event Date : ${eventDate}');
    print('Now: ${TZDateTime.now(local)}');
    print('============================================');

    await notificationsPlugin.zonedSchedule(
      id: id,
      title: title,
      body: body,
      scheduledDate: scheduledDate,

      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          'daily_reminder_channel_id',
          'Daily Reminders',
          channelDescription: 'Reminder to complete daily habits',
          importance: Importance.max,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }
}
