import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

  void addEvent(String title, String description, String date, String time) {
    final newEvent = EventModel(
      id: DateTime.now().toString(),
      title: title,
      description: description,
      date: date,
      time: time,
    );

    state = [...state, newEvent];
    _saveEvent(state);
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
