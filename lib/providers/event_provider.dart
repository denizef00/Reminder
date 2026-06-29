import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/event_model.dart';

part 'event_provider.g.dart';

@riverpod
class EventList extends _$EventList {
  @override
  List<EventModel> build() {
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
  }

  void deleteEvent(String id) {
    state = state.where((event) => event.id != id).toList();
  }

  void toggleCheck(String id) {
    state = state.map((event) {
      if (event.id == id) {
        return event.copyWith(isCompleted: !event.isCompleted);
      }
      return event;
    }).toList();
  }
}
