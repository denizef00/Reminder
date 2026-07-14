import 'dart:io';
//import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest.dart' as tz;

class NotificationServices {
  final FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final bool _isInitialized = false;

  Future<void> initNotification() async {
    if (_isInitialized) return;

    tz.initializeTimeZones();
    final TimezoneInfo timezoneInfo = await FlutterTimezone.getLocalTimezone();
    final String currentTimeZone = timezoneInfo.identifier;
    tz.setLocalLocation(tz.getLocation(currentTimeZone));

    const initializationSettingsAndroid = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    const initializationSettingsIOS = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    const initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    await notificationsPlugin.initialize(settings: initializationSettings);
    /*
    try {
      if (_isInitialized) return;

      tz.initializeTimeZones();
      try {
        final timezoneInfo = await FlutterTimezone.getLocalTimezone();
        String currentTimeZone = timezoneInfo.identifier;
        print("Cihaz timezone: $currentTimeZone");

        // "GMT" gibi tz veritabanının tanımadığı isimleri düzelt
        if (currentTimeZone == "GMT" || currentTimeZone.isEmpty) {
          currentTimeZone =
              "Europe/Istanbul"; // ya da Etc/GMT gibi güvenli bir fallback
        }

        tz.setLocalLocation(tz.getLocation(currentTimeZone));
        print("tz.local set edildi: ${tz.local}");
      } catch (e) {
        print("Init Notifi Error: $e");
        // UTC yerine daha mantıklı bir fallback
        tz.setLocalLocation(tz.getLocation('Europe/Istanbul'));
      }
      const initializationSettingsAndroid = AndroidInitializationSettings(
        '@mipmap/ic_launcher',
      );

      const initializationSettingsIOS = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      );
      const initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsIOS,
      );
      await notificationsPlugin.initialize(settings: initializationSettings);
    } catch (e) {
      print("Init Notifi Error: $e");
      try {
        tz.setLocalLocation(tz.getLocation('UTC'));
      } catch (_) {}
    }*/
  }

  NotificationDetails notificationDetails() {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        "reminder_id",
        'Reminder Notification',
        channelDescription: 'Reminder Notification Description',
        importance: Importance.max,
        priority: Priority.high,
        enableVibration: true,
        fullScreenIntent: true,
      ),
      iOS: DarwinNotificationDetails(),
    );
  }

  Future<void> showNotification({
    int id = 0,
    String? title,
    String? body,
  }) async {
    return notificationsPlugin.show(
      id: id,
      title: title,
      body: body,
      notificationDetails: notificationDetails(),
    );
  }

  Future<void> scheduleNotification({
    int id = 1,
    required String title,
    required String body,
    required DateTime dateTime,
    //required String dateStr,
    //required String timeStr,
  }) async {
    final tz.TZDateTime scheduleDate = tz.TZDateTime(
      tz.local,
      dateTime.year,
      dateTime.month,
      dateTime.day,
      dateTime.hour,
      dateTime.minute,
    );

    print("tz.local: ${tz.local}");
    print("Kurulan (tz): $scheduleDate");
    print("Şimdi (tz): ${tz.TZDateTime.now(tz.local)}");

    await notificationsPlugin.zonedSchedule(
      id: id,
      title: title,
      body: body,
      scheduledDate: scheduleDate,
      notificationDetails: notificationDetails(),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );

    /*
    try {
      print("--------------------------------------------------");
      print("🔔 [BİLDİRİM LOG] Kurulum Başladı...");
      print(
        "🔔 [BİLDİRİM LOG] Gelen String Değerleri -> Tarih: '$dateStr' | Saat: '$timeStr'",
      );
      final dateParts = dateStr.split('/');
      final timeParts = timeStr.split(':');
      if (dateParts.length != 3 || timeParts.length != 2) {
        print(
          "❌ [BİLDİRİM HATA] Tarih veya saat formatı split edilemedi! Format yanlış.",
        );
        return;
      }
      final int day = int.parse(dateParts[0]);
      final int month = int.parse(dateParts[1]);
      final int year = int.parse(dateParts[2]);
      final int hour = int.parse(timeParts[0]);
      final int minute = int.parse(timeParts[1]);

      final DateTime eventDate = DateTime(year, month, day, hour, minute);
      print("🔔 [BİLDİRİM LOG] Üretilen DateTime Nesnesi: $eventDate");
      print(
        "🔔 [BİLDİRİM LOG] Cihazın Şu Anki Saati (now):  ${DateTime.now()}",
      );
      final scheduleDateTime =
          eventDate; //.subtract(const Duration(minutes: 15));

      if (eventDate.isBefore(DateTime.now())) {
        print(
          "❌ [BİLDİRİM HATA] KRAL YAKALADIK! Kurulmak istenen zaman şu andan GERİDE kalıyor.",
        );
        print(
          "❌ [BİLDİRİM HATA] Android geçmişe kurulan bildirimleri anında çöpe atar, ASLA ÇALMAZ!",
        );
        print("--------------------------------------------------");
        return;
      }
      if (scheduleDateTime.isBefore(DateTime.now())) return;
      final tz.TZDateTime tzScheduleTime = tz.TZDateTime.utc(
        scheduleDateTime.year,
        scheduleDateTime.month,
        scheduleDateTime.day,
        scheduleDateTime.hour,
        scheduleDateTime.minute,
      );
      print(
        "🔔 [BİLDİRİM LOG] Cihaz Lokaline (TZDateTime) Çevrilmiş Hali: $tzScheduleTime",
      );

      await notificationsPlugin.zonedSchedule(
        id: id,
        title: title,
        body: body,
        scheduledDate: tzScheduleTime,
        notificationDetails: notificationDetails(),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      );
      print(
        "🎯 [BİLDİRİM BAŞARILI] İşletim sistemine rezervasyon yapıldı! Saat gelince çalacak.",
      );
      print("--------------------------------------------------");
    } catch (e) {
      print("❌ [BİLDİRİM SİSTEMSEL HATA] Kod patladı: $e");
      print("--------------------------------------------------");
    }*/
  }

  Future<void> requestPermissions() async {
    if (Platform.isAndroid) {
      await Permission.notification.request();
    }

    var exactAlarmStatus = await Permission.scheduleExactAlarm.status;
    if (exactAlarmStatus.isDenied) {
      print("Exact alarm izin yok,isteniyor..");
      await Permission.scheduleExactAlarm.request();
    }
    /*
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    if (Platform.isAndroid) {
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.requestNotificationsPermission();

      try {
        const androidSettingsIntent =
            'android.settings.REQUEST_SCHEDULE_EXACT_ALARM';

        await const MethodChannel(
          'plugins.flutter.io/android_intent',
        ).invokeMethod('launch', <String, dynamic>{
          'action': androidSettingsIntent,
          'data': 'package:com.example.reminder',
        });
      } catch (e) {
        print(
          "Exact alarm izni istenirken hata oluştu veya cihaz Android 12 altı: $e",
        );
      }
    }*/
  }

  Future<void> cancelNotification({required int id}) async {
    try {
      await notificationsPlugin.cancel(id: id);
    } catch (e) {
      print("Cancel Notifi Error: $e");
    }
  }
}
