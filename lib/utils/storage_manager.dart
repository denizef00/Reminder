import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/event_model.dart';

class StorageManager {
  static const String _key = "my_key";

  static Future<void> saveEvent(EventModel newEvent) async {
    final prefs = await SharedPreferences.getInstance();
    List<EventModel> currentList = await loadEvent();
    currentList.add(newEvent);

    List<String> jsonStringList = currentList
        .map((event) => json.encode(event.toMap()))
        .toList();
    await prefs.setStringList(_key, jsonStringList);
  }

  static Future<List<EventModel>> loadEvent() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? jsonStringList = prefs.getStringList(_key);

    if (jsonStringList == null) return [];

    return jsonStringList
        .map((eventStr) => EventModel.fromMap(json.decode(eventStr)))
        .toList();
  }
}
