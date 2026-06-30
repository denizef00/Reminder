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
  }
}
