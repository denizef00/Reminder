import 'dart:convert';
import 'package:reminder/services/notification_services.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../models/event_model.dart';

part 'event_provider.g.dart';

@riverpod
class EventList extends _$EventList {
  static const _storageKey = "saved_events";
  @override
  List<EventModel> build() {
    _initLoad();
    return [];
  }

  final uuid = Uuid();
  void addEvent(
    String title,
    String description,
    String date,
    String time,
  ) async {
    final int id = uuid.v4().hashCode;
    final newEvent = EventModel(
      id: id,
      title: title,
      description: description,
      date: date,
      time: time,
    );

    state = [...state, newEvent];
    _saveEvent(state);
    try {
      final List<String> dateParts = date.split("/");
      final List<String> timeParts = time.split(":");
      final DateTime eventDate = DateTime(
        int.parse(dateParts[2]),
        int.parse(dateParts[1]),
        int.parse(dateParts[0]),
        int.parse(timeParts[0]),
        int.parse(timeParts[1]),
      );
      print("=== DEBUG ===");
      print("Girdi date: $date, time: $time");
      print("Parse edilen eventDate: $eventDate");
      print("Şu anki zaman: ${DateTime.now()}");
      print("Geçmiş mi?: ${eventDate.isBefore(DateTime.now())}");
      await NotificationServices().scheduleNotification(
        id: id,
        title: title,
        body: description,
        dateTime: eventDate,
        //dateStr: date,
        //timeStr: time,
      );

      final pending = await NotificationServices().notificationsPlugin
          .pendingNotificationRequests();
      print("Bekleyen bildirim sayısı: ${pending.length}");
      for (var p in pending) {
        print("  -> id: ${p.id}, title: ${p.title}");
      }
    } catch (e, stack) {
      print("HATA: $e");
      print(stack);
    }
  }

  void deleteEvent(String id) {
    state = state.where((event) => event.id != id).toList();
    _saveEvent(state);
  }

  void toggleCheck(String id) {
    final List<EventModel> tempList = List.from(state);

    for (int i = 0; i < tempList.length; i++) {
      if (tempList[i].id == id) {
        if (tempList[i].isCompleted) {
          tempList[i] = tempList[i].copyWith(isCompleted: false);
        } else {
          tempList[i] = tempList[i].copyWith(isCompleted: true);
        }
        break;
      }
    }
    state = tempList;
    _saveEvent(state);
  }

  void updateEvent({
    required String id,
    required String newTitle,
    required String newDesc,
    required String newDate,
    required String newTime,
  }) {
    state = [
      for (final event in state)
        if (event.id == id)
          event.copyWith(
            title: newTitle,
            description: newDesc,
            date: newDate,
            time: newTime,
          )
        else
          event,
    ];
  }

  void updateEventTime(String id, String newTime) {
    state = [
      for (final event in state)
        if (event.id == id) event.copyWith(time: newTime) else event,
    ];
  }

  Future<void> _saveEvent(List<EventModel> currentEvent) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String encodedData = jsonEncode(
        currentEvent.map((e) => e.toJson()).toList(),
      );
      await prefs.setString(_storageKey, encodedData);
    } catch (e) {
      print("VERİ KAYDETMEDE HATA VAR");
    }
  }

  void _initLoad() async {
    final savedList = await _loadEventsFromStorage();
    if (savedList.isNotEmpty) {
      state = savedList;
    }
  }

  Future<List<EventModel>> _loadEventsFromStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? eventString = prefs.getString(_storageKey);

      if (eventString != null) {
        final List<dynamic> decodedList = jsonDecode(eventString);
        return decodedList.map((item) => EventModel.fromJson(item)).toList();
      }
    } catch (e) {
      print("VERİ YÜKELEMEDE HATA VAR");
    }
    return [];
  }
}
